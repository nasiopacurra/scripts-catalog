#!/bin/sh

#
# Simple shell script to backup all GitHub repos
# Usage: github-backup.sh <username>
# @author Petr Trofimov <petrofimov@yandex.ru>
#
# from: https://github.com/ptrofimov/github-backup-sh
#

set -ex

USER="$1"
API_URL="https://api.github.com/users/${USER}/repos?type=owner"
DATE=$(date +"%Y%m%d")
TEMP_DIR="github_${USER}_${DATE}"
BACKUP_FILE="${TEMP_DIR}.tgz"

mkdir "${TEMP_DIR}" && cd "${TEMP_DIR}"
curl -s "${API_URL}" | grep -Eo '"git_url": "[^"]+"' | awk '{print $2}' | xargs -n 1 git clone
cd -
tar zcf "${BACKUP_FILE}" "${TEMP_DIR}"
rm -rf "${TEMP_DIR}"
