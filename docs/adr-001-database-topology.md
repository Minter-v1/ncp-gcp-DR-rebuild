# ADR-001: Cross-Cloud Database Topology

- Status: Accepted
- Date: 2026-09-28
- Scope: DR Lab

## Context

Greentech WAS는 MySQL 8.4와 Flyway를 사용하며 25개 InnoDB 테이블을 관리합니다. 프로젝트는 NCP 장애 시 GCP에서 읽기와 쓰기를 모두 복구하고 RPO·Database RTO·복제 지연·Failback 시간을 측정해야 합니다.

다음 요구사항을 우선합니다.

- 3일 안에 생성·복제·승격·Failback을 반복 검증할 수 있어야 함
- 복제 상태와 장애 원인을 직접 관찰할 수 있어야 함
- Terraform과 Ansible로 재구축 가능해야 함
- 실험 종료 후 모든 과금 리소스를 제거할 수 있어야 함
- NCP와 GCP의 관리형 서비스 제약에 종속되지 않아야 함

## Decision

MySQL 8.4를 두 클라우드의 VM에 직접 배치하고 GTID 기반 단방향 비동기 복제를 구성합니다.

```text
NCP VM
└── MySQL 8.4 Primary
    └── GTID + ROW Binlog + TLS
        └── GCP Compute Engine
            └── MySQL 8.4 Standby
```

평상시 NCP Primary만 쓰기를 허용합니다. GCP Standby는 `super_read_only` 상태로 복제하고 장애 전환 시 복제 적용 상태를 확인한 뒤 쓰기 가능한 Primary로 승격합니다.

초기 구현은 MySQL 기본 비동기 복제를 사용합니다. Semisynchronous Replication은 Before/After 비교에서 RPO 개선 실험이 필요할 때 별도 적용합니다.

## Required MySQL Configuration

### NCP Primary

```ini
[mysqld]
server_id=1
log_bin=mysql-bin
binlog_format=ROW
gtid_mode=ON
enforce_gtid_consistency=ON
binlog_expire_logs_seconds=604800
```

### GCP Standby

```ini
[mysqld]
server_id=2
relay_log=relay-bin
log_bin=mysql-bin
log_replica_updates=ON
binlog_format=ROW
gtid_mode=ON
enforce_gtid_consistency=ON
read_only=ON
super_read_only=ON
skip_replica_start=ON
```

`log_replica_updates`는 GCP 승격 후 NCP로 역복제하는 Failback 경로에 필요합니다.

## Replication Security

- 전용 복제 계정에는 복제에 필요한 최소 권한만 부여
- 복제 계정은 TLS 연결을 필수로 설정
- 인증서와 키는 Git에 저장하지 않음
- NCP ACG와 GCP Firewall에서 DB 포트를 Replica 주소로 제한
- 애플리케이션 계정과 복제 계정을 분리
- 실제 비밀값은 런타임에 주입

MySQL 공식 문서는 GTID 복제에 `gtid_mode=ON`, `enforce_gtid_consistency=ON`, Source의 Binary Log와 Replica의 Auto Position 구성을 요구합니다. 클라우드 간 전송 데이터는 암호화된 복제 연결로 보호합니다.

## Failover Sequence

```text
NCP 장애 감지
→ NCP 애플리케이션 쓰기 중단 확인
→ GCP Standby의 Replica IO·SQL 상태 확인
→ 잔여 Relay Log 적용 확인
→ 복제 중지
→ super_read_only 해제
→ GCP WAS의 Writer Endpoint 전환
→ 읽기·쓰기 Smoke Test
→ Cloudflare 트래픽 전환
```

Split Brain을 방지하기 위해 NCP Primary의 쓰기 차단 또는 장애 격리를 확인하기 전에는 GCP Standby를 승격하지 않습니다.

## Failback Sequence

```text
NCP DB 재구축
→ GCP Primary 기준 데이터 동기화
→ NCP를 GCP의 Replica로 구성
→ 복제 지연 0 확인
→ NCP 애플리케이션 연결 준비
→ 쓰기 정지 구간 설정
→ NCP 승격
→ 애플리케이션·트래픽 원복
```

Failback은 기존 NCP 서버를 곧바로 재사용하지 않고 GCP의 최신 데이터로 다시 동기화한 뒤 수행합니다.

## Alternatives Considered

### NCP Cloud DB for MySQL → Cloud SQL External Replica

Cloud SQL은 외부 MySQL 서버에서 연속 복제하고 Replica를 승격하는 구성을 지원합니다. 그러나 관리형 서비스별 권한과 복제 제약을 동시에 다뤄야 하며, 짧은 실험에서 역복제와 반복적인 Failback을 자동화하기 어렵습니다.

### MySQL StatefulSet on GKE

구성 요소 수는 줄지만 Node·Volume·Database 장애 영역이 Kubernetes 클러스터에 함께 묶입니다. 애플리케이션 확장 실험과 DB 영속성 실험의 실패 원인을 분리하기 어려워 선택하지 않습니다.

### 동일 초기 데이터만 배치

서비스 전환은 시연할 수 있지만 RPO와 데이터 정합성을 검증할 수 없어 프로젝트 목표를 충족하지 않습니다.

## Consequences

### Positive

- 복제와 승격 상태를 SQL과 로그로 직접 관찰 가능
- 동일한 MySQL 버전과 설정으로 환경 차이를 줄임
- Terraform·Ansible·Docker로 재현 가능
- 역복제를 포함한 Failback 실험 가능
- 관리형 DB보다 짧은 실험 기간의 비용 통제가 쉬움

### Negative

- 백업·패치·복제·승격을 직접 운영해야 함
- 자동 Failover를 직접 구현하지 않음
- 단일 VM 장애에 대한 DB 내부 HA를 제공하지 않음
- 운영 환경에 그대로 적용하기보다 DR 메커니즘 검증용 설계에 가까움

## Validation

- `SHOW REPLICA STATUS`와 Performance Schema에서 IO·SQL Thread 확인
- GTID Set 비교를 통한 반영 상태 확인
- Primary에 검증 트랜잭션을 지속 기록하며 복제 지연 측정
- 장애 직전 마지막 Transaction ID와 Standby 반영 ID 비교
- 승격 후 신규 쓰기와 기존 데이터 조회 확인
- Failback 후 양쪽 Checksum과 핵심 업무 레코드 비교

## References

- [MySQL 8.4: Setting Up Replication Using GTIDs](https://dev.mysql.com/doc/refman/8.4/en/replication-gtids-howto.html)
- [MySQL 8.4: Replication Security](https://dev.mysql.com/doc/refman/8.4/en/replication-security.html)
- [MySQL 8.4: Encrypted Replication Connections](https://dev.mysql.com/doc/refman/8.4/en/replication-encrypted-connections.html)
- [Google Cloud SQL: Replication from an External Server](https://docs.cloud.google.com/sql/docs/mysql/replication/external-server)
