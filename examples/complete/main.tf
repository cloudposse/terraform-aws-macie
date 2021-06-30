provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "primary"
  region = var.region
}

data "aws_caller_identity" "current" {}

module "s3_bucket" {
  source  = "cloudposse/s3-bucket/aws"
  version = "0.39.0"

  acl                = "private"
  user_enabled       = false
  versioning_enabled = false

  context = module.this.context
}

module "macie" {
  source = "../.."

  admin_org_account_enabled = false

  classification_jobs = [
    {
      name                = "s3-scan"
      job_type            = "SCHEDULED"
      initial_run         = false
      sampling_percentage = 100

      s3_job_definition = {
        bucket_definitions = {
          account_id = data.aws_caller_identity.current.account_id
          buckets    = [module.s3_bucket.bucket_id]
        }

        scoping = {
          excludes = {
            and = {
              simple_scope_term = {
                comparator = "EQ"
                key        = "OBJECT_EXTENSION"
                values     = ["test1"]
              }
            }
          }
          includes = {
            and = {
              simple_scope_term = {
                comparator = "EQ"
                key        = "OBJECT_EXTENSION"
                values     = ["test2"]
              }
            }
          }
        }
      }

      schedule_frequency = {
        daily_schedule = true
      }
    }
  ]

  custom_data_identifiers = [
    {
      name                   = "callsigns"
      regex                  = "[0-9]{3}-[0-9]{2}-[0-9]{4}"
      maximum_match_distance = 10
      keywords               = ["alpha", "bravo"]
      ignore_words           = ["omega"]
    }
  ]

  findings_filters = [
    {
      name     = "sample"
      position = 1
      action   = "ARCHIVE"
      finding_criterias = [
        {
          field = "region"
          eq    = [var.region]
        },
        {
          field = "sample"
          neq   = ["some-sample", "another-sample"]
        }
      ]
    }
  ]

  context = module.this.context

  providers = {
    aws.primary = aws.primary
  }
}
