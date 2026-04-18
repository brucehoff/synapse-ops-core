#!/bin/bash
#
# Execute an asynchronous admin job against a Synapse host
#

SYNAPSE_HOST=${1}

ASYNC_JOB_PAYLOAD=${2}

set +x
# Retrieve a personal access token for a Synapse admin user from AWS secrets manager
ACCESS_TOKEN=`aws secretsmanager get-secret-value --secret-id /synapse/admin-pat --query SecretString --output text`

echo $SYNAPSE_HOST/repo/v1/admin/asynchronous/job
curl --fail-with-body \
    -X POST \
    -H "Authorization:Bearer $ACCESS_TOKEN" \
    -H "Content-Type: application/json" \
    -d "$ASYNC_JOB_PAYLOAD" \
    "$SYNAPSE_HOST/repo/v1/admin/asynchronous/job"
