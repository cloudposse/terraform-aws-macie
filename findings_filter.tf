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
        field          = finding_criteria.value.field
        eq_exact_match = lookup(each.value, "eq_exact_match", null)
        eq             = lookup(each.value, "eq", null)
        neq            = lookup(each.value, "neq", null)
        lt             = lookup(each.value, "lt", null)
        lte            = lookup(each.value, "lte", null)
        gt             = lookup(each.value, "gt", null)
        gte            = lookup(each.value, "gte", null)
      }
    }
  }

  depends_on = [
    aws_macie2_account.primary,
    aws_macie2_account.member
  ]
}
