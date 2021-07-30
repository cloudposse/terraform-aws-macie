output "account_id" {
  description = "The ID of the Macie account."
  value       = join("", aws_macie2_account.default.*.id)
}

output "account_service_role_arn" {
  description = "The service role ARN of the Macie account."
  value       = join("", aws_macie2_account.default.*.service_role)
}

output "org_admin_account_ids" {
  description = "List of IDs of the Macie organization admin accounts."
  value = [
    for i in aws_macie2_account.default :
    i.id
    if length(local.admin_account_ids) > 0
  ]
}

output "aws_account_to_org_admin_account_ids" {
  description = "Map of the AWS account IDs to Macie organization admin account IDs"
  value = {
    for i in aws_macie2_organization_admin_account.default :
    i.admin_account_id => i.id
    if length(local.admin_account_ids) > 0
  }
}

output "member_accounts" {
  description = "List of AWS account IDs the Macie Admin is managing"
  value = [
    for i in aws_macie2_member.default :
    i.id
  ]
}
