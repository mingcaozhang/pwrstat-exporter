FROM rust:1.43.1 as build

WORKDIR /usr/src/pwrstat-exporter
COPY . .

RUN curl https://dl4jz3rbrsfum.cloudfront.net/software/PPL-1.3.3-64bit.deb --output powerpanel.deb \
    && apt-get install ./powerpanel.deb && echo "ALL ALL = NOPASSWD: /usr/sbin/pwrstat" >> /etc/sudoers

RUN cargo clean \
    && cargo update \
    && cargo install --path .

FROM gcr.io/distroless/cc-debian10
COPY ./docker-entrypoint.sh /
COPY --from=build /etc/sudoers /etc/sudoers
COPY --from=build /usr/sbin/pwrstat /usr/sbin/pwrstat
COPY --from=build /usr/local/cargo/bin/pwrstat-exporter /usr/local/bin/pwrstat-exporter

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["pwrstat-exporter"]
