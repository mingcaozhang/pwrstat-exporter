FROM rust:1.43.1 as build

WORKDIR /usr/src/pwrstat-exporter
COPY . .

RUN curl https://dl4jz3rbrsfum.cloudfront.net/software/PPL-1.3.3-64bit.deb --output powerpanel.deb \
    && apt-get install ./powerpanel.deb

RUN cargo clean \
    cargo update \
    cargo install --path .

RUN echo "ALL ALL = NOPASSWD: /usr/sbin/pwrstat" >> /etc/sudoers

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["pwrstat-exporter"]
