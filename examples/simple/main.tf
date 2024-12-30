module "ambda-warmer" {
  source = "../.."

  aws_region  = "us-east-1"
  environment = "dev"
}
