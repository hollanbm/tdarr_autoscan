# tdarr_autoscan

Original idea from [tdarr_inform](https://github.com/deathbybandaid/tdarr_inform)

This script is done entirely in bash, which means it can be used for docker containers, where you might not have python, and do not wish to modify the base image
The primary difference though, is that this script needs additional input, via environment variables, where as tdarr_inform is more configurable, in just about every way.

This script is designed to be used with Sonarr or Radarr "custom scripts", on import/upgrade.

## Installation

The following commands will download the script, and configure the correct permissions

1) `cd /path/to/arr/config/folder`
2) `wget https://raw.githubusercontent.com/hollanbm/tdarr_autoscan/main/tdarr_autoscan.sh`
3) `chmod 0755 tdarr_autoscan.sh`
4) Set `TDARR_URL`, `TDARR_DB_ID`, and/or `TDARR_PATH_TRANSLATE` environment variables on your container
     - [docker documentation](https://docs.docker.com/compose/environment-variables/)

          example docker-compose.yml

          ```yaml
          sonarr:
            container_name: sonarr
            image: ghcr.io/linuxserver/sonarr
            restart: unless-stopped
            ports:
              - 8989:8989
            environment:
              - TDARR_URL=http://tdarr:8265
              - TDARR_DB=wWlsdkvbx
              - TDARR_PATH_TRANSLATE=/tv/|/media/tv/
            volumes:
              - ${HOME}/Sonarr:/config # config files
              - /media/tv/:/tv
          ```

5) Open the Sonarr/Radarr webui
6) `Settings > Connect > New > Custom Script`
7) Name: tdarr_autoscan
8) Notification Triggers
   - On Import
   - On Upgrade
9) Optionally, set any tags
10) Path: `/config/tdarr_autoscan.sh`
11) Save

## Usage

### Required fields

The following environment variables are required to be set in your container

- TDARR_URL
  - For most users, it will probably be in the form of
    - `http://ip:port`
  - If you have docker networking configured, then you may use the container_name instead of the ip address
    - `http://container_name:port`
  - If you have a reverse proxy or SSL configured, then you may use the full tdarr site URL
    - `https://site.domain`

- TDARR_DB_ID
  - This value is a string hash, NOT an integer
  - The easiest way to determine what this value is, is to goto the libraries section in tdarr, and grab it from the URL after you've selected the correct library
  - The url (as of 1/16/23) is in the format `https://tdarr.domain.#/libraries/<Database_ID>/source`

### Optional fields

- TDARR_PATH_TRANSLATE
  - This is intended to be used for path map translation, where your volume, is mounted at a different path than tdarr
  - This will be used as input to [sed](https://linux.die.net/man/1/sed)
  - This must be in the format `search|replace`
    - in the above example, only the first occurence of the word `search`, in the file path, will be replaced with the word `replace`
  - see line #12 in the script

### tdarr_scan.sh

  This is provided for those who would like to manually call the script with input args
