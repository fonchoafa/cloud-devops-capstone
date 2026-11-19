output "public_ip" {
  description = "Fixed public IP (Elastic IP) of the server"
  value       = aws_eip.app.public_ip
}

output "live_url" {
  description = "The live website (use this on the portal and as the LIVE_URL variable in GitHub)"
  value       = "http://${aws_eip.app.public_ip}"
}

output "health_url" {
  value = "http://${aws_eip.app.public_ip}/health"
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/id_ed25519 ubuntu@${aws_eip.app.public_ip}"
}

output "prometheus_tunnel" {
  description = "Run this, then open http://localhost:9090 (Prometheus is not exposed to the internet)"
  value       = "ssh -i ~/.ssh/id_ed25519 -L 9090:localhost:9090 ubuntu@${aws_eip.app.public_ip}"
}

output "notes_table" {
  value = aws_dynamodb_table.notes.name
}

output "uploads_bucket" {
  value = aws_s3_bucket.uploads.bucket
}

output "log_group" {
  value = aws_cloudwatch_log_group.app.name
}

output "admin_key_command" {
  description = "Run this to read the admin key (the value itself is never printed here)"
  value       = "aws ssm get-parameter --name ${local.secret_param} --with-decryption --query Parameter.Value --output text --region ${var.region}"
}
