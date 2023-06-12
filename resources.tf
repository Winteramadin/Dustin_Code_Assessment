resource "aws_instance" "myec2" {
  instance_type          = "t2.micro"
  count                  = 2
  ami                    = "ami-0eb260c4d5475b901"
  vpc_security_group_ids = [aws_security_group.dustin_sg.id]
  key_name               = "dustin_demo"
  user_data              = <<EOF
  #!/bin/bash
  # installing nginx and overriding the default homepage.
  sudo apt update -y
  sudo apt-cache search apache
  sudo apt-get install apache2 -y
  sudo su -
  echo "<h1>Version 1.3.1 accessed from server $(hostname -f)</h1>" > /var/www/html/index.html
  exit

  EOF

  tags = {
    Name = element(var.ec2name, count.index)
  }
  # connection {
  #   type        = "ssh"
  #   user        = "ec2-user"
  #   private_key = file("./dustin_demo.pem")
  #   host        = self.public_ip
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install nginx -y"
  #   ]
  # }

  #   provisioner "local-exec" {
  #     command = "echo $PWD"
  #   }
}

resource "aws_security_group" "dustin_sg" {
  name = "dustin_sg"

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = [var.ip_range]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports

    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = [var.ip_range]
    }
  }
}

resource "aws_lb_target_group" "dustindemo" {
  name       = "dustin-demo"
  port       = 8080
  protocol   = "HTTP"
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 8081
    interval            = 30
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "dustin_tga" {
  for_each = aws_instance.myec2

  target_group_arn = aws_lb_target_group.dustindemo.arn
  target_id        = each.value.id
  port             = 8080
}

resource "aws_lb" "dustin-demo-lb" {
  name               = "dustin-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dustin_sg.id]
}