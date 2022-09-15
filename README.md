# AWS Infrastructure with Terraform
 
### Requirements
To run and use this project one must have:
- An AWS account
- Terraform installed
- AWS CLI

### From the AWS Console

Create:
- Programmatic user 
- S3 Bucket 


### From the projects terminal

#### Authenticate
```commandline
aws configure
```
Add the access key and the secret access key that you downloaded when the user was created.

#### Configure the backend
In the ```versions.tf``` file, set the default value of the ```bucket``` variable to the bucket name you created above.

#### Provision the infrastructure
```
terraform init
```
```
terraform get
```
```
terraform apply
```

Fill the secrets in ```Secret Manager``` with accurate values, then rerun ```terraform apply```.

### Configure kubectl
To retrieve the access credentials for the cluster and configure ```kubectl```

(Replace ```region_code``` with the AWS cluster region and ```name_of_the_cluster``` witht your cluster name)

```commandline
aws eks --region region_code update-kubeconfig \
    --name name_of_the_cluster
```
