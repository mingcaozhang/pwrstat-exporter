FROM rust:1.43.1 as build
ENV PKG_CONFIG_ALLOW_CROSS=1

WORKDIR /usr/src/pwrstat-exporter
COPY . .

RUN cargo install --path .

FROM bitnami/minideb-extras:jessie

RUN curl https://dl4jz3rbrsfum.cloudfront.net/software/PPL-1.3.3-64bit.deb --output ./powerpanel.deb && \
  dpkg -i ./powerpanel.deb && \
  apt-get install -f && \
  rm ./powerpanel.deb 

RUN echo "ALL ALL = NOPASSWD: /usr/sbin/pwrstat" >> /etc/sudoers

COPY ./docker-entrypoint.sh /
COPY --from=build /usr/local/cargo/bin/pwrstat-exporter /usr/local/bin/pwrstat-exporter

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["pwrstat-exporter"]
