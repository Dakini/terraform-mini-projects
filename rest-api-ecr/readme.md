## Rest API for a ML ECR image

This folder creates a docker image and uploads to AWS ECR image, and creates a lambda fucntion to use it. It also creates a REST api using aws_gateway, to allow the use to do post requests.

To set up the project.

```bash
cd infrastructure
terraform init
terraform apply

export INVOKE_ARN=$(terraform output -raw invoke_arn)
```

This exports the api url for POST requests.

This can then be tested using

```bash
 cd ../src
 python test_docker.py
```
