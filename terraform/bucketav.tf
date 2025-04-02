resource "aws_cloudformation_stack" "bucket_av" {
  count        = var.enable_bucket_av ? 1 : 0
  name         = "bucket-av-stack"
  template_url = "https://s3.amazonaws.com/awsmp-fulfillment-cf-templates-prod/39d58953-9c3f-4b5d-a00c-3df2aa282f32/81b1e6a053214bd7bce4e661bc9f1fec.template"

  capabilities = ["CAPABILITY_IAM"]

  parameters = {
    DeleteInfectedFiles  = false
    ReportCleanFiles     = true
    ReportEventBridge    = true
    TagFiles             = true
    TagKey               = "bucketavScanResult"
    AutoScalingMinSize   = 0
    AutoScalingMaxSize   = 1
    KeyName              = aws_key_pair.main.key_name
    LogsRetentionInDays  = 7
    SystemsManagerAccess = true
    CapacityStrategy : "SpotWithoutAlternativeInstanceTypeWithOnDemandFallback"
    InfrastructureAlarmsEmail : ""
    Governance : true
    DashboardLambdaFunctionReservedConcurrentExecutions : 0
    AccountConnectionLambdaFunctionReservedConcurrentExecutions : 0
    RefreshServiceDiscoveryLambdaFunctionFunctionReservedConcurrentExecutions : 0
    RefreshBucketCacheFunctionReservedConcurrentExecutions : 0
    StateMachineNameGeneratorFunctionReservedConcurrentExecutions : 0
    AutoScalingGroupCalculatorFunctionReservedConcurrentExecutions : 0
    SSHIngressCidrIp : module.main_vpc.vpc_cidr_block
    VpcCidrBlock : module.main_vpc.vpc_cidr_block
    FlowLogRetentionInDays : 7
    SecurityHubIntegration : true
    OpsCenterIntegration : false
    InstanceType : "t3a.medium"
    EnableCache : true
    AdditionalDatabaseUrls : ""
    GovernanceLambdaFunctionReservedConcurrentExecutions : 0
  }
}

resource "aws_cloudformation_stack" "bucketav_add_on_move_clean" {
  count        = var.enable_bucket_av ? 1 : 0
  name         = "bucketav-move-clean"
  template_url = "https://bucketav-add-ons.s3.eu-west-1.amazonaws.com/move-clean/v2.15.0/bucketav-add-on-move-clean.yaml"
  capabilities = ["CAPABILITY_IAM"]
  parameters = {
    BucketAVStackName = "bucket-av-stack" # if you followed the docs, the name is bucketav
    TargetBucketName  = aws_s3_bucket.clean_bucket.id
  }
}
