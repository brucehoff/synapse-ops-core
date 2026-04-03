#!/bin/bash
#
# Deploy the cloudwach dashboard
#

set +x

# dev or prod
STACK=${1}

# instance, e.g. 583
INSTANCE=${2}

# repo beanstalk number
# e.g. 582-0
REPO_BEANSTALK_NUMBER=${3}

# workers beanstalk number
# e.g. 582-0
WORKERS_BEANSTALK_NUMBER=${4}

# portal beanstalk number
# e.g. 582-0
PORTAL_BEANSTALK_NUMBER=${5}

# Folder containing source code
SRC_PATH=${6}

cd $SRC_PATH

pip install -r requirements.txt

python configuration.py $STACK $INSTANCE $REPO_BEANSTALK_NUMBER,$WORKERS_BEANSTALK_NUMBER,$PORTAL_BEANSTALK_NUMBER


npm install -g aws-cdk
cdk acknowledge 34635

echo "Configuring CDK environment..."
export CDK_DEFAULT_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
export CDK_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}
echo "Account: $CDK_DEFAULT_ACCOUNT, Region: $CDK_DEFAULT_REGION"

cdk deploy --context stack=$STACK --context stack_versions=$INSTANCE
