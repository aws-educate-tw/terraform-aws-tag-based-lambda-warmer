module "ambda-warmer" {
  source = "../.."

  aws_region  = "us-east-1"
  environment = "dev"

  # Custom prewarm tag key and value
  prewarm_tag_key   = "CustomPrewarmTag"   # The tag key to identify functions that need prewarming
  prewarm_tag_value = "CustomPrewarmValue" # The expected value of the tag for functions that need prewarming
}
