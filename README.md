![logo](https://raw.githubusercontent.com/unifiedstreaming/origin/master/unifiedstreaming-logo-black.png)

Remix Origin
------------
The Remix Origin takes a SMIL playlist and creates a Remix MP4 for the Unified Origin to use for playout.

Usage
-----
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

More detailed documentation is available at: <https://docs.unified-streaming.com/documentation/remix/npvr/npvr.html#components-archiver-origin-remix-smil>

Example
-------
The Remix-Origin is normally used in combination with a Unified-Origin (as a REMOTE location). The Remix-Origin has a SMIL_URL defined which could be either a proxy or http based storage location where a smil file can be accessed. 

A HTTP get request for an mp4 files can be made by substituting the .smil for .mp4. in the url. The Remix-Origin will translate this request and provide a dref-mp4 in response. The response can then either be parse back to Unified-Origin or written to disk for caching/performance benefits. 

```bash
# Unified Origin (Running on the same network range)
docker run \
  -e UspLicenseKey=<license_key> \
  -e REMOTE_PATH=remix \
  -e REMOTE_STORAGE_URL=http://192.168.0.1:1081/ \
  -e LOG_LEVEL=debug \
  -p 1080:0 \
  unifiedstreaming/origin

# Running Remix-Origin
docker run \
  -e UspLicenseKey \
  -e SMIL_URL=http://usp-s3-storage.s3.eu-central-1.amazonaws.com/ \
  -e LOG_LEVEL=debug \
  -p 1081:80 \
  unifiedstreaming/remix-origin
```

Now a request can be made against the Unfied-Origin which fetch a smil (hosted on S3) via the Remix Origin and provide a response, all dynamically. 
```bash
curl http://localhost/remix/tears-of-steel/tears-of-steel-28s.mp4/.m3u8

#EXTM3U
#EXT-X-VERSION:4
## Created with Unified Streaming Platform  (version=1.11.1-24062)

# AUDIO groups
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-aacl-64",LANGUAGE="en",NAME="English",DEFAULT=YES,AUTOSELECT=YES,CHANNELS="2",URI="tears-of-steel-28s-audio_eng=64000.m3u8"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-aacl-128",LANGUAGE="en",NAME="English",DEFAULT=YES,AUTOSELECT=YES,CHANNELS="2",URI="tears-of-steel-28s-audio_eng=128000.m3u8"

# variants
#EXT-X-STREAM-INF:BANDWIDTH=490000,CODECS="mp4a.40.2,avc1.42C00D",RESOLUTION=224x100,FRAME-RATE=24,AUDIO="audio-aacl-64",CLOSED-CAPTIONS=NONE
tears-of-steel-28s-video_eng=401000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=926000,CODECS="mp4a.40.2,avc1.42C016",RESOLUTION=448x200,FRAME-RATE=24,AUDIO="audio-aacl-128",CLOSED-CAPTIONS=NONE
tears-of-steel-28s-video_eng=751000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1191000,CODECS="mp4a.40.2,avc1.4D401F",RESOLUTION=784x350,FRAME-RATE=24,AUDIO="audio-aacl-128",CLOSED-CAPTIONS=NONE
tears-of-steel-28s-video_eng=1001000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1721000,CODECS="mp4a.40.2,avc1.640028",RESOLUTION=1680x750,FRAME-RATE=24,VIDEO-RANGE=SDR,AUDIO="audio-aacl-128",CLOSED-CAPTIONS=NONE
tears-of-steel-28s-video_eng=1501000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2462000,CODECS="mp4a.40.2,avc1.640028",RESOLUTION=1680x750,FRAME-RATE=24,VIDEO-RANGE=SDR,AUDIO="audio-aacl-128",CLOSED-CAPTIONS=NONE
tears-of-steel-28s-video_eng=2200000.m3u8

# variants
#EXT-X-STREAM-INF:BANDWIDTH=1021000,CODECS="mp4a.40.2,hvc1.1.6.L150.90",RESOLUTION=1680x750,FRAME-RATE=24,VIDEO-RANGE=SDR,AUDIO="audio-aacl-64",CLOSED-CAPTIONS=NONE
tears-of-steel-28s-video_eng_1=902000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1360000,CODECS="mp4a.40.2,hvc1.1.6.L150.90",RESOLUTION=2576x1150,FRAME-RATE=24,VIDEO-RANGE=SDR,AUDIO="audio-aacl-128",CLOSED-CAPTIONS=NONE
tears-of-steel-28s-video_eng_1=1161000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1808000,CODECS="mp4a.40.2,hvc1.1.6.L150.90",RESOLUTION=3360x1500,FRAME-RATE=24,VIDEO-RANGE=SDR,AUDIO="audio-aacl-128",CLOSED-CAPTIONS=NONE
tears-of-steel-28s-video_eng_1=1583000.m3u8

# keyframes
#EXT-X-I-FRAME-STREAM-INF:BANDWIDTH=54000,CODECS="avc1.42C00D",RESOLUTION=224x100,URI="keyframes/tears-of-steel-28s-video_eng=401000.m3u8"
#EXT-X-I-FRAME-STREAM-INF:BANDWIDTH=100000,CODECS="avc1.42C016",RESOLUTION=448x200,URI="keyframes/tears-of-steel-28s-video_eng=751000.m3u8"
#EXT-X-I-FRAME-STREAM-INF:BANDWIDTH=133000,CODECS="avc1.4D401F",RESOLUTION=784x350,URI="keyframes/tears-of-steel-28s-video_eng=1001000.m3u8"
#EXT-X-I-FRAME-STREAM-INF:BANDWIDTH=120000,CODECS="hvc1.1.6.L150.90",RESOLUTION=1680x750,VIDEO-RANGE=SDR,URI="keyframes/tears-of-steel-28s-video_eng_1=902000.m3u8"
#EXT-X-I-FRAME-STREAM-INF:BANDWIDTH=154000,CODECS="hvc1.1.6.L150.90",RESOLUTION=2576x1150,VIDEO-RANGE=SDR,URI="keyframes/tears-of-steel-28s-video_eng_1=1161000.m3u8"
#EXT-X-I-FRAME-STREAM-INF:BANDWIDTH=210000,CODECS="hvc1.1.6.L150.90",RESOLUTION=3360x1500,VIDEO-RANGE=SDR,URI="keyframes/tears-of-steel-28s-video_eng_1=1583000.m3u8"
```
