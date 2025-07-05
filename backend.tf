# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = "kiddo-terraform-remote-state-files"
    key     = "dynamic-webapp.tfstate"
    region  = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    profile = "terraform-user"
  }
}