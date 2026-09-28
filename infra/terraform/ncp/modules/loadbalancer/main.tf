// MARK: - Public Application Load Balancer

resource "ncloud_lb" "web" {
  name        = "${var.resource_prefix}-alb"
  description = "Public Application Load Balancer for the Web service"

  type            = "APPLICATION"
  network_type    = "PUBLIC"
  throughput_type = "SMALL"
  idle_timeout    = 60

  subnet_no_list = [
    var.alb_subnet_no,
  ]
}

// MARK: - Web Target Group

resource "ncloud_lb_target_group" "web" {
  name        = "${var.resource_prefix}-tg-web"
  description = "Target group for the private Web server"

  vpc_no     = var.vpc_no
  target_type = "VSVR"
  protocol    = "HTTP"
  port        = 3000

  algorithm_type    = "RR"
  use_sticky_session = false
  use_proxy_protocol = false

  health_check {
    protocol       = "HTTP"
    http_method    = "GET"
    port           = 3000
    url_path       = "/health"
    cycle          = 30
    up_threshold   = 2
    down_threshold = 2
  }
}

// MARK: - Web 서버 연결

resource "ncloud_lb_target_group_attachment" "web" {
  target_group_no = ncloud_lb_target_group.web.id

  target_no_list = [
    var.web_server_instance_no,
  ]
}

// MARK: - HTTP Listener

resource "ncloud_lb_listener" "http" {
  load_balancer_no = ncloud_lb.web.id
  target_group_no  = ncloud_lb_target_group.web.id

  protocol = "HTTP" # NOTE: - TLS 인증서 없음(HTTP로만 진행)
  port     = 80
}