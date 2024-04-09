# AWS CloudFormation templates

CloudFormation templates to deploy Graylog API Security in AWS.

## Contents

- [Running Graylog API Security on EKS](#running-graylog-api-security-on-eks): deploy Graylog API Security on AWS Elastic Kubernetes Service.
  - [I don't have an EKS cluster yet](#do-you-want-to-try-graylog-api-security-but-you-dont-have-a-kubernetes-cluster-yet)
  - [I already have an EKS cluster](#do-you-already-have-an-eks-cluster)
- [KDS](#kinesis-data-streams-capture-api-call-data-from-your-aws-api-gateway): deploy a Kinesis Data Stream instance to stream CloudWatch logs from your API Gateway instance to Graylog API Security.
- [Running Graylog API Security on ECS](#ecs): (deprecated) templates to deploy Graylog API Security on AWS Elastic Container Service.

## Running Graylog API Security on EKS

The recommended way to deploy Graylog API Security.

### Do you want to try Graylog API Security but you don't have a Kubernetes cluster yet?

No problem! Our templates will allow you to get started with Graylog API Security without having to run `kubectl`, `helm` or any commands at all. In fact, you won't even have to leave your browser before you have a brand new EKS cluster running your own self-hosted Graylog API Security instance.

Click the **Launch Stack** button below to deploy Graylog API Security together with all the necessary resources as a [CloudFormation stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacks.html):

[![Launch AWS Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?stackName=eks-graylog-api-security&templateURL=https%3A%2F%2Fapisec-cf-templates.s3.us-east-1.amazonaws.com%2Feks%2Feks-all.json)

**Parameters**:

- Choose both a name for you cluster (*EKSClusterName*), and 3 availability zones (*SubnetAZs*) to create the subnets for your cluster.

  <details>
    <summary>Click to expand</summary>
    <img width="600" alt="cd-parameters" src="https://github.com/resurfaceio/templates/assets/7117255/e16fb3b9-e177-4802-8c13-d7d0c6d0a3b5">
  </details>

    - If installing a single-node cluster it is recommended to decrease the EKS node count (*EKSNodeCount*) to 1.
    - If the CloudFormation stack deployment fails, please choose 3 different availability zones and try again.
  

- Make sure to allow CloudFormation to create both IAM resources and nested stacks (`CAPABILITY_AUTO_EXPAND`)

  <details>
    <summary>Click to expand</summary>
    <img width="1379" alt="image" src="https://github.com/resurfaceio/templates/assets/7117255/46ea7bcb-76b4-40db-a21c-01098ec2c666">
  </details>



> [!NOTE]
> This uses a custom template to create and deploy:
> 1. An [Elastic Kubernetes Service instance](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html), with an EC2-based [managed node group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html), as well as the `VPC CNI`, `CoreDNS`, and `EBS CSI` [EKS addons](https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html#workloads-add-ons-available-eks) required to enable internal networking and persistent volume provisioning, respectively.
> 2. A number of network resources, including a new [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) with 3 [subnets](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html), and an [internet gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html) to provide the EKS Cluster with internet access.
> 3. A [nested CloudFormation stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-nested-stacks.html) that, in turn, creates and deploys:
>   - A self-terminating [EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) that connects to the newly-created EKS cluster and uses [helm](https://resurface.io/docs#using-helm) to install both the [Graylog API Security chart](https://artifacthub.io/packages/helm/resurfaceio/resurface), and the [Cert-manager](https://artifacthub.io/packages/helm/cert-manager/cert-manager/) dependency. This way the provisioned Graylog API Security cluster is both [TLS](https://resurface.io/docs#enabling-tls) and [Iceberg](https://resurface.io/docs#enabling-iceberg-storage) ready.
>   - An [S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html#CoreConcepts) to host a static website with post-installation notes.
>4. The corresponding [IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) and policies, EC2 instance profiles, and [EKS access entries](https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html) required to create, deploy and connect to EKS clusters, node groups, and EC2 instances.

Once the automatic deployment finishes, go to the **Outputs** section and click on the **SuccessURL** link.

<details>
  <summary>Click to expand</summary>
  <img width="1482" alt="outputs" src="https://github.com/resurfaceio/templates/assets/7117255/30890bf9-c09c-4924-a10a-6d87bc1cf02c">
</details>

You should be greeted with a page containing post-installation notes. There you will find the URL to access the web UI for your very own Graylog API Security instance 🚀

<details>
  <summary>Click to expand</summary>
  <img width="1482" alt="outputs" src="https://github.com/resurfaceio/templates/assets/7117255/85aa99d1-2e3a-4858-8a3a-a743364a4e3c">
</details>


🏁 That's it!

### Do you already have an EKS cluster?

Even better! Our template will help you get started with Graylog API Security without having to run `kubectl`, `helm` or any commands at all. In fact, you won't even have to leave your browser before you are running your own self-hosted Graylog API Security instance.

Click the Launch Stack button below to deploy all necessary resources as a [CloudFormation stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacks.html):

[![Launch AWS Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?stackName=eks-graylog-api-security&templateURL=https%3A%2F%2Fapisec-cf-templates.s3.us-east-1.amazonaws.com%2Feks%2Fnested%2Fec2-chart-installer.json)

> [!NOTE]
> This uses a custom template to create and deploy:
> 1. A self-terminating [EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) that connects to the newly-created EKS cluster and uses [helm](https://resurface.io/docs#using-helm) to install both the [Graylog API Security chart](https://artifacthub.io/packages/helm/resurfaceio/resurface), and the [Cert-manager](https://artifacthub.io/packages/helm/cert-manager/cert-manager/) dependency. This way the provisioned Graylog API Security cluster is both [TLS](https://resurface.io/docs#enabling-tls) and [Iceberg](https://resurface.io/docs#enabling-iceberg-storage) ready.
> 2. An [S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html#CoreConcepts) to host a static website with post-installation notes.
> 3. The corresponding [IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) and policies, EC2 instance profiles, and [EKS access entries](https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html) required to create and deploy new EC2 instances, and connect to your EKS cluster.

Once the automatic deployment finishes, go to the **Outputs** section and click on the **SuccessURL** link.

<details>
  <summary>Click to expand</summary>
  <img width="1482" alt="outputs" src="">
</details>

You should be greeted with a page containing post-installation notes. There you will find the URL to access the web UI for your very own Graylog API Security instance 🚀

<details>
  <summary>Click to expand</summary>
    <img width="1482" alt="outputs" src="https://github.com/resurfaceio/templates/assets/7117255/85aa99d1-2e3a-4858-8a3a-a743364a4e3c">
</details>

## Kinesis Data Streams: Capture API call data from your AWS API Gateway

For APIs fronted by AWS API Gateway, API calls can be captured to your Graylog API Security database through Kinesis data streams.

For more information, please visit our [aws-kds](https://github.com/resurfaceio/aws-kds) repo.

  
## Running Graylog API Security on ECS

Currently, this option is not supported. If you are interested, please let us know by opening an issue for us to allocate resources to bring this option up to date.

## More info
Please, visit [our docs](https://resurface.io/docs) to learn more about Graylog API Security.


---
<small>&copy; 2016-2024 <a href="https://resurface.io">Graylog, Inc.</a></small>
