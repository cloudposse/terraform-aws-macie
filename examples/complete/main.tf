module "macie" {
  source = "../.."

  providers = {
    aws       = aws
    aws.admin = aws.admin
  }

  context = module.this.context
}
