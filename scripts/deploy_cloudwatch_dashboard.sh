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

echo list all files

ls -al

# We run under the default AWS role
python configuration.py $STACK $INSTANCE $REPO_BEANSTALK_NUMBER,$WORKERS_BEANSTALK_NUMBER,$PORTAL_BEANSTALK_NUMBER default


npm install -g aws-cdk

cdk deploy --profile default --context stack=$STACK --context stack_versions=$INSTANCE --context profile_name=default
