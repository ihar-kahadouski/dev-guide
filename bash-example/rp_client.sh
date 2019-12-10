#!/bin/bash

function start_launch() {
  local host=$1
  local project=$2
  local api_token=$3

 echo $(curl --header "Content-Type: application/json" \
             --header "Authorization: Bearer $api_token" \
             --request POST \
             --data @./json/start-launch.json \
             $host/api/v1/$project/launch | \
             jq '.id' --raw-output)
}

function start_root_item(){
  local host=$1
  local project=$2
  local api_token=$3
  local launch_uuid=$4

  tmp=$(mktemp)
  jq ".launchUuid = \"$launch_uuid\"" ./json/start-suite.json > "$tmp" && mv "$tmp" ./json/start-suite.json

  echo $(curl --header "Content-Type: application/json" \
              --header "Authorization: Bearer $api_token" \
              --request POST \
              --data @./json/start-suite.json \
              $host/api/v1/$project/item | \
              jq '.id' --raw-output)
}

function start_child_item() {
  local host=$1
  local project=$2
  local api_token=$3
  local launch_uuid=$4
  local paren_item_uuid=$5

  echo $(curl --header "Content-Type: application/json" \
              --header "Authorization: Bearer $api_token" \
              --request POST \
              --data @  \
              $host/api/v1/$project/item/$paren_item_uuid | \
              jq '.id' --raw-output)
}

function finish_item() {
  local host=$1
  local project=$2
  local api_token=$3
  local launch_uuid=$4
  local item_uuid=$5

  echo $(curl --header "Content-Type: application/json" \
     --header "Authorization: Bearer $api_token" \
     --request PUT \
     --data @ \
     $host/api/v1/$project/item/$item_uuid)
}
