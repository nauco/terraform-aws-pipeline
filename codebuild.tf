resource "aws_iam_role" "codebuild_role" {
  name = format("%s%s", var.prefix, "codebuild-role")

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

  artifacts {
    type = "CODEPIPELINE"
    path = "codebuild-artifacts"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

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
    buildspec = each.value.CodeBuild.buildspec_repo ? each.value.CodeBuild.buildspec : each.value.CodeBuild.buildspec_yaml
    # buildspec = each.value.CodeBuild.buildspec
#     buildspec = <<BUILDSPEC
# ${file("buildspec.yaml")}
#     BUILDSPEC
  }

  secondary_sources {
    type = "BITBUCKET"
    source_identifier = "root"
    location = "https://leehodong@bitbucket.org/megazone/mzc-kraken"
    git_clone_depth = "1"

  }

  secondary_source_version {
    source_identifier = "root"
    source_version = "main"
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