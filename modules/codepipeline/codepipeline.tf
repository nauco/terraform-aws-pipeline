resource "aws_codepipeline" "codepipeline" {
  name     = format("%s-%s-%s", var.project, var.env, var.key)
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.codepipeline_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    dynamic "action" {
      for_each = length(var.codepipeline_info.Source) > 0 ? [var.codepipeline_info.Source] : []

      content {
        name             = action.value.ActionName
        category         = action.value.Category
        owner            = action.value.Owner
        provider         = var.codepipeline_info.Source[action.value.Provider].Provider
        output_artifacts = action.value.OutputArtifact
        version          = action.value.Version

        configuration = {
          for k, v in var.codepipeline_info.Source[action.value.Provider]: k => v
          if k != "Provider"
        }
        
      }
    }
  }  

  dynamic "stage" {
    for_each = var.codepipeline_info.Approval.useApprovalStage ? [1] : []

    content {
      name = "Approval"

      action {
        name             = "Approval"
        category         = "Approval"
        owner            = "AWS"
        version          = "1"
        provider         = "Manual"
      }
    }
  }  

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = var.codepipeline_info.OutputArtifacts
      version          = "1"

      configuration = {
        ProjectName = var.codepipeline_info.ProjectName
      }
    }
  }

  dynamic "stage" {
    for_each = var.codepipeline_info.Deploy.useDeployStage ? [var.codepipeline_info.Deploy] : []
         
    content {
      name = "Deploy"

      action {
        name            = var.codepipeline_info.Deploy.ActionName
        category        = var.codepipeline_info.Deploy.Category
        owner           = var.codepipeline_info.Deploy.Owner
        provider        = var.codepipeline_info.Deploy.Provider
        input_artifacts = var.codepipeline_info.Deploy.InputArtifacts
        version         = var.codepipeline_info.Deploy.Version

        configuration = tomap(var.codepipeline_info.Deploy[var.codepipeline_info.Deploy.Provider])
    
      }  
    }    
  }

  tags = var.codepipeline_info.common_tags

}