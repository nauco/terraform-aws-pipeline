project = "mzc-swat"
env     = "test"
region  = "ap-northeast-2"

codepipeline_bucket_name = "dev-cpp-codepipeline-artifact"

default_tags = {
  dept      = "PSA Group / DevOps SWAT Team"
  i_service = "CloudPlex"
  email     = "lhdong@mz.co.kr"
  purpose   = "Pipeline"
}

pipeline = {
    MzcTest1 = {
        # codepipeline module
        CodePipeline = {

            Stage = ["Source", "Approval", "Build", "Deploy"]
            //Stage = ["Source", "Approval", "Build"]
            

            StageList = [
                {
                    StageName = "ABC"
                    ActionNames = ["S1", "S2", "S3", "S4"]
                    RunOrders = [1, 1, 2, 2]
                    Providers = ["CodeStarSourceConnection", "ECR", "S3", "CodeCommit"]
                    InputArtifacts = [[], [], [], []]
                    OutputArtifacts = [["source_output1"], ["source_output2"], ["source_output3"], ["source_output4"]]
                    Version = "1"

                    Configurations = [{
                        ConnectionArn = "arn:aws:codestar-connections:ap-northeast-2:179248873946:connection/a0807f60-eb1c-4f6a-aea6-c9b85977769b"
                        # <account>/<repository-name>
                        FullRepositoryId = "megazone/mzc-space"
                        BranchName = "main"
                        DetectChanges = "true"                    
                    }, 
                    {
                        RepositoryName = "sample-sqs-consumer"
                        #defaults to latest
                        ImageTag = "latest"
                    },
                    {
                        S3Bucket = "dev-cpp-codepipeline-artifact"
                        #처음에 / 넣지말고, 확장자 포함
                        S3ObjectKey = "dev/test"
                    },
                    {
                        RepositoryName = "mz.cloudplex.guide"
                        BranchName = "main"
                        PollForSourceChanges = "true"
                        OutputArtifactFormat = "CODE_ZIP"
                    }]
                },
                {
                    StageName = "APPROVE"
                    ActionNames = ["YYY"]
                    Providers = ["Manual"]
                    RunOrders = [1]
                    Version = "1"
                    Configurations = [{}]
                },
                {
                    StageName = "BBBB"
                    ActionNames = ["B1", "B2"]
                    Providers = ["CodeBuild", "CodeBuild"]
                    RunOrders = [1, 2]
                    Version = "1"
                    InputArtifacts = [["source_output1", "source_output2"], ["source_output3"]]
                    OutputArtifacts = [["build_output1"], ["build_output2"]]
                },
                {
                    StageName = "BBB"
                    ActionNames = ["D1", "D2", "D3", "D4"]
                    Providers = ["CodeDeploy", "CloudFormation", "S3", "CodeDeployToECS"]
                    Version = "1"
                    RunOrders = [1, 1, 2, 2]
                    InputArtifacts = [["build_output1"], ["build_output1"], ["build_output2"], ["build_output2"]]
                    OutputArtifacts = [[], [], [], []]
                    
                    Configurations = [{
                        ApplicationName     = "my-application"
                        DeploymentGroupName = "my-deployment-group"
                    },
                    {
                        ActionMode     = "REPLACE_ON_FAILURE"
                        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
                        OutputFileName = "CreateStackOutput.json"
                        StackName      = "MyStack"
                        TemplatePath   = "build_output::sam-templated.yaml"
                    },
                    {
                        BucketName = "dev-cpp-codepipeline-artifact"
                        Extract    = "false"
                        ObjectKey  = "deploy-file"
                    },
                    {
                        AppSpecTemplateArtifact        = "SourceArtifact"
                        ApplicationName                = "ecs-cd-application"
                        DeploymentGroupName            = "ecs-deployment-group"
                        Image1ArtifactName             = "MyImage"
                        Image1ContainerName            = "IMAGE1_NAME"
                        TaskDefinitionTemplatePath     = "taskdef.json"
                        AppSpecTemplatePath            = "appspec.yaml"
                        TaskDefinitionTemplateArtifact = "SourceArtifact"
                    }
                    ]
                }
            ]

            Approval = {
                useApprovalStage = false
                approval_group_name = ""                
            }
        },

        # codebuild module
        CodeBuild = {
            Description  = "test desc"
            BuildTimeout = "60"

            codebuild_source_credential = {                
                auth_type   = "BASIC_AUTH"
                server_type = "BITBUCKET"
                token       = "5dRjPC36dpubwrZWMRxB"
                user_name   = "leehodong"
            }

            artifacts = {
                type = "CODEPIPELINE"
                path = "codebuild-artifacts"
            }

            cache = {
                type = "LOCAL"
                modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
            }

            environment = {
                compute_type                = "BUILD_GENERAL1_LARGE"
                image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
                type                        = "LINUX_CONTAINER"
                image_pull_credentials_type = "CODEBUILD"
                privileged_mode             = true
            }            

            environment_variables = {
                "DOMAIN_NAME" = { val = "space", type = "PLAINTEXT" },
                "BITBUCKET_PASSWORD" = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
            }

            secondary_sources = {
                type = "BITBUCKET"
                source_identifier = "root"
                location = "https://leehodong@bitbucket.org/megazone/mzc-kraken"
                git_clone_depth = "1"
            }

            secondary_source_version = {
                source_identifier = "root"
                source_version = "main"
            }
            
            # True if buildspec is located in source repo 
            useBuildspecPath = false
            buildspec_path = "apps/buildspec-dev.yml"
            buildspec_yaml = "templates/buildspec.yaml"
        }
    }
}