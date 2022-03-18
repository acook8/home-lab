terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "DevOps-Playground-acook8"

    workspaces {
      name = "home-lab"
    }
  }
}
