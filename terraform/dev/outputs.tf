output "bastion_external_ip" {
  value       = aws_instance.bastion.public_ip
  description = "Bastion instance public ip"
}

output "web_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Web instance public ip"
}

output "web_private_ip" {
  value       = aws_instance.web.private_ip
  description = "Web instance private ip"
}

output "elasticsearch_instance_id" {
  value       = module.elasticsearch.instance_id
  description = "Elasticsearch EC2 instance ID"
}

output "elasticsearch_private_ip" {
  value       = module.elasticsearch.private_ip
  description = "Elasticsearch private ip"
}

output "elasticsearch_private_url" {
  value       = module.elasticsearch.elasticsearch_url
  description = "Elasticsearch private url"
}

output "rds_endpoint" {
  value       = aws_db_instance.rds_demo.address
  description = "RDS endpoint"
}

output "connect_web" {
  value       = "ssh -J ubuntu@${aws_instance.bastion.public_ip} ubuntu@${aws_instance.web.private_ip}"
  description = "Web instance connection example"
}