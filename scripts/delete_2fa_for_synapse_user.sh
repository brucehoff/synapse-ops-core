#!/bin/bash
#
# Delete the 2FA for a Synapse user.
#

set +x

USER_ID=${1}
SYNAPSE_HOST=${2}

[[ -z "$USER_ID" || -z "$SYNAPSE_HOST" ]] && { echo "Usage: $0 <USER_ID> <SYNAPSE_HOST>"; exit 1; }

# Retrieve a personal access token for a Synapse admin user from AWS secrets manager
ACCESS_TOKEN=`aws secretsmanager get-secret-value --secret-id /synapse/admin-pat --query SecretString --output text`

curl --fail-with-body -X DELETE -H "Authorization:Bearer $ACCESS_TOKEN" -H content-type:application/json $SYNAPSE_HOST/repo/v1/admin/user/$USER_ID/2fa
