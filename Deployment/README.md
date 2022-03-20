Requirements:
1. An AWS account or IAM user access 
2. Packer and Terraform installed on the machine where the code will be executed.

Steps: 
1. First we should generate the images using packer: 
  packer build -debug -var "AWS_SECRET_KEY= /*aws secret key*/ " .
2. We run "terraform init" to start a terraform working directory, Followed by "terraform apply" to provision all resources at once.
3. We can connect to Kibana server on port 5601. (We will be monitoring the apache server introduced and installed as an elaticsearch dependency. we will monitor 
the instance itself).
