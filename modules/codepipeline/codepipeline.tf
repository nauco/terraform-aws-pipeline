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
        for_each = length(var.stagelist[stage.key]) > 0 ? [var.stagelist[stage.key]] : []

        content {

          category = stage.value
          name = var.stagelist[stage.key].ActionName
          owner = "AWS"
          provider = var.stagelist[stage.key].Provider
          version = var.stagelist[stage.key].Version
          input_artifacts = stage.value != "Approval" ? var.stagelist[stage.key].InputArtifacts : []
          output_artifacts = stage.value != "Approval" ? var.stagelist[stage.key].OutputArtifacts : []
          
          configuration = stage.value == "Build" ? { ProjectName = var.project_name} : (stage.value != "Approval" ? tomap(var.stagelist[stage.key].Configuration):{})
        }
      }
    }
  }

  tags = var.common_tags

}