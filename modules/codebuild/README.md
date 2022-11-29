# CodeBuild

# 소개
AWS CodeBuild

## Resources
| Name | Type |
|------|------|
| [aws_codebuild_project.codebuild](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) | resource |
| [aws_codebuild_source_credential.credential](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential) | resource |
| [aws_iam_role.codebuild_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy.role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | 프로젝트 이름 | `string` | `""` | yes |
| region | AWS 리전 정보 (e.g. ap-northeast-2) | `string` | `""` | yes |
| env | tag 생성을 위한 입력 값 (e.g. dev, stg, ...) | `string` | `""` | yes |
| codepipeline_bucket_name | codepipeline artifact bucket name | `string` | `""` | yes |
| provider | source provider `Bitbucket`, `S3`, `ECR`, `CodeCommit`, `GitHub`, `GithubEnterpriseServer` 입력 후 source block 내부 해당 configuration을 세팅합니다. | `string` | `""` | yes |
| codebuild_source_credential.auth_type | The type of authentication used to connect to a GitHub, GitHub Enterprise, or Bitbucket repository. An OAUTH connection is not supported by the API. `PERSONAL_ACCESS_TOKEN`, `BASIC_AUTH` | `string` | `""` | yes |
| codebuild_source_credential.server_type | The source provider used for this project. | `string` | `""` | yes |
| codebuild_source_credential.token | For `GitHub` or `GitHub Enterprise`, this is the personal access token. For `Bitbucket`, this is the app password. | `string` | `""` | yes |
| codebuild_source_credential.user_name | The Bitbucket username when the authType is `BASIC_AUTH` | `string` | `""` | no |
| artifacts.type | Build output artifact's type. Valid values: `CODEPIPELINE`, `NO_ARTIFACTS`, `S3` | `string` | `""` | yes |
| artifacts.path | If type is set to `S3`, this is the path to the output artifact. | `string` | `""` | no |
| cache.type | Type of storage that will be used for the AWS CodeBuild project cache. Valid values: `NO_CACHE`, `LOCAL`, `S3` | `string` | `"NO_CACHE"` | no |
| cache.modes | `LOCAL_SOURCE_CACHE`, `LOCAL_DOCKER_LAYER_CACHE`, `LOCAL_CUSTOM_CACHE` | `list(string)` | `[]` | yes when cache type is `LOCAL` |
| cache.location |  Location where the AWS CodeBuild project stores cached resources. For type `S3`, the value must be a valid S3 bucket name/prefix. | `string` | `""` | yes when cache type is `S3` |
| environment.compute_type | Information about the compute resources the build project will use. Valid values: `BUILD_GENERAL1_SMALL`, `BUILD_GENERAL1_MEDIUM`, `BUILD_GENERAL1_LARGE`, `BUILD_GENERAL1_2XLARGE`. `BUILD_GENERAL1_SMALL` is only valid if type is set to `LINUX_CONTAINER`. When type is set to `LINUX_GPU_CONTAINER`, compute_type must be `BUILD_GENERAL1_LARGE`. | `string` | `""` | yes |
| environment.image | Docker image to use for this build project. Valid values include [Docker images provided by CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html) (e.g aws/codebuild/standard:2.0), [Docker Hub images](https://hub.docker.com/) (e.g., hashicorp/terraform:latest), and full Docker repository URIs such as those for ECR (e.g., 137112412989.dkr.ecr.us-west-2.amazonaws.com/amazonlinux:latest) | `string` | `""` | yes |
| environment.type | Type of build environment to use for related builds. Valid values: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_CONTAINER (deprecated), WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER. For additional information, see the [CodeBuild User Guide](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html) . | `string` | `""` | yes |
| environment.image_pull_credentials_type | Type of credentials AWS CodeBuild uses to pull images in your build. Valid values: `CODEBUILD`, `SERVICE_ROLE`. When you use a cross-account or private registry image, you must use `SERVICE_ROLE` credentials. When you use an AWS CodeBuild curated image, you must use CodeBuild credentials | `string` | `"CODEBUILD"` | no |
| environment.privileged_mode |  Whether to enable running the Docker daemon inside a Docker container | `string` | `"false"` | no |
| environment_variables | name - (Required) Environment variable's name or key. type - (Optional) Type of environment variable. Valid values: `PARAMETER_STORE`, `PLAINTEXT`, `SECRETS_MANAGER`. value - (Required) Environment variable's value.  | `string` | `""` | no |
| secondary_sources.type | Type of repository that contains the source code to be built. Valid values: `CODECOMMIT`, `CODEPIPELINE`, `GITHUB`, `GITHUB_ENTERPRISE`, `BITBUCKET` or `S3`  | `string` | `""` | yes |
| secondary_sources.source_identifier |  An identifier for this project source. The identifier can only contain alphanumeric characters and underscores, and must be less than 128 characters in length. | `string` | `""` | yes |
| secondary_sources.location | Location of the source code from git or s3. | `string` | `""` | no |
| secondary_sources.git_clone_depth | Truncate git history to this many commits. Use 0 for a Full checkout which you need to run commands like git branch --show-current. See [AWS CodePipeline User Guide: Tutorial: Use full clone with a GitHub pipeline source](https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-github-gitclone.html) for details  | `string` | `""` | no |
| secondary_source_version.source_identifier | An identifier for a source in the build project. | `string` | `""` | yes |
| secondary_source_version.source_version |  The source version for the corresponding source identifier. See [AWS docs](https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectSourceVersion.html#CodeBuild-Type-ProjectSourceVersion-sourceVersion) for more details. | `string` | `""` | yes |
| useBuildspecPath | True if buildspec is located in source repo   | `bool` | `""` | no |
| buildspec_path |  When useBuildspecPath is true, buildspec path in source repo | `string` | `""` | no |
| buildspec_yaml |  When useBuildspecPath is false, buildspec path in terraform code | `string` | `""` | no |