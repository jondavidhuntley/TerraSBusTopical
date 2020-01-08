variable "prefix" {}
variable "key_vault_name" {}
variable "hweb_resource_group_name" {}
variable "app_service_plan_name" {}
variable "app_service_plan_tier" {}
variable "app_service_plan_size" {}

variable "default_location" {
  default = "UK South"
   description = "The default location to house everything"
}

variable "https_only" {
  type        = bool
  default     = false
  description = "Redirect all traffic made to the web app using HTTP to HTTPS."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the web app."
}