#!/bin/bash

# this is intended for calling manually, with input args
# ./tdarr_manual_scan -t <tdarr url> -f <file> -r <path mapping> -l <tdarr db id>

while getopts 't:f:r:l:' opt; do
  case "$opt" in
    t)
      TDARR_URL="${OPTARG}"
      echo "Processing option 't' with $TDARR_URL argument"
      ;;
    
    f)
      FILE_PATH="$OPTARG"
      echo "Processing option 'f' with '$FILE_PATH' argument"
      ;;

    r)
      TDARR_PATH_TRANSLATE="$OPTARG"
      echo "Processing option 'r' with '$TDARR_PATH_TRANSLATE' argument"
      FILE_PATH=$(echo "$FILE_PATH" | sed "s|$TDARR_PATH_TRANSLATE|")
      ;;

    l)
      TDARR_DB_ID="$OPTARG"
      echo "Processing option 'l' with '$TDARR_DB_ID' argument"
      ;;

    :)
      echo -e "option requires an argument.\nUsage: $(basename $0) [-t arg] [-f arg] [-r arg] [-l arg]"
      exit 1
      ;;

    ?)
      echo -e "Invalid command option.\nUsage: $(basename $0) [-t arg] [-f arg] [-r arg] [-l arg]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

PAYLOAD="{\"data\": {\"scanConfig\": {\"dbID\": \"${TDARR_DB_ID}\", \"arrayOrPath\": [\"$FILE_PATH\"], \"mode\": \"scanFolderWatcher\" }}}"

# debug logs - payload is most important
echo "EVENT_TYPE: $EVENT_TYPE"
echo "TDARR_URL: $TDARR_URL"
echo "PAYLOAD: $PAYLOAD"

curl --silent --request POST \
    --url ${TDARR_URL}/api/v2/scan-files \
    --header 'content-type: application/json' \
    --data "$PAYLOAD" \
    --location \
    --insecure
