provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "primary"
  region = var.region
}

module "macie" {
  source = "../.."

  context = module.this.context

  providers = {
    aws.primary = aws.primary
  }
}
