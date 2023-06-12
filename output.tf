 output "dustin_sg" {
 value = aws_security_group.dustin_sg.ingress
 }

output "ami_id" {
  value = aws_instance.myec2[*].ami
}

