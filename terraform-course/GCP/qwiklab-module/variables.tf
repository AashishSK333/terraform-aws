variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "terraform-413703"
}

variable "name" {
  description = "Name of the buckets to create."
  type        = string
  default     = "terraform-413703-bucket1"
}