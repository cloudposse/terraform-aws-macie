module "classification_job_label" {
  for_each = local.classification_jobs

  source  = "cloudposse/label/null"
  version = "0.24.1"

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
  custom_data_identifier_ids = try(concat(lookup(each.value, "custom_data_identifier_ids", []), [for job in lookup(each.value, "custom_data_identifier_names", []) : aws_macie2_custom_data_identifier.default[job].id]), null)


  dynamic "schedule_frequency" {
    for_each = lookup(each.value, "schedule_frequency", null) != null ? [each.value.schedule_frequency] : []

    content {
      daily_schedule   = lookup(schedule_frequency.value, "daily_schedule", null)
      weekly_schedule  = lookup(schedule_frequency.value, "weekly_schedule", null)
      monthly_schedule = lookup(schedule_frequency.value, "monthly_schedule", null)
    }
  }


  dynamic "s3_job_definition" {
    for_each = lookup(each.value, "s3_job_definition", null) != null ? [each.value.s3_job_definition] : []

    content {
      dynamic "bucket_definitions" {
        for_each = lookup(s3_job_definition.value, "bucket_definitions", null) != null ? [s3_job_definition.value.bucket_definitions] : []

        content {
          account_id = bucket_definitions.value.account_id
          buckets    = bucket_definitions.value.buckets
        }
      }

      dynamic "scoping" {
        for_each = lookup(s3_job_definition.value, "scoping", null) != null ? [s3_job_definition.value.scoping] : []

        content {
          dynamic "excludes" {
            for_each = lookup(scoping.value, "excludes", null) != null ? [scoping.value.excludes] : []

            content {
              dynamic "and" {
                for_each = lookup(excludes.value, "and", null) != null ? [excludes.value.and] : []

                content {
                  dynamic "simple_scope_term" {
                    for_each = lookup(and.value, "simple_scope_term", null) != null ? [and.value.simple_scope_term] : []

                    content {
                      comparator = lookup(simple_scope_term.value, "comparator", null)
                      values     = lookup(simple_scope_term.value, "values", null)
                      key        = lookup(simple_scope_term.value, "key", null)
                    }
                  }

                  dynamic "tag_scope_term" {
                    for_each = lookup(and.value, "tag_scope_term", null) != null ? [and.value.tag_scope_term] : []

                    content {
                      comparator = lookup(tag_scope_term.value, "comparator", null)
                      tag_values = lookup(tag_scope_term.value, "tag_values", null)
                      key        = lookup(tag_scope_term.value, "key", null)
                      target     = lookup(tag_scope_term.value, "target", null)
                    }
                  }
                }
              }
            }
          }

          dynamic "includes" {
            for_each = lookup(scoping.value, "includes", null) != null ? [scoping.value.includes] : []

            content {
              dynamic "and" {
                for_each = lookup(includes.value, "and", null) != null ? [includes.value.and] : []

                content {
                  dynamic "simple_scope_term" {
                    for_each = lookup(and.value, "simple_scope_term", null) != null ? [and.value.simple_scope_term] : []

                    content {
                      comparator = lookup(simple_scope_term.value, "comparator", null)
                      values     = lookup(simple_scope_term.value, "values", null)
                      key        = lookup(simple_scope_term.value, "key", null)
                    }
                  }

                  dynamic "tag_scope_term" {
                    for_each = lookup(and.value, "tag_scope_term", null) != null ? [and.value.tag_scope_term] : []

                    content {
                      comparator = lookup(tag_scope_term.value, "comparator", null)
                      tag_values = lookup(tag_scope_term.value, "tag_values", null)
                      key        = lookup(tag_scope_term.value, "key", null)
                      target     = lookup(tag_scope_term.value, "target", null)
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
    aws_macie2_account.primary,
    aws_macie2_account.member,
    time_sleep.wait_for_macie_account
  ]
}
