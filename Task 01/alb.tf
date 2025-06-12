# Create a set of all the instances to put behind the load balancer
data "aws_instances" "target_web" {
  instance_tags = {
    Name = "${var.instance_name}0*"
  }
  instance_state_names = ["running", "stopped"]
}

# Creating External LoadBalancer
resource "aws_lb" "external-alb" {
  name               = "default-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.default_instance_sg.id]
  subnets            = var.web_subnet_cidrs

  tags = merge(
    var.default_tags,
    {
      Name = "${var.vpc_name} Default Application Load Balancer (External)"
    },
  )
}

resource "aws_lb_target_group" "target-elb" {
  for_each = {
    for listener in var.lb_listeners : "${listener.protocol}:${listener.target_port}" => listener
  }
  name     = "lb-${each.value.target_port}"
  port     = each.value.target_port
  protocol = each.value.protocol
  vpc_id   = aws_vpc.vpc.id
  health_check {
    port                = each.value.health_port
    protocol            = each.value.protocol
    interval            = 60
    unhealthy_threshold = 5
    healthy_threshold   = 3
  }
}

resource "aws_lb_target_group_attachment" "attachment" {
  for_each = {
    for pair in setproduct(keys(aws_lb_target_group.target-elb), data.aws_instances.target_web.ids) :
     "${pair[0]}:${pair[1]}" => {
      target_group = aws_lb_target_group.target-elb[pair[0]]
      instance_id  = pair[1]
    }
  }

  target_group_arn = each.value.target_group.arn
  target_id        = each.value.instance_id
  port             = each.value.target_group.target_port
}
