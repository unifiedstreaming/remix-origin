#!/bin/sh
set -e

# set env vars to defaults if not already set
if [ -z "$LOG_LEVEL" ]
then
  export LOG_LEVEL=warn
fi

if [ -z "$LOG_FORMAT" ]
then
  export LOG_FORMAT="%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\" %D"
fi

if [ -z "$SMIL_URL" ]
then
  export SMIL_URL="http://smil-proxy/"
fi

# Default S3 endpoint URL for Proxy config
if [ -z "$S3_URL" ]
then
  export S3_URL="https://s3.amazonaws.com"
fi

# validate required variables are set
if [ "$USP_LICENSE_KEY" ] && [ -z "$UspLicenseKey" ]
then
  export UspLicenseKey=$USP_LICENSE_KEY
elif [ -z "$UspLicenseKey" ]
then
  echo >&2 "Error: UspLicenseKey environment variable is required but not set."
  exit 1
fi

# change Listen 80 to Listen 0.0.0.0:80 to avoid some strange issues when IPv6 is available
/bin/sed -i "s@Listen 80@Listen 0.0.0.0:80@g" /etc/apache2/httpd.conf

# USP license
echo "$UspLicenseKey" > /etc/usp-license.key

rm -f /run/apache2/httpd.pid

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- httpd "$@"
fi

exec "$@"