![logo](https://raw.githubusercontent.com/unifiedstreaming/origin/master/unifiedstreaming-logo-black.png)

# Remix Origin

The Remix Origin takes a SMIL playlist and creates a Remix MP4 for the Unified Origin to use for playout.

# Usage
This image is usable out of the box, but must be configured using environment variables.

Available variables are:

|Variable        |Usage   |Mandatory?|
|----------------|--------|----------|
|UspLicenseKey |Your license key. To evaluate the software you can create an account at <https://private.unified-streaming.com/register/>|Yes|
|LOG_LEVEL|Sets the Apache error log level|No|
|LOG_FORMAT|Sets a custom Apache log format|No|
|SMIL_URL|Base URL for SMILs, defaults to <http://smil-proxy/>|No|
|S3_SECRET_KEY|If using S3 remote storage sets the secret key for authentication|No|
|S3_ACCESS_KEY|If using S3 remote storage sets the access key for authentication|No|
|S3_REGION|If using S3 remote storage with v4 authentication set the region|No|
