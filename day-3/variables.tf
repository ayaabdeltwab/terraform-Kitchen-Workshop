# Create variables 
variable "Environment" {
  description = "The environment for the S3 bucket"
  default     = "terraformChamps"
}
variable "Owner" {
  description = "The owner of the S3 bucket"
  default     = "Ayaa"
}
