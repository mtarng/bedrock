variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type = "string"
}

variable "resource_group_location" {
  type = "string"
  default = "westus2"
}

# variable "resource_group_name" {
#   type = "string"
# }