FROM python:3.6-alpine

RUN apk add --no-cache curl build-base linux-headers

ARG ELECTRUM_VERSION
ARG ELECTRUM_USER
ARG ELECTRUM_PASSWORD

ENV ELECTRUM_VERSION $ELECTRUM_VERSION
ENV ELECTRUM_USER $ELECTRUM_USER
ENV ELECTRUM_PASSWORD $ELECTRUM_PASSWORD
ENV ELECTRUM_HOME /home/$ELECTRUM_USER

RUN adduser -D $ELECTRUM_USER && \
	pip3 install https://download.electrum.org/${ELECTRUM_VERSION}/Electrum-${ELECTRUM_VERSION}.tar.gz


RUN mkdir -p ${ELECTRUM_HOME}/.electrum/wallets/ ${ELECTRUM_HOME}/.electrum/testnet/wallets/ /data/ && \
	ln -sf  /data/default_wallet ${ELECTRUM_HOME}/.electrum/testnet/wallets/ && \
	ln -sf /data/default_wallet ${ELECTRUM_HOME}/.electrum/wallets/ && \
	chown -R ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh

USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 7777
