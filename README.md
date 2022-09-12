### Authenticate
```commandline
aws configure
```

### Provicion EKS cluster

```
terraform init
```
```
terraform get
```
```
terraform apply
```

### Configure kubectl
To retrieve the access credentials for the cluster and configure ```kubectl```
```commandline
aws eks --region region_code update-kubeconfig \
    --name name_of_the_cluster

```

[//]: # (region = "us-east-1")

### Upload the dagster image to ECR

Use the following steps to authenticate and push an image to your repository. For additional registry authentication methods, including the Amazon ECR credential helper, see Registry authentication .
Retrieve an authentication token and authenticate your Docker client to your registry.
Use the AWS CLI:

```
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 247010350437.dkr.ecr.us-east-1.amazonaws.com
```
Note: if you receive an error using the AWS CLI, make sure that you have the latest version of the AWS CLI and Docker installed.
Build your Docker image using the following command. For information on building a Docker file from scratch, see the instructions here . You can skip this step if your image has already been built:

```commandline
docker build -t weather-data-on-dagster .
```

After the build is completed, tag your image so you can push the image to this repository:

```commandline
docker tag weather-data-on-dagster:latest 247010350437.dkr.ecr.us-east-1.amazonaws.com/weather-data-on-dagster:latest

```

Run the following command to push this image to your newly created AWS repository:
```commandline

docker push 247010350437.dkr.ecr.us-east-1.amazonaws.com/weather-data-on-dagster:latest
```



