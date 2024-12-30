<!-- markdownlint-disable -->
<div align="center">
  <img src="./imgs/AWS Tag-based Lambda Warmer Archietecure Diagram.png" alt="cover">
</div>

<br>

<h1 align="center">Terraform Module tag-based-lambda-warmer</h1>

<p align="center">
  A Terraform module for deploying an automated Lambda function warming solution. This module helps prevent cold starts in your Lambda functions by periodically invoking them based on tags.
</p>

<p align="center">
  <a aria-label="License" href="https://github.com/aws-educate-tw/terraform-aws-tag-based-lambda-warmer/blob/main/LICENSE">
    <img alt="" src="https://img.shields.io/github/license/aws-educate-tw/terraform-aws-tag-based-lambda-warmer">
  </a>
  <a aria-label="Latest Release" href="https://github.com/aws-educate-tw/terraform-aws-tag-based-lambda-warmer/releases">
    <img alt="GitHub release" src="https://img.shields.io/github/v/release/aws-educate-tw/terraform-aws-tag-based-lambda-warmer">
  </a>
  <a aria-label="Terraform Registry" href="https://registry.terraform.io/modules/aws-educate-tw/tag-based-lambda-warmer/aws/latest">
    <img alt="Terraform Registry" src="https://img.shields.io/badge/Terraform-Module-blueviolet?logo=terraform">
  </a>
</p>
<!-- markdownlint-restore -->



## Overview

This module creates a Lambda function that automatically warms up other Lambda functions based on specified tags. It uses EventBridge Scheduler to trigger the warming process at regular intervals.

## Features

- Tag-based function selection for warming
- Configurable warming schedule
- Customizable tag key/value pairs for targeting functions
- Customizable Lambda Warmer function invocation type ( Event / RequestResponse )

## Usage

```hcl
module "lambda_warmer" {
  source = "../modules/lambda_warmer"

  aws_region = "ap-northeast-1"
  environment = "production"

  # Optional: Custom configuration
  prewarm_tag_key = "Project"
  prewarm_tag_value = "MyProject"
  lambda_schedule_expression = "rate(5 minutes)"
  scheduler_max_retry_attempts = 0
  invocation_type = "Event"
}
```

### Tagging Lambda Functions for Warming

To mark a Lambda function for warming, add the appropriate tags:

```hcl
resource "aws_lambda_function" "example" {
  # ... other configuration ...

  tags = {
    Prewarm = "true"  # Default tags
    # Or use custom tags as configured in the module
    Project = "MyProject"
  }
}
```

### Code Snippet for Handling Prewarming in Your Function

When a Lambda function is invoked for prewarming, it's important to differentiate prewarming requests from normal business logic. Below is an python example of how to handle prewarming requests

```python
def lambda_handler(event, context):
    # Identify if the incoming event is a prewarm request
    if event.get("action") == "PREWARM":
        logger.info("Received a prewarm request. Skipping business logic.")
        return {
            "statusCode": 200,
            "body": "Successfully warmed up"
        }

```

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.8.0 |
| AWS Provider | >= 5.54 |

## Variables

### Required Variables

| Name | Description | Type |
|------|-------------|------|
| aws_region | AWS region where the Lambda warmer will be deployed | string |

### Optional Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| environment | Current environment, e.g. dev, stage, prod | string | "default" |
| lambda_function_name | Name of the Lambda function used for prewarming | string | "lambda-warmer" |
| lambda_schedule_expression | EventBridge schedule expression for triggering the Lambda warmer | string | "rate(5 minutes)" |
| scheduler_max_retry_attempts | Maximum retry attempts for the EventBridge scheduler target | number | 0 |
| prewarm_tag_key | The tag key to identify functions that need prewarming | string | "Prewarm" |
| prewarm_tag_value | The expected value of the tag for functions that need prewarming | string | "true" |
| invocation_type | The invocation type of the Lambda Warmer function (Event / RequestResponse) | string | "Event" |

## Outputs

| Name | Description |
|------|-------------|
| scheduler_group_arn | ARN of the EventBridge Scheduler Group |
| scheduler_arn | ARN of the EventBridge Scheduler |
| lambda_function_name | Name of the Lambda warmer function |
| lambda_function_arn | ARN of the Lambda warmer function |
| lambda_role_name | Name of the Lambda IAM Role |
| lambda_role_arn | ARN of the Lambda IAM Role |

## Directory Structure

```plaintext
.
├── README.md
├── main.tf                # Main Terraform configuration
├── variables.tf           # Input variables
├── versions.tf            # Terraform version constraints
├── outputs.tf             # Output definitions
└── lambda_warmer/         # Lambda function code
    └── lambda_function.py # Python implementation
```

## IAM Roles and Permissions

The module creates two separate IAM roles:

1. Lambda Role:
   - CloudWatch Logs access
   - Lambda function invocation

2. EventBridge Scheduler Role:
   - Permission to invoke the warmer Lambda function

## Schedule Expression Examples

- Every 5 minutes: `rate(5 minutes)`
- Every hour: `rate(1 hour)`

## Monitoring and Logs

The Lambda warmer function logs its activities to CloudWatch Logs. You can monitor:

- Functions being warmed
- Warming success/failure
- Number of functions processed

## Contact

If you encounter any issues, feel free to reach out at <dev@aws-educate.tw> or [submit an issue](https://github.com/aws-educate-tw/terraform-aws-tag-based-lambda-warmer/issues/new).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

Copyright © 2024 AWS Educate Cloud Ambassador Taiwan
