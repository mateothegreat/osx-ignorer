#!/bin/sh

RESET='\033[0m'
RED='\033[0;31m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
LIGHT_PURPLE='\033[1;35m'
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'

usage() {

  if [ -n "$BASE_PATH" ]; then

    echo "\n${RED}👉 $1${RESET}\n"

  fi

  echo "Usage: ${LIGHT_CYAN}$0 [-b base-path]${RESET}"
  echo ""
  echo "  -b, --base-path     ${LIGHT_GRAY}Base directory to search under.${RESET}"
  echo "  -e, --exclude-path  ${LIGHT_GRAY}Path to exclude.${RESET}"
  echo "  -f, --exclude-file  ${LIGHT_GRAY}File to get base dirrectory from to then exclude.${RESET}"
  echo "  -d, --exclude-dir   ${LIGHT_GRAY}Directory name local to --exclude-file to then exclude.${RESET}"
  echo ""
  echo "Example: ${LIGHT_BLUE}$0 --base-path ~/projects --exclude-path /some/path/venv${RESET}"

  exit 1

}

#
# Show all of the exclusions from time machine settings.
#
list() {

  mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"

}

#
# Removes ALL exclusions from time machine settings.
#
remove_all() {

  echo "${LIGHT_RED}👉 Removing all exclusions from time machine..${RESET}"

  IFS=$'\n'
  for FF in $(mdfind "com_apple_backup_excludeItem = 'com.apple.backupd'"); do
    echo "${FF}"
    tmutil removeexclusion "${FF}"
  done

}

exclude_one() {

  if [ -z "$EXCLUDE_FILE" ]; then

    _EXCLUDE_PATH=$EXCLUDE_PATH

  else

    _EXCLUDE_PATH="$(dirname "${EXCLUDE_FILE}")/${EXCLUDE_DIR}"

  fi

  if [ -d "$_EXCLUDE_PATH" ] && ! tmutil isexcluded "$_EXCLUDE_PATH" | grep -q '\[Excluded\]'; then

    tmutil addexclusion "${_EXCLUDE_PATH}"

    echo "  👉 ${LIGHT_GREEN}${_EXCLUDE_PATH}${RESET} has been excluded from Time Machine backups"

  else

    echo "  👉 ${LIGHT_GRAY}${_EXCLUDE_PATH}${RESET} has already been excluded from Time Machine backups"

  fi

}

apply_all() {

  for P in $(cat ignore_paths.txt); do

    CONFIG=(${P//:/ })

    if [ "${#CONFIG[@]}" -eq 2 ]; then

      IGNORE_FILE="${CONFIG[0]}"
      IGNORE_PATH="${CONFIG[1]}"

      echo
      echo "Searching for the file \"${LIGHT_BLUE}${IGNORE_FILE}${RESET}\" under \"${LIGHT_GRAY}${IGNORE_PATH}${RESET}\" to ignore it's base directory.."
      echo

      find "${BASE_PATH}" -name "${IGNORE_FILE}" -type f -and \
        \( -not -path "*/${IGNORE_PATH}/*" \) \
        -maxdepth 5 \
        -exec "${0}" \
        "--base-path" \
        "${BASE_PATH}" \
        "--exclude-dir" \
        "${IGNORE_PATH}" \
        "--exclude-file" \
        "{}" \
        "exclude" \;

    else

      IGNORE_PATH="${CONFIG[0]}"

      echo
      echo "Finding directories matching \"${LIGHT_BLUE}${IGNORE_PATH}${RESET}\" under \"${LIGHT_GRAY}${BASE_PATH}${RESET}\".."
      echo

      find "${BASE_PATH}" -name "${IGNORE_PATH}" -type d \
        -maxdepth 5 \
        -exec "${0}" \
        "--base-path" \
        "${BASE_PATH}" \
        "--exclude-path" \
        "{}" \
        "exclude" \;

    fi

  done

}

#
# Parse arguments
#
while [ "$#" -gt 0 ]; do case $1 in

  -b | --base-path)
    BASE_PATH="$2"
    shift
    shift
    ;;
  -e | --exclude-path)
    EXCLUDE_PATH="$2"
    shift
    shift
    ;;
  -f | --exclude-file)
    EXCLUDE_FILE="$2"
    shift
    shift
    ;;
  -d | --exclude-dir)
    EXCLUDE_DIR="$2"
    shift
    shift
    ;;
  *)
    case "$1" in
    list) list ;;
    exclude) exclude_one ;;
    removeall) remove_all ;;
    apply) apply_all ;;
    esac
    break
    ;;
  esac done

if [ -z "$BASE_PATH" ]; then usage "base path is not set"; fi
