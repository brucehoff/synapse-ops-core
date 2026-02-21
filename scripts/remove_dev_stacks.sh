#!/bin/bash
#
# Delete old, unused CloudFormation stacks used for dev' builds
#

set +x

# Folder containing source code
SRC_PATH=${1}

cd $SRC_PATH

mvn clean install

java -Xms256m -Xmx2g -cp ./target/stack-builder-0.2.0-SNAPSHOT-jar-with-dependencies.jar org.sagebionetworks.template.cron.TimeToLiveCronJob
