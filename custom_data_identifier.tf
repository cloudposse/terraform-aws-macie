module "custom_data_identifier_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  for_each = local.custom_data_identifiers

  attributes = [each.key]
  tags       = lookup(each.value, "tags", null)
  context    = module.this.context
}

resource "aws_macie2_custom_data_identifier" "default" {
  for_each = local.custom_data_identifiers

  name                   = module.custom_data_identifier_label[each.key].id
  description            = lookup(each.value, "description", "Managed by Terraform")
  regex                  = lookup(each.value, "regex", null)
  keywords               = lookup(each.value, "keywords", null)
  ignore_words           = lookup(each.value, "ignore_words", null)
  maximum_match_distance = lookup(each.value, "maximum_match_distance", null)
  tags                   = module.custom_data_identifier_label[each.key].tags

  depends_on = [
    aws_macie2_account.default
  ]
}
