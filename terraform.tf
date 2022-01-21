terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
    }
  }
}

provider "mongodbatlas" {}
