project = "cloudplex"
env = "prod"
prefix = "MzcProdCpp-"
approval_group_name = ""
codestar_connections_arn = ""
aws_codebuild_source_credential_bitbucket_token = ""

pipeline = {
    MzcSpace = {
        #codepipeline option
        CodePipeline = {
            Name = "space-rest-api",
            ActionName = "ImageSource",
            Provider = "ECR",
            ImageTag = "latest",
            EcrRepositoryName = "cdkqa-space-rest-api",
        },
        #approval option
        Approval = {
            build_approval = true
        }, 
        #codebuild option
        CodeBuild = {
            environment_variables = {
                "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
                "APP_NAME"   = { val = "space-rest-api", type = "PLAINTEXT" },
                "CONFIG_PATH"   = { val = "mzc-space/rest-api", type = "PLAINTEXT" },
                "REGISTRY_HOST"   = { val = "954279447758.dkr.ecr.ap-northeast-2.amazonaws.com/cdkqa-space-rest-api", type = "PLAINTEXT" },
                "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
            }
        }    
    },

    MzcProduct = {
        #codepipeline option
        CodePipeline = {
            Name = "product-rest-api",
            ActionName = "ImageSource",
            Provider = "ECR",
            ImageTag = "latest",
            EcrRepositoryName = "cdkqa-product-rest-api",
        },
        #approval option
        Approval = {
            build_approval = true
        },         
        #codebuild option
        CodeBuild = {
            environment_variables = {
                "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
                "APP_NAME"   = { val = "product-rest-api", type = "PLAINTEXT" },
                "CONFIG_PATH"   = { val = "mzc-product", type = "PLAINTEXT" },
                "REGISTRY_HOST"   = { val = "954279447758.dkr.ecr.ap-northeast-2.amazonaws.com/cdkqa-product-rest-api", type = "PLAINTEXT" },
                "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
            }
        }
    },

    MzcUser = {
        #codepipeline option
        CodePipeline = {
            Name = "user-rest-api",
            ActionName = "ImageSource",
            Provider = "ECR",
            ImageTag = "latest",
            EcrRepositoryName = "cdkqa-user-rest-api",
        },
        #approval option
        Approval = {
            build_approval = true
        },         
        #codebuild option
        CodeBuild = {
            environment_variables = {
                "AWS_DEFAULT_REGION"   = { val = "ap-northeast-2", type = "PLAINTEXT" },
                "APP_NAME"   = { val = "user-rest-api", type = "PLAINTEXT" },
                "CONFIG_PATH"   = { val = "mzc-user", type = "PLAINTEXT" },
                "REGISTRY_HOST"   = { val = "954279447758.dkr.ecr.ap-northeast-2.amazonaws.com/cdkqa-user-rest-api", type = "PLAINTEXT" },
                "BITBUCKET_PASSWORD"    = { val = "devops-bitbucket:password", type = "SECRETS_MANAGER" }
            }
        }
    }
}