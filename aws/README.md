# AWS CloudFormation templates

CloudFormation templates to deploy Graylog API Security in AWS.

## EKS

The recommended way to deploy Graylog API Security.

### Do you want to try Graylog API Security but you don't have a Kubernetes cluster yet?

No problem! Our templates will allow you to get started with Graylog API Security without having to run `kubectl`, `helm` or any commands at all. In fact, you won't even have to leave your browser before you have your own self-hosted Graylog API Security instance.

Click the **Launch Stack** button below to deploy Graylog API Security together with all the necessary resources as a [CloudFormation stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacks.html):

[![Launch AWS Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?stackName=eks-graylog-api-security&templateURL=https%3A%2F%2Fapisec-cf-templates.s3.us-east-1.amazonaws.com%2Feks%2Feks-joined-stack.json)

**Parameters**: Choose both a name for you cluster (*EKSClusterName*), and 3 availability zones (*SubnetAZs*) to create the subnets for your cluster.
  - If installing a single-node cluster it is recommended to decrease the EKS node count (*EKSNodeCount*) to 1.
  - If the CloudFormation stack deployment fails, please choose 3 different availability zones and try again.

> [!NOTE]
> This uses a custom template to create and deploy:
> - An [Elastic Kubernetes Service instance](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html), with an EC2-based [managed node group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html), as well as the `VPC CNI`, `CoreDNS`, and `EBS CSI` [EKS addons](https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html#workloads-add-ons-available-eks) required to enable internal networking and persistent volume provisioning, respectively.
> - A number of network resources, including a new [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) with 3 [subnets](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html), and an [internet gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html) to provide the EKS Cluster with internet access.
> - A [nested CloudFormation stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-nested-stacks.html) that, in turn, creates and deploys:
>   - A self-terminating [EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) that connects to the newly-created EKS cluster and uses [helm](https://resurface.io/docs#using-helm) to install both the [Graylog API Security chart](https://artifacthub.io/packages/helm/resurfaceio/resurface), and the [Cert-manager](https://artifacthub.io/packages/helm/cert-manager/cert-manager/) dependency. This way the provisioned Graylog API Security cluster is both [TLS](https://resurface.io/docs#enabling-tls) and [Iceberg](https://resurface.io/docs#enabling-iceberg-storage) ready.
>   - An [S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html#CoreConcepts) to host a static website with post-installation notes.
> - The corresponding [IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) and policies, EC2 instance profiles, and [EKS access entries](https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html) required to create, deploy and connect to EKS clusters, node groups, and EC2 instances.

Once the automatic deployment finishes, go to the **Outputs** section.

<details>
  <summary> Click to expand</summary>
  
  ![image]()
</details>

Click on the **SuccessURL** link.

<details>
  <summary>Click to expand</summary>
  
  ![image]()
</details>

You should be greeted with a page containing post-installation notes. There you will find the URL to access the web UI for your very own Graylog API Security instance 🚀

<details>
  <summary>Click to expand</summary>
  
  ![image]()
</details>


### Do you already have an EKS cluster?

Click the Launch Stack button below to deploy all necessary resources as a [CloudFormation stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacks.html):

[![Launch AWS Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?stackName=eks-graylog-api-security&templateURL=https%3A%2F%2Fapisec-cf-templates.s3.us-east-1.amazonaws.com%2Feks%2Fnested%2Feks-helm-ec2.json)


### More info
Please, visit [our docs](https://resurface.io/docs) to learn more about Graylog API Security.


---
<small>&copy; 2016-2024 <a href="https://resurface.io">Graylog, Inc.</a></small>