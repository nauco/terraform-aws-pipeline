resource "aws_iam_role" "codebuild_role" {
  name = format("%scodebuild-role-%s", var.prefix, random_string.random.result)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "role_policy" {
  role = aws_iam_role.codebuild_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "secretsmanager:*",
        "ecr:*",
        "codeartifact:*",
        "sts:*",
        "ssm:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    }
  ]
}
POLICY
}


resource "aws_codebuild_project" "codebuild" {
  for_each = var.pipeline

  name          = each.value.CodePipeline.Name
  description   = format("%s%s",each.value.CodePipeline.Name,"_codebuild_project")
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  dynamic "artifacts" {
    for_each = length(each.value.CodeBuild.artifacts) > 0 ? [each.value.CodeBuild.artifacts] : []
    
    content {
      type = artifacts.value.type
      path = artifacts.value.path
    }
  }

  dynamic "cache" {
    for_each = length(each.value.CodeBuild.cache) > 0 ? [each.value.CodeBuild.cache] : []
    
    content {
      type = cache.value.type
      modes = cache.value.modes
    }
  }  

  environment {
    compute_type                = each.value.CodeBuild.environment.compute_type
    image                       = each.value.CodeBuild.environment.image
    type                        = each.value.CodeBuild.environment.type
    image_pull_credentials_type = each.value.CodeBuild.environment.image_pull_credentials_type
    privileged_mode             = each.value.CodeBuild.environment.privileged_mode
    
    dynamic "environment_variable" {
      for_each = each.value.CodeBuild.environment_variables
      
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
      location = "${aws_s3_bucket.codepipeline_bucket.id}/build-log"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = each.value.CodeBuild.useBuildspecPath ? each.value.CodeBuild.buildspec_path : file("${path.module}/${each.value.CodeBuild.buildspec_yaml}")
  }

  dynamic "secondary_sources" {
    for_each = length(each.value.CodeBuild.secondary_sources) > 0 ? [each.value.CodeBuild.secondary_sources] : []
    content {
      type = secondary_sources.value.type
      source_identifier = secondary_sources.value.source_identifier
      location = secondary_sources.value.location
      git_clone_depth = secondary_sources.value.git_clone_depth
    }
  }

  dynamic "secondary_source_version" {
    for_each = length(each.value.CodeBuild.secondary_source_version) > 0 ? [each.value.CodeBuild.secondary_source_version] : []
    content {
      source_identifier = secondary_source_version.value.source_identifier
      source_version = secondary_source_version.value.source_version
    }
  }
  
  tags = {
    Environment = "Dev"
    Service = each.key
  }
}

resource "aws_codebuild_source_credential" "bitbucket" {
  auth_type   = "BASIC_AUTH"
  server_type = "BITBUCKET"
  token       = var.aws_codebuild_source_credential_bitbucket_token
  user_name   = "leehodong"
}