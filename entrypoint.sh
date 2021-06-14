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

# validate required variables are set
if [ -z "$UspLicenseKey" ] && [ -z "$USP_LICENSE_KEY" ]
  then
    echo >&2 "Error: UspLicenseKey environment variable is required but not set."
    exit 1
elif [ -z "$UspLicenseKey" ]
  then
    export UspLicenseKey="$USP_LICENSE_KEY"
fi

# set up remote storage proxy config
if [ $S3_ACCESS_KEY ]
then
  S3_ACCESS_KEY="S3AccessKey ${S3_ACCESS_KEY}"
fi
if [ $S3_SECRET_KEY ]
then
  S3_SECRET_KEY="S3SecretKey ${S3_SECRET_KEY}"
fi
if [ $S3_REGION ]
then
  S3_REGION="S3Region ${S3_REGION}"
fi

# update configuration based on env vars
# log levels and remote storage
/bin/sed "s@{{LOG_LEVEL}}@${LOG_LEVEL}@g; s@{{LOG_FORMAT}}@'${LOG_FORMAT}'@g; s@{{SMIL_URL}}@${SMIL_URL}@g; s@{{S3_ACCESS_KEY}}@${S3_ACCESS_KEY}@g; s@{{S3_SECRET_KEY}}@${S3_SECRET_KEY}@g; s@{{S3_REGION}}@${S3_REGION}@g" /etc/apache2/conf.d/remix-origin.conf.in > /etc/apache2/conf.d/remix-origin.conf


# USP license
echo $UspLicenseKey > /etc/usp-license.key

rm -f /run/apache2/httpd.pid

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
  set -- httpd "$@"
fi

exec "$@"
