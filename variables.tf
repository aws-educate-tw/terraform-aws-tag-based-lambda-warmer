# Required variables
variable "aws_region" {
  description = "AWS region where the Lambda warmer will be deployed."
}



# Optional variables
variable "environment" {
  description = "Current environment, e.g. dev, stage, prod. the default value is 'default'."
  default     = "default"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function used for prewarming."
  default     = "lambda-warmer"
}

variable "lambda_schedule_expression" {
  description = "EventBridge schedule expression for triggering the Lambda warmer. For example: rate(5 minutes)."
  default     = "rate(5 minutes)"
}

variable "timeout" {
  description = "Timeout for the Lambda warmer function."
  type        = number
  default     = 60
}

variable "memory_size" {
  description = "Memory size for the Lambda warmer function."
  type        = number
  default     = 128
}

variable "scheduler_max_retry_attempts" {
  description = "Maximum retry attempts for the EventBridge scheduler target."
  type        = number
  default     = 0
}

variable "prewarm_tag_key" {
  description = "The tag key to identify functions that need prewarming"
  type        = string
  default     = "Prewarm"
}

variable "prewarm_tag_value" {
  description = "The expected value of the tag for functions that need prewarming"
  type        = string
  default     = "true"
}

variable "invocation_type" {
  description = "The invocation type of the Lambda Warmer function. Valid values: Event / RequestResponse. The default value is 'Event'."
  type        = string
  default     = "Event"
}
