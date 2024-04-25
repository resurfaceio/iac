# AWS CloudFormation templates

CloudFormation templates to deploy Graylog API Security in AWS.

## Contents

- [Running Graylog API Security on EKS](#running-graylog-api-security-on-eks)
  - [I don't have an EKS cluster yet](#do-you-want-to-try-graylog-api-security-but-you-dont-have-a-kubernetes-cluster-yet)
  - [I already have an EKS cluster](#do-you-already-have-an-eks-cluster)
  - [Other options](#other-options)
- [Running Graylog API Security on ECS](#running-graylog-api-security-on-ecs) (deprecated)
- [Kinesis Data Streams: Capture API call data from your AWS API Gateway](#kinesis-data-streams-capture-api-call-data-from-your-aws-api-gateway)

## Running Graylog API Security on EKS

The recommended way to deploy Graylog API Security.


### Do you want to try Graylog API Security but you don't have a Kubernetes cluster yet?

No problem! Our templates will help you get started with Graylog API Security in minutes. In fact, you won't even have to leave your browser before you have a brand new EKS cluster running your own self-hosted Graylog API Security instance.

Click the **Launch Stack** button below to deploy Graylog API Security together with all the necessary resources as a [CloudFormation stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacks.html):

[![Launch AWS Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?stackName=eks-graylog-api-security&templateURL=https%3A%2F%2Fapisec-cf-templates.s3.us-east-1.amazonaws.com%2Feks%2Feks-all.json)

> [!NOTE]
> **What is being deployed here?**
> 1. An [Elastic Kubernetes Service instance](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html), with an EC2-based [managed node group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html), as well as the required [EKS addons](https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html#workloads-add-ons-available-eks) to enable internal networking and persistent volume provisioning: `VPC CNI`, `CoreDNS`, and `EBS CSI`.
> 2. A number of network resources, including a new [VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) with 3 [subnets](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html), and an [internet gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html) to provide the EKS Cluster with internet access.
> 3. A nested CloudFormation stack that, in turn, creates and deploys:
>     - A self-terminating [EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) that connects to the newly-created EKS cluster and uses [helm](https://resurface.io/docs#using-helm) to install both the [Graylog API Security chart](https://artifacthub.io/packages/helm/resurfaceio/resurface), and the [Cert-manager](https://artifacthub.io/packages/helm/cert-manager/cert-manager/) dependency chart.
>     - An [S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html#CoreConcepts) to host a static website with post-installation notes.
> 4. The corresponding [IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) and policies required to create, deploy and connect to EKS clusters, node groups, and EC2 instances.

  <details>
    <summary>Click to see dependency diagrams</summary>
    <table>
      <tr>
        <th>Main stack</th>
        <th>Nested stack: HelmStack</th>
      </tr>
      <tr>
        <td>
          <img width="600" alt="cf-designer" src="https://github.com/resurfaceio/templates/assets/7117255/fa3325ed-5443-4ea6-81b6-9ef9b7b64b51">
        </td>
        <td>
          <img width="600" alt="cf-designer-nested" src="https://github.com/resurfaceio/templates/assets/7117255/aac1b6b2-2bfa-4707-b02a-77b689fb71da">
        </td>
      </tr>
    </table>
  </details>


**Parameters**: Choose both a name for you cluster (*EKSClusterName*), and 3 availability zones (*SubnetAZs*) to create the subnets for your cluster.

- If installing a single-node cluster it is recommended to decrease the EKS node count (*EKSNodeCount*) to 1.

- Make sure to allow CloudFormation to create both IAM resources and nested stacks (`CAPABILITY_AUTO_EXPAND`)

- If the CloudFormation stack deployment fails, please choose 3 different availability zones and try again.

**Outputs**: Once the automatic deployment finishes, go to the *Outputs* section and click on the ***SuccessURL*** link.

<details>
  <summary>Click to expand</summary>
  <img width="1482" alt="outputs" src="https://github.com/resurfaceio/templates/assets/7117255/71f82f25-9059-4c62-ab60-94aa1ca710ab">
</details>

You should be greeted with a page containing post-installation notes. There you will find the URL to access the web UI for your very own Graylog API Security instance 🚀

<details>
  <summary>Click to expand</summary>
  <img width="740" alt="congrats" src="https://github.com/resurfaceio/templates/assets/7117255/52d469ca-caa1-4bf3-a64a-c748736d1fc0">
</details>


🏁 That's it!

---

### Do you already have an EKS cluster?

Even better! Our template will help you get started with Graylog API Security without having to run `kubectl`, `helm` or any commands at all. In fact, you won't even have to leave your browser before you are running your own self-hosted Graylog API Security instance.

Click the Launch Stack button below to deploy all necessary resources as a [CloudFormation stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacks.html):

[![Launch AWS Stack](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)](https://console.aws.amazon.com/cloudformation/home#/stacks/create/review?stackName=eks-graylog-api-security&templateURL=https%3A%2F%2Fapisec-cf-templates.s3.us-east-1.amazonaws.com%2Feks%2Feks-nodes-helm.json)

> [!NOTE]
> **What is being deployed here?**
> 1. A nested CloudFormation stack to deploy EC2-based [managed EKS node group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html), as well as the `EBS CSI` required [EKS addon](https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html#workloads-add-ons-available-eks), to enable persistent volume provisioning.
> 2. A second nested CloudFormation stack that, in turn, creates and deploys:
>     - A self-terminating [EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) that connects to your existing EKS cluster and uses [helm](https://resurface.io/docs#using-helm) to install both the [Graylog API Security chart](https://artifacthub.io/packages/helm/resurfaceio/resurface), and the [Cert-manager](https://artifacthub.io/packages/helm/cert-manager/cert-manager/) dependency chart.
>     - An [S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html#CoreConcepts) to host a static website with post-installation notes.
> 3. The corresponding [IAM roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) and policies required to create and deploy new EC2 instances, and connect to your EKS cluster.

  <details>
    <summary>Click to see dependency diagrams</summary>
    <table>
      <tr>
        <th>Main stack</th>
        <th>Nested stack: NodeGroupStack</th>
        <th>Nested stack: HelmStack</th>
      </tr>
      <tr>
        <td>
          <img width="600" alt="cf-designer" src="https://github.com/resurfaceio/templates/assets/7117255/d04503ed-f1bb-44ff-8cb0-e02213d1675f">
        </td>
        <td>
          <img width="600" alt="cf-designer-nested-nodes" src="https://github.com/resurfaceio/templates/assets/7117255/4fbdac3f-a253-4e0a-a354-7720267cf311">
        </td>
        <td>
          <img width="600" alt="cf-designer-nested-helm" src="https://github.com/resurfaceio/templates/assets/7117255/aac1b6b2-2bfa-4707-b02a-77b689fb71da">
        </td>
      </tr>
    </table>
  </details>


Once the automatic deployment finishes, go to the **Outputs** section and click on the **SuccessURL** link.

<details>
  <summary>Click to expand</summary>
  <img width="1482" alt="outputs" src="https://github.com/resurfaceio/templates/assets/7117255/5534b5c6-587d-48dd-a808-7e0bd8f29f3a">
</details>

You should be greeted with a page containing post-installation notes. There you will find the URL to access the web UI for your very own Graylog API Security instance 🚀

<details>
  <summary>Click to expand</summary>
    <img width="740" alt="congrats" src="https://github.com/resurfaceio/templates/assets/7117255/52d469ca-caa1-4bf3-a64a-c748736d1fc0">
</details>

## Running Graylog API Security on ECS

Currently, this option is not supported. If you are interested, please let us know by opening a new issue!

## Kinesis Data Streams: Capture API call data from your AWS API Gateway

Deploy a Kinesis Data Stream instance to stream CloudWatch logs from your API Gateway instance to Graylog API Security.

For more information, please visit our [aws-kds](https://github.com/resurfaceio/aws-kds) repo.

## More info
Please, visit [our docs](https://resurface.io/docs) to learn more about Graylog API Security.


---
<small>&copy; 2016-2024 <a href="https://resurface.io">Graylog, Inc.</a></small>
