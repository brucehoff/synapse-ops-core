#!/bin/bash
#
# Deploy the cloudwach dashboard
#

set +x

# dev or prod
STACK=${1}

# instances, e.g. 582,583,584,585
INSTANCES=${2}

# Folder containing source code
SRC_PATH=${3}

cd $SRC_PATH

pip install -r requirements.txt

npm install -g aws-cdk

export CDK_DEFAULT_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
export CDK_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}

cdk deploy --context stack=$STACK --context stack_versions=$INSTANCES --context beanstalk_mode=False
