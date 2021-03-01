# pwrstat-exporter

A Prometheus exporter for[pwrstat](https://www.cyberpowersystems.com/product/software/power-panel-personal/powerpanel-for-linux/) written in Rust.

## Prerequisites

Currently, the only supported way to run this is via docker.
`cargo run` may also work if you have pwrstat installed and configured, but it is not guaranteed as some environment setup is required.

## Install

```bash
git clone https://github.com/mingcaozhang/pwrstat-exporter.git
cd pwrstat-exporter
docker build -t pwrstat-exporter .
docker run -it --name pwrstat-exporter -p 9185:9185 --device=/dev/usb/hiddev0 pwrstat-exporter
```

You may need to change the device if `/dev/usb/hiddev0` is not your UPS.
