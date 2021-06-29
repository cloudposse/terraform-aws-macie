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
  description = "The IDs of the Macie Classification Jobs."
  value = [
    for job in aws_macie2_classification_job.default :
    job.id
  ]
}

output "custom_data_identifier_ids" {
  description = "The IDs of the Macie Custom Data Identifiers."
  value = [
    for cdi in aws_macie2_custom_data_identifier.default :
    cdi.id
  ]
}

output "findings_filters_ids" {
  description = "The IDs of the Macie Findings Filters."
  value = [
    for ff in aws_macie2_findings_filter.default :
    ff.id
  ]
}

output "findings_filters_arns" {
  description = "The ARNs of the Macie Findings Filters."
  value = [
    for ff in aws_macie2_findings_filter.default :
    ff.arn
  ]
}
