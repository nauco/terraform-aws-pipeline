variable "project" {
  description = "project code which used to compose the resource name"
  default     = ""
}

variable "env" {
  description = "environment: dev, stg, qa, prod "
  default     = ""
}

variable "key" {
  description = "for naming rule"
  default     = ""
}

variable "codepipeline_bucket_name" {
  default = ""
}

variable "codepipeline_bucket_arn" {
  default = ""
}

variable "codepipeline_bucket_id" {
  default = ""
}

variable "codestar_connections_arn" {
  default = ""
}

# TERRAFORM CRASH
# variable "stagelist" {
#   default = []
#   type = list(object({
#     Stage = string
#     StageName = string
#     Actions = optional(list(object({
#       ActionName = optional(string, "action")
#       Owner = optional(string, "AWS")
#       RunOrder = optional(number, 1)
#       Provider = optional(string, "")
#       InputArtifacts = optional(list(string), [])
#       OutputArtifacts = optional(list(string), [])
#       Version = optional(string, "1")
#       Configuration = optional(map(any), {})
#     })), [])
#   }))
# }

variable "stagelist" {
  default = []
  type = list(object({
    Stage         = optional(string, "Build")
    StageName     = optional(string, "Build")
    Actions       = list(object({
      ActionName      = optional(string, "action")
      Owner           = optional(string, "AWS")
      RunOrder        = optional(number, 1)
      Provider        = optional(string, "")
      InputArtifacts  = optional(list(string), [])
      OutputArtifacts = optional(list(string), [])
      Version         = optional(string, "1")
      Configuration   = optional(map(any), {})
    }))
  }))
}

variable "approval" {
  default = []
}

variable "project_name" {
  default = []
}

variable "common_tags" {
  default = []
}