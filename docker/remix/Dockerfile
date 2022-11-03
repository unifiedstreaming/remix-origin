ARG ALPINEVERSION=3.16

FROM alpine:$ALPINEVERSION

# ARGs declared before FROM are in a different scope, so need to be stated again
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG ALPINEVERSION
ARG REPO=https://beta.apk.unified-streaming.com/alpine/
ARG VERSION=1.11.21

# Get USP public key
RUN wget -q -O /etc/apk/keys/alpine@unified-streaming.com.rsa.pub \
    https://stable.apk.unified-streaming.com/alpine@unified-streaming.com.rsa.pub

# Install Remix
RUN apk \
    --update \
    --repository $REPO/v$ALPINEVERSION \
    add \
		mp4split~$VERSION \
        mod_unified_remix~$VERSION \
        mod_unified_s3_auth~$VERSION \
 && rm -f /var/cache/apk/* \
 && mkdir -p /var/www/unified-origin å

RUN mkdir -p /run/apache2 \
    && ln -s /dev/stderr /var/log/apache2/error.log \
    && ln -s /dev/stdout /var/log/apache2/access.log \
    && mkdir -p /var/www/unified-origin \
    && rm -f /etc/apache2/conf.d/*
    
COPY conf.d /etc/apache2/conf.d
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["-D", "FOREGROUND"]
