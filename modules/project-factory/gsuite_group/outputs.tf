output "domain" {
  value       = local.domain
  description = "The domain of the group's organization."
}

output "email" {
  description = "The email address of the group."
  value       = local.email
}

output "name" {
  description = "The username portion of the email address of the group."
  value       = var.name
}

