terraform {
  backend "s3" {
    bucket = "dev-eu-central-1-tf-state-bucket"
    key    = "dev/terraform.tfstate"
    region = "eu-central-1"
    # dynamodb_table = "terraform-lock"
  }
}
