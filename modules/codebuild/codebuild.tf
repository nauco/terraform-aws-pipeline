resource "aws_codebuild_project" "codebuild" {
  name          = format("%s-%s-build", var.project, var.env)
  description   = var.codebuild_info.description
  build_timeout = var.codebuild_info.build_timeout
  service_role  = aws_iam_role.codebuild_role.arn

  dynamic "artifacts" {
    for_each = length(var.codebuild_info.artifacts) > 0 ? [var.codebuild_info.artifacts] : []
    
    content {
      type = artifacts.value.type
      path = artifacts.value.path
    }
  }

  dynamic "cache" {
    for_each = length(var.codebuild_info.cache) > 0 ? [var.codebuild_info.cache] : []
    
    content {
      type = cache.value.type
      modes = cache.value.modes
    }
  }  

  environment {
    compute_type                = var.codebuild_info.environment.compute_type
    image                       = var.codebuild_info.environment.image
    type                        = var.codebuild_info.environment.type
    image_pull_credentials_type = var.codebuild_info.environment.image_pull_credentials_type
    privileged_mode             = var.codebuild_info.environment.privileged_mode
    
    dynamic "environment_variable" {
      for_each = var.codebuild_info.environment_variables
      
      content {
        name = environment_variable.key
        value = environment_variable.value.val
        type = environment_variable.value.type
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.codepipeline_bucket_id}/build-log"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.codebuild_info.useBuildspecPath ? var.codebuild_info.buildspec_path : file("${path.module}/${var.codebuild_info.buildspec_yaml}")
  }

  dynamic "secondary_sources" {
    for_each = length(var.codebuild_info.secondary_sources) > 0 ? [var.codebuild_info.secondary_sources] : []
    content {
      type = secondary_sources.value.type
      source_identifier = secondary_sources.value.source_identifier
      location = secondary_sources.value.location
      git_clone_depth = secondary_sources.value.git_clone_depth
    }
  }

  dynamic "secondary_source_version" {
    for_each = length(var.codebuild_info.secondary_source_version) > 0 ? [var.codebuild_info.secondary_source_version] : []
    content {
      source_identifier = secondary_source_version.value.source_identifier
      source_version = secondary_source_version.value.source_version
    }
  }
  
  tags = var.codebuild_info.common_tags
}

output "aws_codebuild_project_id" {
  value = aws_codebuild_project.codebuild.id
}