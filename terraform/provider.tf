// If you're using VS Code, this seems like a handy extension: https://github.com/4ops/vscode-language-terraform

terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  // Same as in serverless.yml
  region = var.region
  // Same as in serverless.yml
  profile = "geoffpersonal"
  // per the recommendtion, pin it to a version
  version = "~> 3.12.0"
}

provider "random" {
  version = "~> 3.0.0"
}
