FROM python:3.6-alpine

ARG ELECTRUM_VERSION
ARG ELECTRUM_USER
ARG ELECTRUM_PASSWORD

ENV ELECTRUM_VERSION $ELECTRUM_VERSION
ENV ELECTRUM_USER $ELECTRUM_USER
ENV ELECTRUM_PASSWORD $ELECTRUM_PASSWORD
ENV ELECTRUM_HOME /home/$ELECTRUM_USER

RUN adduser -D $ELECTRUM_USER && \
	pip3 install https://download.electrum.org/${ELECTRUM_VERSION}/Electrum-${ELECTRUM_VERSION}.tar.gz

RUN mkdir -p ${ELECTRUM_HOME}/.electrum/ /data/ && \
	ln -sf ${ELECTRUM_HOME}/.electrum/ /data/ && \
	chown ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum

USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 7000

CMD ["electrum"]
