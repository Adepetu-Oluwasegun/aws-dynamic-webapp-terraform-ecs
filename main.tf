# aws provider
provider "aws" {
  region  = var.region
  profile = "terraform-user"
}