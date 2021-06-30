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

  finding_criteria {
    dynamic "criterion" {
      for_each = [for fc in each.value.finding_criterias :
        {
          field          = fc.field
          eq_exact_match = try(fc.eq_exact_match, null)
          eq             = try(fc.eq, null)
          neq            = try(fc.neq, null)
          lt             = try(fc.lt, null)
          lte            = try(fc.lte, null)
          gt             = try(fc.gt, null)
          gte            = try(fc.gte, null)
        }
      ]

      content {
        field          = criterion.value.field
        eq_exact_match = lookup(criterion.value, "eq_exact_match", null)
        eq             = lookup(criterion.value, "eq", null)
        neq            = lookup(criterion.value, "neq", null)
        lt             = lookup(criterion.value, "lt", null)
        lte            = lookup(criterion.value, "lte", null)
        gt             = lookup(criterion.value, "gt", null)
        gte            = lookup(criterion.value, "gte", null)
      }
    }
  }

  depends_on = [
    aws_macie2_account.primary,
    aws_macie2_account.member,
    time_sleep.wait_for_macie_account
  ]
}
