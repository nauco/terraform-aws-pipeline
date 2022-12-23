resource "aws_codepipeline" "codepipeline" {
  name     = format("%s-%s-%s", var.project, var.env, var.key)
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.codepipeline_bucket_name
    type     = "S3"
  }

  dynamic "stage" {
    for_each = var.stagelist

    content {
      name = stage.value.StageName

      dynamic "action" {
        for_each = stage.value.Actions

        content {
          category = stage.value.Stage
          name = action.value.ActionName
          owner = action.value.Owner
          provider = action.value.Provider
          version = action.value.Version
          run_order = action.value.RunOrder
          input_artifacts = stage.value.Stage != "Approval" ? action.value.InputArtifacts : []
          output_artifacts = stage.value.Stage != "Approval" ? action.value.OutputArtifacts : []
          
          configuration = stage.value.Stage == "Build" ? { ProjectName = var.project_name} : action.value.Configuration
        }
      }
    }
  }
  tags = var.common_tags
}