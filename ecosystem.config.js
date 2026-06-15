module.exports = {
  apps: [{
    name: "server",
    script: "./build/main",
    exec_mode: "fork",
    instances: 1,

    out_file: "./logs/out.log",
    error_file: "./logs/error.log",
    merge_logs: true,

    autorestart: true,
    max_restarts: 10,
    restart_delay: 3000
  }]
}
