output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.jenkins.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value = aws_instance.kube.private_ip
}

output "nat_gateway_ip" {
  value = aws_eip.nat_gateway.public_ip
}