output "instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.tiny_ec2.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.tiny_ec2.public_ip
}

output "security_group_id" {
  description = "ID of the security group associated with the instance"
  value       = aws_security_group.tiny_ec2_sg.id
}
