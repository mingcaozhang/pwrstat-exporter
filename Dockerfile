FROM rust:1.43.1 as build

WORKDIR /usr/src/pwrstat-exporter
COPY . .

RUN curl https://dl4jz3rbrsfum.cloudfront.net/software/PPL-1.3.3-64bit.deb --output powerpanel.deb
RUN apt-get install ./powerpanel.deb

RUN cargo clean
RUN cargo update
RUN cargo install --path .

RUN echo "ALL ALL = NOPASSWD: /usr/sbin/pwrstat" >> /etc/sudoers

CMD pwrstatd \
    && pwrstat -pwrfail -shutdown off \
    && pwrstat -pwrfail -active off \
    && pwrstat -lowbatt -shutdown off \
    && pwrstat -lowbatt -active off \
    && pwrstat-exporter
