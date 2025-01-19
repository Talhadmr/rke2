# src/variables.tf

variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "europe-west3"
}

variable "zone" {
  type        = string
  description = "GCP zone"
  default     = "europe-west3-c"
}

variable "machine_type" {
  type        = string
  description = "Google Compute machine type"
  default     = "e2-medium"
}

variable "manager_count" {
  type        = number
  description = "Number of manager nodes"
  default     = 1
}

variable "worker_count" {
  type        = number
  description = "Number of worker nodes"
  default     = 2
}
