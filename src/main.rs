use std::net::SocketAddr;
use std::process::Command;

use env_logger::{
    Builder,
    Env,
};
use prometheus_exporter::prometheus::register_gauge;

fn main() {
    Builder::from_env(Env::default().default_filter_or("info")).init();

    let addr_raw = "0.0.0.0:9185";
    let addr: SocketAddr = addr_raw.parse().expect("can not parse listen addr");

    let exporter = prometheus_exporter::start(addr).expect("can not start exporter");

    let battery_capacity = register_gauge!("battery_capacity", "Remaining battery charge in percentage").expect("can not create gauge battery_capacity");
    let remaining_runtime = register_gauge!("remaining_runtime", "Remaining runtime on battery in minutes").expect("can not create gauge remaining_runtime");
    let power_draw = register_gauge!("power_draw", "Current power draw in Watts").expect("can not create gauge power_draw");

    loop {
        let _guard = exporter.wait_request();

        let pwrstat_cmd = Command::new("pwrstat").arg("-status").output().expect("failed to execute process");
        let pwrstat_str = String::from_utf8(pwrstat_cmd.stdout).expect("invalid string");
        let lines = pwrstat_str.lines().filter(|&s| s.contains("Load") || s.contains("Battery Capacity") || s.contains("Remaining Runtime")).collect::<Vec<&str>>();

        let mapping = lines.into_iter().map(|a| {
            let words = a.split(".").filter(|&s| s.ne("")).collect::<Vec<_>>();
            (words[0].trim(), words[1].split_whitespace().collect::<Vec<&str>>()[0].parse::<f64>().unwrap())
        }).collect::<Vec<_>>();

        for tuple in mapping {
            if tuple.0.eq("Battery Capacity") {
                battery_capacity.set(tuple.1);
            } else if tuple.0.eq("Remaining Runtime") {
                remaining_runtime.set(tuple.1);
            } else if tuple.0.eq("Load") {
                power_draw.set(tuple.1);
            }
        }
    }
}
