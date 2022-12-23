# CodePipeline

# 소개
AWS CodePipeline

## Resources
| Name                                                                                                                                                              | Type     |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_codepipeline.codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)                                         | resource |
| [aws_iam_role.codepipeline_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role))                                           | resource |
| [aws_iam_role_policy.codepipeline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                            | resource |
| [aws_iam_group.approval_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group)                                             | data     |
| [aws_iam_policy.approval_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                          | resource |
| [aws_iam_group_policy_attachment.approval_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                                                     | resource |


## Inputs
| 이름                                  | 설명                                                                                                                                                                                                      | 필수구분 | 입력부분                                                                                         |
| ------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------ |
| project                               | 프로젝트 이름                                                                                                                                                                                             | yes      |
| region                                | AWS 리전 정보 (e.g. ap-northeast-2)                                                                                                                                                                       | yes      |
| env                                   | tag 생성을 위한 입력 값 (e.g. dev, stg, ...)                                                                                                                                                              | yes      |
| codestar_connections_arn              | code star connection arn                                                                                                                                                                                  | yes      |
| aws_codebuild_source_credential_token | bitbucket token                                                                                                                                                                                           | yes      |
| codepipeline_bucket_name              | codepipeline artifact bucket                                                                                                                                                                              | yes      |
| Source                                | Source stage 정의 <br/>[docs](https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#actions-valid-providers) Source Action category 부분 참고                        | yes      | ActionName <br/>Category <br/>Owner <br/>Provider <br/>OutputArtifact <br/>Version                    |
| Approval                              | Approval stage 정의. 선택 사용이 가능하다.                                                                                                                                                                | no       | useApprovalStage <br/>approval_group_name                                                         |
| Approval.useApprovalStage             | Approval stage 사용 여부 설정. 디폴트는 `false`이다.                                                                                                                                                      | no       |
| Approval.approval_group_name          | Approval 허가 권한을 부여할 IAM Group. 설정하지 않으면 사용하지 않는다. Approval 허가 권한을 제한할 때 사용.                                                                                              | no       |
| Build                                 | Build stage 정의. codebuild module을 사용해서 생성 후 연결시킨다.                                                                                                                                         | yes      | OutputArtifacts                                                                                  |
| Build.OutputArtifacts                 | Build OutputArtifacts 정의.                                                                                                                                                                               | yes      |
| Deploy                                | Deploy stage 정의. 선택 사용이 가능하다. <br/>[docs](https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#actions-valid-providers) Deploy Action category 부분 참고 | no       | useDeployStage <br/>ActionName <br/>Category <br/>Owner <br/>Provider <br/>InputArtifacts <br/>Version |
| Deploy.useDeployStage                 | Deploy stage 사용 여부 설정. 디폴트는 `false`이다.                                                                                                                                                        | no       |



예제

```
CodePipeline = {
  Source = {
      ActionName = "Source"
      Category = "Source"
      # AWS, Custom, ThirdParty
      Owner = "AWS"
      # Provider = "Bitbucket", "S3", "ECR", "CodeCommit", "GitHub", "GithubEnterpriseServer"
      Provider = "Bitbucket"
      OutputArtifact = ["source_output"]
      Version = "1"

      # Source Provider Configuration
      # AWS CodeCommit
      CodeCommit = {
          Provider = "CodeCommit"
          RepositoryName = ""
          BranchName = ""
          ChangeDetectionOptions = ""
          OutputArtifactFormat = ""
      }

      # Amazon ECR
      ECR = {
          Provider = "ECR"
          RepositoryName = ""
          #defaults to latest
          ImageTag = ""
      }

      # Amazon S3
      S3 = {
          Provider = "S3"
          BucketName = ""
          S3ObjectKey = ""
      }

      # Bitbucket
      Bitbucket = {
          Provider = "CodeStarSourceConnection"
          ConnectionArn = ""
          # <account>/<repository-name>
          FullRepositoryId = "megazone/mzc-space"
          BranchName = "main"
      }
      #GitHub
      GitHub = {
          Provider = "CodeStarSourceConnection"
          ConnectionArn = ""
          FullRepositoryId = "nauco/devops_ojt"
          BranchName = "main"
      }

      #GithubEnterpriseServer
      GithubEnterpriseServer = {
          Provider = "CodeStarSourceConnection"
          ConnectionArn = ""
          FullRepositoryId = ""
          BranchName = ""
      }             
  }

  Approval = {
      useApprovalStage = false
      approval_group_name = ""                
  }

  Build = {
      OutputArtifacts = ["build_output"]
  }

  Deploy = {
      useDeployStage = true
      
      ActionName = "Deploy"
      Category = "Deploy"
      # AWS, Custom, ThirdParty
      Owner = "AWS"
      # Provider = S3, CloudFormation, CodeDeploy, CodeDeployToECS
      Provider = "S3"
      InputArtifacts = ["build_output"]    
      Version = "1"
                  
      # Deploy Provider Configuration
      CloudFormation = {
          ActionMode     = "REPLACE_ON_FAILURE"
          Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
          OutputFileName = "CreateStackOutput.json"
          StackName      = "MyStack"
          TemplatePath   = "build_output::sam-templated.yaml"
      }

      S3 = {
          BucketName = "dev-cpp-codepipeline-artifact"
          Extract    = "false"
          ObjectKey  = "deploy-file"
      }

      CodeDeploy = {
          ApplicationName     = "my-application"
          DeploymentGroupName = "my-deployment-group"
      }

      CodeDeployToECS = {
          AppSpecTemplateArtifact        = "SourceArtifact"
          ApplicationName                = "ecs-cd-application"
          DeploymentGroupName            = "ecs-deployment-group"
          Image1ArtifactName             = "MyImage"
          Image1ContainerName            = "IMAGE1_NAME"
          TaskDefinitionTemplatePath     = "taskdef.json"
          AppSpecTemplatePath            = "appspec.yaml"
          TaskDefinitionTemplateArtifact = "SourceArtifact"
      }
  }
}
```
