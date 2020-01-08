variable "prefix" {}
variable "hweb_resource_group_name" {}
variable "poc_sbus_ns_sku" {}

variable "default_location" {
  default = "UK South"
   description = "The default location to house everything"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the web app."
}