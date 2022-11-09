variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "prefix" {
  description = "prefix"
  default     = "Test-"
}

variable "codestar_connections_arn" {
  description = "codestar connections arn for connect bitbucket to aws"
  default     = ""
}

variable "aws_codebuild_source_credential_bitbucket_token" {
  default = {}
}

variable "pipeline" {
  default = {}
}