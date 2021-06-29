output "primary_account_id" {
  description = "The ID of the Macie primary account."
  value       = module.macie.primary_account_id
}

output "primary_account_service_role" {
  description = "The ARN of the Macie primary account."
  value       = module.macie.primary_account_service_role
}

output "member_account_id" {
  description = "The ID of the Macie member account."
  value       = module.macie.member_account_id
}

output "member_account_service_role" {
  description = "The ARN of the Macie member account."
  value       = module.macie.member_account_service_role
}

output "admin_account_id" {
  description = "The IDs of the Macie organization admin account."
  value       = module.macie.admin_account_id
}

output "classification_job_ids" {
  description = "The IDs of the Macie Classification Jobs."
  value       = module.macie.classification_job_ids
}

output "custom_data_identifier_ids" {
  description = "The IDs of the Macie Custom Data Identifiers."
  value       = module.macie.classification_job_ids
}

output "findings_filters_ids" {
  description = "The IDs of the Macie Findings Filters."
  value       = module.macie.findings_filters_ids
}

output "findings_filters_arns" {
  description = "The ARNs of the Macie Findings Filters."
  value       = module.macie.findings_filters_arns
}
