provider "aws" {
  version = "~> 3"
  region  = local.workspace.aws_region
  profile = local.workspace.aws_profile
}