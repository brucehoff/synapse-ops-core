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

# True or False
BEANSTALK_MODE=${6}

# Folder containing source code
SRC_PATH=${7}

cd $SRC_PATH

pip install -r requirements.txt

BEANSTALK_NUMBERS=$REPO_BEANSTALK_NUMBER,$WORKERS_BEANSTALK_NUMBER,$PORTAL_BEANSTALK_NUMBER
python configuration.py $STACK $INSTANCE $BEANSTALK_NUMBERS


npm install -g aws-cdk

echo "Configuring CDK environment..."
export CDK_DEFAULT_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
export CDK_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}
echo "Account: $CDK_DEFAULT_ACCOUNT, Region: $CDK_DEFAULT_REGION"

cdk deploy --context stack=$STACK --context stack_versions=$INSTANCE --context beanstalk_numbers=$BEANSTALK_NUMBERS --context beanstalk_mode=$BEANSTALK_MODE
