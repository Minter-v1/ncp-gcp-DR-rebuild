# Application Baseline

## Source Repositories

| Layer | Repository | Role |
|---|---|---|
| Web | [Minter-v1/greentech-web](https://github.com/Minter-v1/greentech-web) | HRMS 사용자 인터페이스와 BFF |
| WAS | [Minter-v1/greentech-was](https://github.com/Minter-v1/greentech-was) | 인증·인사·근태·휴가·급여·첨부파일 API |

분석 기준 커밋은 Web `dab14ca`, WAS `7db818c`입니다.

## Runtime Baseline

| Layer | Technology | Runtime | Container Port | Health Endpoint |
|---|---|---|---|---|
| Web | Next.js 16.3.1, React 19.2.8, TypeScript | Node.js 24 Alpine | `3000` | `/health` |
| WAS | Spring Boot 4.1.0, Java 21, Spring Data JPA | Eclipse Temurin 21 JRE | `41783` | `/actuator/health/liveness` |
| Database | MySQL 8.4, InnoDB | MySQL Container 또는 관리형 DB | `3306` | `mysqladmin ping` |
| Schema | Flyway | `V1__init_schema.sql`, `V2__seed_master_data.sql` | - | Migration 성공 여부 |

두 애플리케이션 모두 멀티스테이지 Dockerfile을 제공하며 비루트 사용자로 실행됩니다. WAS 저장소의 Docker Compose는 MySQL과 WAS의 로컬 통합 실행 기준으로 재사용할 수 있습니다.

## Stateless Assessment

### Web

- WAS가 발급한 JWT를 `gt_session` HTTP-only 쿠키에 저장
- 서버 메모리 기반 세션 저장소 없음
- `WAS_BASE_URL` 환경변수로 WAS 연결 대상 결정
- Server Action과 Route Handler가 WAS API를 호출
- 브라우저가 특정 Web 인스턴스에 고정될 필요 없음

### WAS

- Spring Security의 `STATELESS` 세션 정책 사용
- JWT 기반 인증으로 WAS 인스턴스 간 세션 공유 불필요
- 데이터 영속성은 MySQL과 Object Storage에 위임
- Flyway가 스키마를 소유하고 Hibernate는 `validate`만 수행
- Graceful Shutdown과 Actuator Probe 지원

Web과 WAS는 수평 확장에 적합하지만 DB와 첨부파일 저장소가 서비스 연속성의 필수 의존성입니다.

## Database Baseline

| Item | Finding |
|---|---|
| Engine | MySQL 8.4 |
| Storage Engine | InnoDB |
| Tables | 25 |
| Foreign Keys | 25 |
| Unique Keys | 15 |
| Identifier Strategy | 24개 Entity에서 `IDENTITY` 사용 |
| Transaction Boundary | Spring `@Transactional` 기반 |
| Schema Management | Flyway |
| Stored Program | Trigger·Procedure·Event 없음 |
| Vendor-Specific Data Type | 일반적인 MySQL 타입 중심, `TEXT` 사용 |

초기 스키마는 조직·사원·근태·휴가·연장근무·급여·계정·감사 로그를 포함합니다. DB DR 검증에서는 단순 연결 성공이 아니라 업무 트랜잭션의 복제 여부를 확인해야 합니다.

## DR-Critical Data Paths

### Authentication

```text
Browser
→ Web HTTP-only Cookie
→ Web Server Action
→ WAS Bearer Token 검증
→ MySQL 계정·권한 조회
```

모든 환경에서 동일한 `JWT_SECRET`과 `FIELD_ENCRYPTION_KEY`를 안전하게 주입해야 합니다. 두 값이 달라지면 Failover 후 기존 토큰 검증과 암호화 필드 복호화가 실패합니다.

### Database Write

```text
User Request
→ Web
→ WAS Transaction
→ NCP Primary MySQL
→ GCP Standby MySQL Replication
```

장애 실험에서는 Primary에 기록한 검증용 트랜잭션 ID와 시각을 별도로 남기고 Standby 반영 여부를 비교합니다.

### Attachment

```text
Metadata
→ MySQL attachment table

Binary Object
→ NCP Object Storage 또는 DR 공용 Object Storage
```

DB 레코드만 복제해도 객체가 GCP에서 조회되지 않으면 서비스 DR은 불완전합니다. 첨부파일은 양쪽 환경에서 접근 가능한 저장소를 사용하거나 객체 복제 전략을 별도로 마련해야 합니다.

## Required Adaptations

| Area | Current State | DR Adaptation |
|---|---|---|
| Web health check | Dockerfile이 `/login` 확인 | Kubernetes Probe는 공개 `/health` 사용 |
| Web public URL | 코드에서 `WEB_PUBLIC_ORIGIN` 참조 | 환경변수 예시에 추가하고 클라우드별 Origin 주입 |
| WAS connection | 단일 `WAS_BASE_URL` | 환경별 Service DNS 또는 내부 LB 주소 주입 |
| DB connection | 단일 JDBC URL | 승격된 Writer Endpoint로 전환 가능한 구성 필요 |
| DB migration | WAS 시작 시 Flyway 실행 | 복제 환경에서 단일 Writer만 Migration 수행 |
| File storage | Local 또는 NCP Object Storage | GCP Failover 시 객체 접근 경로 검증 필요 |
| Observability | 파일 로그와 Actuator 제공 | Prometheus Scrape와 Loki 수집 경로 표준화 |
| Instance identity | 응답에서 실행 위치 식별 불가 | DR Probe용 cloud·instance 식별 응답 추가 필요 |
| Fault injection | 정상 기능만 제공 | 부하·지연·오류 실험용 별도 테스트 경로 필요 |

## Deployment Mapping

### NCP Active

```text
NCP VM
├── greentech-web
├── greentech-was
├── MySQL Primary
└── 로그 수집 에이전트
```

Docker Compose를 사용해 Active 환경을 최소 구성합니다. 데이터베이스 파일과 애플리케이션 로그는 명시적인 Volume으로 분리합니다.

### GCP Warm Standby

```text
GKE
├── greentech-web
├── greentech-was
├── Argo CD
├── Argo Rollouts
└── Observability

GCP Database Layer
└── MySQL Standby
```

Web과 WAS는 GKE에 배포합니다. MySQL Standby의 실행 위치는 복제·승격·Failback 방식과 비용을 비교한 뒤 결정합니다.

## Acceptance Criteria

애플리케이션 DR 성공은 다음 상태를 모두 만족할 때 인정합니다.

1. Cloudflare가 GCP Web으로 요청을 전달
2. GCP Web이 GCP WAS에 연결
3. GCP WAS가 승격된 MySQL Writer에 연결
4. 기존 사용자의 인증 토큰을 정상 검증
5. 장애 직전 기준 데이터의 조회 결과 일치
6. 승격 후 신규 쓰기 트랜잭션 성공
7. 첨부파일 메타데이터와 객체 조회 성공
8. 메트릭과 로그에서 전환 과정을 추적 가능

## Open Architecture Decisions

아래 항목은 IaC 작성 전에 근거를 남기고 확정합니다.

- NCP Primary MySQL을 VM Container로 둘지 Cloud DB for MySQL로 둘지
- GCP Standby MySQL을 Compute Engine에 둘지 관리형 서비스로 둘지
- MySQL 비동기 복제의 GTID·TLS·복제 계정 정책
- Writer Endpoint 전환을 DNS로 처리할지 애플리케이션 설정 재주입으로 처리할지
- 첨부파일을 공용 Object Storage로 유지할지 클라우드 간 복제할지
- Failback 시 역복제와 데이터 충돌 방지 절차
