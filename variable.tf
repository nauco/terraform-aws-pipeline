variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "codestar_connections_arn" {
  description = "codestar connections arn for connect bitbucket to aws"
  default     = ""
}

variable "pipeline" {
  default = {}
}