#!/bin/bash

if [[ -n "${sonarr_eventtype}" ]]; then
  FILE_PATH=${sonarr_episodefile_path}
  EVENT_TYPE="${sonarr_eventtype}"
elif [[ -n "${radarr_eventtype}" ]]; then
  FILE_PATH=${radarr_moviefile_path}
  EVENT_TYPE="${radarr_eventtype}"
fi

if [[ -n "${TDARR_PATH_TRANSLATE}" ]]; then
  FILE_PATH=$(echo "$FILE_PATH" | sed "s|${TDARR_PATH_TRANSLATE}|")
fi

PAYLOAD="{\"data\": {\"scanConfig\": {\"dbID\": \"${TDARR_DB_ID}\", \"arrayOrPath\": [\"$FILE_PATH\"], \"mode\": \"scanFolderWatcher\" }}}"

# debug logs - payload is most important
echo "EVENT_TYPE: $EVENT_TYPE"
echo "TDARR_URL: $TDARR_URL"
echo "PAYLOAD: $PAYLOAD"

# don't call tdarr when testing
if [[ -n "$EVENT_TYPE" && "$EVENT_TYPE" != "Test" ]]; then
  curl --silent --request POST \
    --url ${TDARR_URL}/api/v2/scan-files \
    --header 'content-type: application/json' \
    --data "$PAYLOAD" \
    --location \
    --insecure
fi