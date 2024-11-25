# Provider configurations
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Provider setup
provider "aws" {
  region = var.aws_region
}

provider "digitalocean" {
  # Token will be loaded from DIGITALOCEAN_TOKEN environment variable
}

provider "vault" {
  address = var.vault_addr
  # Token will be loaded from VAULT_TOKEN environment variable
}

# Variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "vault_addr" {
  description = "HashiCorp Vault address"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., prod, staging)"
  type        = string
}

# Vault data sources for secrets
data "vault_generic_secret" "db_credentials" {
  path = "secret/database/${var.environment}"
}

data "vault_generic_secret" "api_keys" {
  path = "secret/api/${var.environment}"
}

# AWS Resources
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = "${var.environment}-public-subnet"
    Environment = var.environment
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name        = "${var.environment}-web-server"
    Environment = var.environment
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "DB_PASSWORD=${data.vault_generic_secret.db_credentials.data["password"]}" >> /etc/environment
              echo "API_KEY=${data.vault_generic_secret.api_keys.data["key"]}" >> /etc/environment
              EOF
}

# DigitalOcean Resources
resource "digitalocean_vpc" "main" {
  name     = "${var.environment}-vpc"
  region   = "nyc1"
  ip_range = "192.168.0.0/16"
}

resource "digitalocean_droplet" "web" {
  name     = "${var.environment}-web-server"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-20-04-x64"
  region   = "nyc1"
  vpc_uuid = digitalocean_vpc.main.id

  user_data = <<-EOF
              #!/bin/bash
              echo "DB_PASSWORD=${data.vault_generic_secret.db_credentials.data["password"]}" >> /etc/environment
              echo "API_KEY=${data.vault_generic_secret.api_keys.data["key"]}" >> /etc/environment
              EOF
}

# Outputs
output "aws_instance_ip" {
  value = aws_instance.web.public_ip
}

output "digitalocean_droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}