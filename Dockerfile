ARG ALPINEVERSION=3.13
ARG VERSION=1.11.1

FROM unifiedstreaming/origin:$VERSION
LABEL maintainer "Unified Streaming <support@unified-streaming.com>"

# ARGs declared before FROM are in a different scope, so need to be stated again
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG ALPINEVERSION
ARG VERSION
ARG BETA_REPO=https://beta.apk.unified-streaming.com/alpine/
ARG STABLE_REPO=https://stable.apk.unified-streaming.com/alpine/

# Get USP public key
RUN wget -q -O /etc/apk/keys/alpine@unified-streaming.com.rsa.pub \
    https://stable.apk.unified-streaming.com/alpine@unified-streaming.com.rsa.pub

# configure
RUN sed -i "s/#LoadModule rewrite_module/LoadModule rewrite_module/" /etc/apache2/httpd.conf

RUN wget -q -O /etc/apk/keys/alpine@unified-streaming.com.rsa.pub \
  http://stable.apk.unified-streaming.com/alpine@unified-streaming.com.rsa.pub

  RUN apk \
      --update \
      --repository $BETA_REPO/v$ALPINEVERSION \
      --repository $STABLE_REPO/v$ALPINEVERSION \
      add \
        mod_unified_remix~$VERSION \
 && rm -f /var/cache/apk/*


COPY unified-origin.conf.in /etc/apache2/conf.d/unified-origin.conf.in
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh
