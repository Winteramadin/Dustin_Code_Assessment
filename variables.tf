variable "ip_range" {}

# variable "ami" {
#   type = map(any)
#   default = {
#     "us-east-1" = "ami-0aa7d40eeae50c9a9"
#     "us-east-1" = "ami-0aa7d40eeae50c9a9"
#   }
# }

variable "ec2name" {
  type    = list(any)
  default = ["nginx-1", "nginx-2"]
}

variable "region" {
  default = "eu-west-2"
}


variable "sg_ports" {
  type    = list(number)
  default = [22, 80, 8080]
}
