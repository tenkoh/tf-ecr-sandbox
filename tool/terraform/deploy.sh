#! /bin/bash

export TF_VAR_aws_account=$(aws sts get-caller-identity --query Account --output text)
terraform apply
