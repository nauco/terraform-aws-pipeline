# CodePipeline
AWS CodePipeline을 Terraform으로 관리하기 위한 코드

## 지원
Source - (Approval) - Build - (Deploy) 로 구성되어 있다.  
승인(Approval)과 배포(Deploy) 단계는 선택할 수 있다.   
소스(Source)는 CodeCommit, Bitbucket, GitHub, GitHub Enterpise Server, S3, ECR을 지원한다.   
배포(Deploy)는 S3, CloudFormation, CodeDeploy, ECS를 지원한다.  

## 구성

![Pipeline](images/Terraform_Codepipeline.png)

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
| <a name="input_project"></a> [project](#input\_project) | 프로젝트 이름 | `string` | `""` | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS 리전 정보 (e.g. ap-northeast-2) | `string` | `""` | yes |
| <a name="input_env"></a> [env](#input\_env) | tag 생성을 위한 입력 값 (e.g. dev, stg, ...) | `string` | `""` | yes |
| <a name="input_codestar_connections_arn"></a> [codestar\_connections\_arn](#input\_codestar\_connections\_arn) | code star connection arn | `string` | `""` | yes |
| <a name="input_aws_codebuild_source_credential_bitbucket_token"></a> [aws\_codebuild\_source\_credential\_bitbucket\_token](#input\_aws\_codebuild\_source\_credential\_bitbucket\_token) | bitbucket token | `string` | `""` | yes |
| <a name="input_codepipeline_bucket_name"></a> [codepipeline\_bucket\_name](#input\_codepipeline\_bucket\_name) | codepipeline artifact bucket | `string` | `""` | yes |
| <a name="input_provider"></a> [provider](#input\_provider) | source provider `Bitbucket`, `S3`, `ECR`, `CodeCommit`, `GitHub`, `GithubEnterpriseServer` | `string` | `""` | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | 공통으로 들어가는 기본 태그 | `map(string)` | `""` | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | 공통으로 들어가는 기본 태그 | `map(string)` | `""` | yes |
[링크](https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference.html)