#!/bin/bash
if [[ -z ${GITHUB_ACTIONS:+x} ]]; then
  set -euo pipefail
else
  set -euxo pipefail
fi
shopt -s nullglob

{
  while getopts 'u:' FLAG
  do
    case "${FLAG}" in
      u) INPUT_FILE_URL="${OPTARG}";;
    esac
  done

  TMP_DIR=$(mktemp -d) || (echo "Error: Failed to create tmpdir." >&2 && exit 1)
  trap 'rm -rf "${TMP_DIR}"' EXIT

  if [[ -z ${INPUT_FILE_URL:+x} ]]; then
    echo "Usage: $(basename $0) -u [FILE_URL]" >&2
    exit 1
  fi

  FILE_URL=$(curl -Ls -o "${TMP_DIR}/update.bin" -w '%{url_effective}' "${INPUT_FILE_URL}")
  unzip -q -d "${TMP_DIR}/update" -o "${TMP_DIR}/update.bin"

  if [[ -f "${TMP_DIR}/update/system.new.dat.br" ]]; then
    brotli -d "${TMP_DIR}/update/system.new.dat.br" -o "${TMP_DIR}/update/system.new.dat"
  fi
  if [[ -f "${TMP_DIR}/update/system.transfer.list" && -f "${TMP_DIR}/update/system.new.dat" ]]; then
    python2 /opt/sdat2img/sdat2img.py "${TMP_DIR}/update/system.transfer.list" "${TMP_DIR}/update/system.new.dat" "${TMP_DIR}/system.img"
    ( python2 /opt/ext4extract/ext4extract.py -D "${TMP_DIR}/system" --skip-symlinks "${TMP_DIR}/system.img" ) \
      || ( /opt/extfstools/ext2rd "${TMP_DIR}/system.img" "./:${TMP_DIR}/system" )
  fi

  if [[ -d "${TMP_DIR}/system/system" ]]; then
    SYSTEM_DIR="${TMP_DIR}/system/system"
  elif [[ -d "${TMP_DIR}/system" ]]; then
    SYSTEM_DIR="${TMP_DIR}/system"
  else
    SYSTEM_DIR="${TMP_DIR}/update/system"
  fi

  if [[ -f "${SYSTEM_DIR}/system_ext/app/AmazonWebView/AmazonWebView.apk" ]]; then
    AMAZON_WEBVIEW_APK_PATH="${SYSTEM_DIR}/system_ext/app/AmazonWebView/AmazonWebView.apk"
  elif [[ -f "${SYSTEM_DIR}/app/AmazonWebView/AmazonWebView.apk" ]]; then
    AMAZON_WEBVIEW_APK_PATH="${SYSTEM_DIR}/app/AmazonWebView/AmazonWebView.apk"
  elif [[ -f "${SYSTEM_DIR}/app/AmazonWebView.apk" ]]; then
    AMAZON_WEBVIEW_APK_PATH="${SYSTEM_DIR}/app/AmazonWebView.apk"
  elif [[ -f "${SYSTEM_DIR}/app/SystemWebView/SystemWebView.apk" ]]; then
    AMAZON_WEBVIEW_APK_PATH="${SYSTEM_DIR}/app/SystemWebView/SystemWebView.apk"
  elif [[ -f "${SYSTEM_DIR}/app/SystemWebView.apk" ]]; then
    AMAZON_WEBVIEW_APK_PATH="${SYSTEM_DIR}/app/SystemWebView.apk"
  fi

  if [[ ! -f "${SYSTEM_DIR}/build.prop" ]]; then
    echo 'Error: build.prop is not found.' >&2
    exit 1
  fi

  UPDATE_BIN_HASH=$(sha256sum -b "${TMP_DIR}/update.bin" | awk '{ print $1 }')
  OS_VERSION=$(
    (
      grep -E 'ro.build.mktg.fireos=' "${SYSTEM_DIR}/build.prop" \
      || grep -E 'ro.build.version.name=' "${SYSTEM_DIR}/build.prop"
    ) \
    | awk -F'=' '{ print $2 }' \
    | grep -o -E '[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?'
  )

  if [[ -z ${AMAZON_WEBVIEW_APK_PATH:+x} ]]; then
    echo 'Error: AmazonWebView.apk is not found.' >&2
    WEBVIEW_VERSION="(n/a)"
  else
    WEBVIEW_VERSION=$(
      androguard axml -o /dev/stdout "${AMAZON_WEBVIEW_APK_PATH}" \
      | python2 -c 'import sys; import xml.etree.ElementTree as ET; print(ET.fromstring(sys.stdin.read()).get("{http://schemas.android.com/apk/res/android}versionName"))'
    )
  fi

  RESULT=$(
    jq -c -n --arg url "${FILE_URL}" --arg sha256 "${UPDATE_BIN_HASH}" --arg os_version "${OS_VERSION}" --arg webview_version "${WEBVIEW_VERSION}" \
    -M '{ "url": $url, "sha256": $sha256, "os_version": $os_version, "webview_version": $webview_version }'
  )
} > /dev/null

if [[ -z ${GITHUB_ACTIONS:+x} ]]; then
  echo "${RESULT}"
else
  echo "::set-output name=result::${RESULT}"
fi
