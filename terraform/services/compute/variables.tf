/**
 * EC2 instance + SG variables
 */
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "tiny-ec2"
}

variable "instance_type" {
  description = "EC2 instance type (free tier eligible: t2.micro)"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Existing SSH key pair name to connect to the instance"
  type        = string
}

variable "env" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH and ping the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
