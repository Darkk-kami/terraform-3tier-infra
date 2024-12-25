variable "environnment" {
  type    = string
  default = "dev"
}

variable "create_source" {
  type    = bool
  default = true
}

variable "destination_bucket" {
  description = "This is the destination bucket where s3 objects are replicated"
  default     = null
}