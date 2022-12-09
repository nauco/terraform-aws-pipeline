resource "aws_codepipeline" "codepipeline" {
  name     = format("%s-%s-%s", var.project, var.env, var.key)
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.codepipeline_bucket_name
    type     = "S3"
  }

  dynamic "stage" {
    for_each = var.stage

    content {
      name = var.stagelist[stage.key].StageName

      dynamic "action" {
        for_each = length(var.stagelist[stage.key].ActionNames) > 0 ? var.stagelist[stage.key].ActionNames : []

        content {
          category = stage.value
          name = action.value
          owner = "AWS"
          provider = var.stagelist[stage.key].Providers[action.key]
          version = var.stagelist[stage.key].Version
          run_order = var.stagelist[stage.key].RunOrders[action.key]
          input_artifacts = stage.value != "Approval" ? var.stagelist[stage.key].InputArtifacts[action.key] : []
          output_artifacts = stage.value != "Approval" ? var.stagelist[stage.key].OutputArtifacts[action.key] : []
          
          configuration = stage.value == "Build" ? { ProjectName = var.project_name} : var.stagelist[stage.key].Configurations[action.key]
        }
      }
    }
  }
  tags = var.common_tags
}