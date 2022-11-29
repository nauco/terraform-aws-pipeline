# CodePipeline
AWS CodePipeline을 Terraform으로 관리하기 위한 코드

## 지원
Source - (Approval) - Build - (Deploy) 로 구성되어 있다.  
승인(Approval)과 배포(Deploy) 단계는 선택할 수 있다.   
소스(Source)는 CodeCommit, Bitbucket, GitHub, GitHub Enterpise Server, S3, ECR을 지원한다.   
배포(Deploy)는 S3, CloudFormation, CodeDeploy, ECS를 지원한다.  

## 구성

![Pipeline](images/Terraform_Codepipeline2.png)

## 설치
```
# Init
terraform Init 

# Apply
terraform apply -var-file=env/dev.tfvars
```



## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | 프로젝트 이름 | `string` | `""` | yes |
| region | AWS 리전 정보 (e.g. ap-northeast-2) | `string` | `""` | yes |
| env | tag 생성을 위한 입력 값 (e.g. dev, stg, ...) | `string` | `""` | yes |
| codestar_connections_arn | code star connection arn | `string` | `""` | yes |
| aws_codebuild_source_credential_token | bitbucket token | `string` | `""` | yes |
| codepipeline_bucket_name | codepipeline artifact bucket | `string` | `""` | yes |
| provider | source provider `Bitbucket`, `S3`, `ECR`, `CodeCommit`, `GitHub`, `GithubEnterpriseServer` 입력 후 source block 내부 해당 configuration을 세팅합니다. | `string` | `""` | yes |
| codebuild.codebuild_source_credential.auth_type | The type of authentication used to connect to a GitHub, GitHub Enterprise, or Bitbucket repository. An OAUTH connection is not supported by the API. `PERSONAL_ACCESS_TOKEN`, `BASIC_AUTH` | `string` | `""` | yes |
| codebuild.codebuild_source_credential.server_type | The source provider used for this project. | `string` | `""` | yes |
| codebuild.codebuild_source_credential.token | For GitHub or GitHub Enterprise, this is the personal access token. For Bitbucket, this is the app password. | `string` | `""` | yes |
| codebuild.codebuild_source_credential.user_name | The Bitbucket username when the authType is BASIC_AUTH | `string` | `""` | no |

---
[링크](https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference.html)
