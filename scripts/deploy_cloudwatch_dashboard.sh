#!/bin/bash
#
# Deploy the cloudwach dashboard
#

set +x

# dev or prod
STACK=${1}

# instance, e.g. 583
INSTANCE=${2}

# repo, worker, portal beanstalk numbers
# e.g. 582-0,582-0,582-0
BEANSTALK_NUMBERS=${3}

# Folder containing source code
SRC_PATH=${4}

cd $SRC_PATH

# We run under the default AWS role
python configuration.py $STACK $INSTANCXE $BEANSTALK_NUMBERS default

cdk deploy --profile default --context stack=$STACK --context stack_versions=$INSTANCE --context profile_name=default
