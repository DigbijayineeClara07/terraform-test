terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"  # Specify a version if needed
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Specify a version as needed
    }
  }
 backend "s3" {
  region = "eu-central-1"
 }
}

module "bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 6.0"

  name       = "clara-gcp-bucket-test2u5hf7210"
  project_id = "stackguardian-nonprod"
  location   = "us"

  lifecycle_rules = [{
    action = {
      type = "Delete"
    }
    condition = {
      age            = 365
      with_state     = "ANY"
      matches_prefix = "stackguardian-nonprod"
    }
  }]

  custom_placement_config = {
    data_locations : ["US-EAST4", "US-WEST1"]
  }

  iam_members = [{
    role   = "roles/storage.objectViewer"
    member = "group:test-gcp-ops@test.blueprints.joonix.net"
  }]

  autoclass  = true
  encryption = { default_kms_key_name = null }
}
