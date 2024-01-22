#!/usr/bin/env sh


set -o pipefail
set -e

BASE_IMAGE=${1:-}
IMAGE=${2:-}
BASE_REG_USERNAME=${3:-}
BASE_REG_PASSWORD=${4:-}
IMAGE_REG_USERNAME=${5:-}
IMAGE_REG_PASSWORD=${6:-}

if [[ -z "${BASE_IMAGE}" || -z "${IMAGE}" ]]; then
  echo "::error title=argument::Missing Argument base-image or image"
  exit 1
fi

get_layers(){
  image=$1
  username=$2
  password=$3
  cmd="manifest-tool"
  if [ -n "${username}" ] && [ -n "${password}" ]; then
    cmd="${cmd} --username=${username} --password=${password}"
  fi

  cmd="${cmd} inspect ${image} --raw"
  op=$($cmd)
  retval=$?
  if [ $retval -ne 0 ]; then
      echo "::error title=get_layers::Failed to get layers for ${image}"
      return $retval
  fi
  layers=$(echo ${op} | jq -r ".[]|.Layers[]?")
  echo "$layers"
}

get_base_layers(){
  get_layers "${BASE_IMAGE}" "${BASE_REG_USERNAME}" "${BASE_REG_PASSWORD}"
}

get_image_base_layer(){
  # returns only the first layer(base layer)
  get_layers "${IMAGE}" "${IMAGE_REG_USERNAME}" "${IMAGE_REG_PASSWORD}" | head -n 1
}

base_layers=$(get_base_layers)

image_base_layer=$(get_image_base_layer)

found=$(echo "${base_layers}" | grep -c "${image_base_layer}")
retval=$?
if [ "$found" -gt 0 ]; then
  echo "needs-update=false" >> $GITHUB_OUTPUT
else
  echo "needs-update=true" >> $GITHUB_OUTPUT
fi
