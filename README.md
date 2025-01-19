# rke2

# RKE2 on GCP with Terraform

This project creates an RKE2 (Kubernetes) cluster on GCP using Terraform.  


## Prerequisites

- Terraform installed
- jq installed (for JSON parsing)
- A valid GCP Service Account key file (JSON)
- SSH key setup to connect to the created instances

## Usage

1. Edit `dev.env` and provide:
   - `PROJECT_ID`
   - `GOOGLE_APPLICATION_CREDENTIALS`
   - `rename dev.env to .env`
  
2. Run:
    make init
    make apply
    make ssh-manager-0
