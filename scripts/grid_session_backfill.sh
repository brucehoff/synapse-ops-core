#!/bin/bash
#
# Triggers a backfill of grid sessions.
#

set +x

SYNAPSE_HOST="https://repo-prod-582-0.prod.sagebase.org"

# Retrieve a personal access token for a Synapse admin user from AWS secrets manager
ACCESS_TOKEN=`aws secretsmanager get-secret-value --secret-id /synapse/admin-pat --query SecretString --output text`

curl --fail-with-body -X POST -H "Authorization:Bearer $ACCESS_TOKEN" -H content-type:application/json $SYNAPSE_HOST/repo/v1/admin/grid/session/backfill
