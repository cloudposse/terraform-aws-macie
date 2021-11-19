output "account_id" {
  description = "The ID of the Macie account."
  value       = module.macie.account_id
}

output "account_service_role_arn" {
  description = "The service role ARN of the Macie account."
  value       = module.macie.account_service_role_arn
}

output "org_admin_account_ids" {
  description = "List of IDs of the Macie organization admin accounts."
  value       = module.macie.org_admin_account_ids
}

output "aws_account_to_org_admin_account_ids" {
  description = "Map of the AWS account IDs to Macie organization admin account IDs"
  value       = module.macie.aws_account_to_org_admin_account_ids
}

output "member_accounts" {
  description = "List of AWS account IDs the Macie Admin is managing"
  value       = module.macie.member_accounts
}
