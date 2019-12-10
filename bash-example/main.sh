#!/bin/bash

source ./rp_auth_client.sh
source ./rp_client.sh

HOST=$1
USERNAME=$2
PASSWORD=$3

UI_TOKEN=$(get_ui_token $HOST $USERNAME $PASSWORD)

API_TOKEN=$(get_api_token $HOST $UI_TOKEN)
