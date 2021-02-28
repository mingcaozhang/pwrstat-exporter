FROM rust:1.43.1 as build
ENV PKG_CONFIG_ALLOW_CROSS=1

WORKDIR /usr/src/pwrstat-exporter
COPY . .

RUN cargo clean
RUN cargo update
RUN cargo install --path .

FROM gcr.io/distroless/cc-debian10

COPY --from=build /usr/local/cargo/bin/pwrstat-exporter /usr/local/bin/pwrstat-exporter

CMD ["pwrstat-exporter"]
