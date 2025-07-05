# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket  = ""
    key     = ""
    region  = "us-east-1"
    profile = "terraform-user"
  }
}