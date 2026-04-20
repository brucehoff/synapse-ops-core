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

# Submit the async job and capture the jobId
RESPONSE=$(curl --fail-with-body \
        -X POST \
        -H "Authorization:Bearer $ACCESS_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$ASYNC_JOB_PAYLOAD" \
        "$SYNAPSE_HOST/repo/v1/admin/asynchronous/job")

JOB_ID=$(echo "$RESPONSE" | jq -r '.jobId')
if [ -z "$JOB_ID" ] || [ "$JOB_ID" == "null" ]; then
    echo "Failed to retrieve jobId from response: $RESPONSE" >&2
    exit 1
fi

echo "Submitted job with jobId: $JOB_ID"

# Poll for job status until COMPLETE or FAILED
STATUS=""
while true; do
    STATUS_RESPONSE=$(curl --fail-with-body \
        -H "Authorization:Bearer $ACCESS_TOKEN" \
        "$SYNAPSE_HOST/repo/v1/admin/asynchronous/job/$JOB_ID")
    STATE=$(echo "$STATUS_RESPONSE" | jq -r '.jobState')
    echo "Job state: $STATE"
    echo "$STATUS_RESPONSE"
    if [ "$STATE" == "COMPLETE" ]; then
        echo "Job completed successfully."
        break
    elif [ "$STATE" == "FAILED" ]; then
        echo "Job failed."
        exit 2
    fi
    sleep 5
done
