provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "docking_bay" {
  bucket_prefix = "docking-bay-storage-"

  tags = {
    Name                 = "Docking Bay"
    Environment          = "Dev"
    git_commit           = "f018da62a8915c58bcf38ef9f0e18829ecd820af"
    git_file             = "terraform/simple_instance/s3.tf"
    git_last_modified_at = "2022-08-15 23:09:36"
    git_last_modified_by = "111311778+akinpanw@users.noreply.github.com"
    git_modifiers        = "111311778+akinpanw"
    git_org              = "akinpanw"
    git_repo             = "terragoat"
    yor_trace            = "d7102c8d-6fc8-4818-b9ee-32748544d1a3"
  }
}
