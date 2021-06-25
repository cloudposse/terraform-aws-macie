output "primary_account_id" {
  description = "The ID of the Macie primary account."
  value       = one(aws_macie2_account.primary[*].id)
}

output "primary_account_service_role" {
  description = "The ARN of the Macie primary account."
  value       = one(aws_macie2_account.primary[*].service_role)
}

output "member_account_id" {
  description = "The ID of the Macie member account."
  value       = one(aws_macie2_account.member[*].id)
}

output "member_account_service_role" {
  description = "The ARN of the Macie member account."
  value       = one(aws_macie2_account.member[*].service_role)
}

output "admin_account_id" {
  description = "The ID of the Macie organization admin account."
  value       = one(aws_macie2_organization_admin_account.default[*].id)
}

output "classification_job_ids" {
  description = "The ID of the Macie Classification Jobs."
  value       = aws_macie2_classification_job.default[*].id
}

output "custom_data_identifier_ids" {
  description = "The ID of the Macie Custom Data Identifiers."
  value       = aws_macie2_custom_data_identifier.default[*].id
}

output "findings_filters_ids" {
  description = "The ID of the Macie Findings Filters."
  value       = aws_macie2_findings_filter.default[*].id
}

output "findings_filters_arns" {
  description = "The ARN of the Macie Findings Filters."
  value       = aws_macie2_findings_filter.default[*].arn
}
