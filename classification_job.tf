module "classification_job_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  for_each = local.classification_jobs

  attributes = [each.key]
  tags       = lookup(each.value, "tags", null)
  context    = module.this.context
}

resource "aws_macie2_classification_job" "default" {
  for_each = local.classification_jobs

  name                       = module.classification_job_label[each.key].id
  tags                       = module.classification_job_label[each.key].tags
  sampling_percentage        = lookup(each.value, "sampling_percentage", null)
  initial_run                = lookup(each.value, "initial_run", null)
  job_type                   = each.value.job_type
  job_status                 = lookup(each.value, "job_status", null)
  custom_data_identifier_ids = lookup(each.value, "custom_data_identifier_ids", null)


  dynamic "schedule_frequency" {
    for_each = lookup(each.value, "schedule_frequency", null) != null ? [1] : []

    content {
      daily_schedule   = lookup(schedule_frequency.value, "daily_schedule", null)
      weekly_schedule  = lookup(schedule_frequency.value, "weekly_schedule", null)
      monthly_schedule = lookup(schedule_frequency.value, "monthly_schedule", null)
    }
  }


  dynamic "s3_job_definition" {
    for_each = lookup(each.value, "s3_job_definition", null) != null ? [1] : []

    content {
      dynamic "bucket_definitions" {
        for_each = lookup(s3_job_definition.value, "bucket_definitions", null) != null ? [1] : []

        content {
          account_id = bucket_definitions.value.account_id
          buckets    = bucket_definitions.value.buckets
        }
      }

      dynamic "scoping" {
        for_each = lookup(s3_job_definition.value, "scoping", null) != null ? [1] : []

        content {
          dynamic "excludes" {
            for_each = lookup(scoping.value, "excludes", null) != null ? [1] : []

            content {
              dynamic "and" {
                for_each = lookup(excludes.value, "and", null) != null ? [1] : []

                content {
                  dynamic "simple_scope_term" {
                    for_each = lookup(and.value, "simple_scope_term", null) != null ? [1] : []

                    content {
                      comparator = lookup(simple_scope_term.value, "comparator", null)
                      values     = lookup(simple_scope_term.value, "values", null)
                      key        = lookup(simple_scope_term.value, "key", null)
                    }
                  }

                  dynamic "tag_scope_term" {
                    for_each = lookup(and.value, "tag_scope_term", null) != null ? [1] : []

                    content {
                      comparator = lookup(tag_scope_term.value, "comparator", null)

                      dynamic "tag_values" {
                        for_each = lookup(tag_scope_term.value, "tag_values", null) != null ? [1] : []
                        content {
                          value = lookup(tag_values.value, "value", null)
                          key   = lookup(tag_values.value, "key", null)
                        }
                      }

                      key    = lookup(tag_scope_term.value, "key", null)
                      target = lookup(tag_scope_term.value, "target", null)
                    }
                  }
                }
              }
            }
          }

          dynamic "includes" {
            for_each = lookup(scoping.value, "includes", null) != null ? [1] : []

            content {
              dynamic "and" {
                for_each = lookup(includes.value, "and", null) != null ? [1] : []

                content {
                  dynamic "simple_scope_term" {
                    for_each = lookup(and.value, "simple_scope_term", null) != null ? [1] : []

                    content {
                      comparator = lookup(simple_scope_term.value, "comparator", null)
                      values     = lookup(simple_scope_term.value, "values", null)
                      key        = lookup(simple_scope_term.value, "key", null)
                    }
                  }

                  dynamic "tag_scope_term" {
                    for_each = lookup(and.value, "tag_scope_term", null) != null ? [1] : []

                    content {
                      comparator = lookup(tag_scope_term.value, "comparator", null)

                      dynamic "tag_values" {
                        for_each = lookup(tag_scope_term.value, "tag_values", null) != null ? [1] : []
                        content {
                          value = lookup(tag_values.value, "value", null)
                          key   = lookup(tag_values.value, "key", null)
                        }
                      }

                      key    = lookup(tag_scope_term.value, "key", null)
                      target = lookup(tag_scope_term.value, "target", null)
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    aws_macie2_account.default
  ]
}
