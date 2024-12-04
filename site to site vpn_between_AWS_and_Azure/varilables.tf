variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "azure_client_id" {
  description = "Azure Client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure Client Secret"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "azure_location" {
  description = "Azure Region"
  type        = string
  default     = "East US"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}