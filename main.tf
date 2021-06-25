locals {
  enabled                   = module.this.enabled
  account_status            = local.account_enabled ? "ENABLED" : "PAUSED"
  admin_org_account_enabled = local.enabled && var.admin_org_account_enabled
  member_enabled            = local.enabled && length(var.member) > 0
  custom_data_identifiers   = local.enabled && length(var.custom_data_identifiers) > 0 ? { for cdi in flatten(var.custom_data_identifiers) : cdi.name => cdi } : {}
  classification_jobs       = local.enabled && length(var.classification_jobs) > 0 ? { for job in flatten(var.classification_jobs) : job.name => job } : {}
  findings_filters          = local.enabled && length(var.findings_filters) > 0 ? { for ff in flatten(var.findings_filters) : ff.name => ff } : {}
}

resource "aws_macie2_account" "primary" {
  count    = local.enabled ? 1 : 0
  provider = "aws.primary"

  finding_publishing_frequency = var.finding_publishing_frequency
  status                       = local.account_status
}

data "aws_caller_identity" "primary" {
  count    = local.admin_account_enabled ? 1 : 0
  provider = "aws.primary"
}

resource "aws_macie2_organization_admin_account" "default" {
  count    = local.admin_account_enabled ? 1 : 0
  provider = "aws.admin"

  admin_account_id = one(data.aws_caller_identity.primary[*].account_id)

  depends_on = [
    aws_macie2_account.primary
  ]
}

module "member_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = [replace(var.member["email"], "/[[:punct:]]/", "-")]
  tags       = lookup(var.member, "tags", null)
  context    = module.this.context
  enabled    = local.member_enabled
}

resource "aws_macie2_account" "member" {
  count = local.member_enabled ? 1 : 0
}

resource "aws_macie2_member" "primary" {
  count    = local.member_enabled ? 1 : 0
  provider = "aws.primary"

  account_id                            = var.member["account_id"]
  email                                 = var.member["email"]
  invite                                = lookup(var.member, "invite", null)
  invitation_message                    = lookup(var.member, "invitation_message", null)
  invitation_disable_email_notification = lookup(var.member, "invitation_disable_email_notification", null)
  status                                = lookup(var.member, "status", "ENABLED")
  tags                                  = module.member_label.tags

  depends_on = [
    aws_macie2_account.primary,
    aws_macie2_account.member
  ]
}

resource "aws_macie2_invitation_accepter" "member" {
  count = local.member_enabled ? 1 : 0

  administrator_account_id = one(data.aws_macie2_organization_primary_account.default[*].id)

  depends_on = [
    aws_macie2_account.primary,
    aws_macie2_account.member
  ]
}
