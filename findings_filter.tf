module "findings_filter_label" {
  for_each = local.findings_filters

  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = [each.key]
  tags       = lookup(each.value, "tags", null)
  context    = module.this.context
}

resource "aws_macie2_findings_filter" "default" {
  for_each = local.findings_filters

  name        = module.findings_filter_label[each.key].id
  description = lookup(each.value, "description", "Managed by Terraform")
  position    = lookup(each.value, "position", null)
  action      = each.value.action
  tags        = module.findings_filter_label[each.key].tags

  dynamic "finding_criteria" {
    for_each = lookup(each.value, "finding_criteria", null)

    content {
      criterion {
        field = "region"
        eq    = [data.aws_region.current.name]
      }
    }
  }

  depends_on = [
    aws_macie2_account.primary,
    aws_macie2_account.member
  ]
}
