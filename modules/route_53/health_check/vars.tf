variable "primary_db" {
  description = "Primary RDS instance information"
  type = object({
    endpoint = string
    domain   = string
  })
}

variable "secondary_db" {
  description = "Secondary RDS instance information"
  type = object({
    endpoint = string
    domain   = string
  })
}