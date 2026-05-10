const { spawn } = require("child_process");
const path = require("path");

const rootDir = path.resolve(__dirname, "..");
const adminDir = path.join(rootDir, "frontend", "admin");
const homeDir = path.join(rootDir, "frontend", "home");

const commands = {
  "backend:run": {
    cmd: "node",
    args: [path.join(rootDir, "tools", "run-backend.js")],
    cwd: rootDir,
  },
  "backend:compile": {
    cmd: "node",
    args: [path.join(rootDir, "tools", "package-backend.js")],
    cwd: rootDir,
  },
  "admin:install": {
    cmd: "npm.cmd",
    args: ["--prefix", adminDir, "install", "--legacy-peer-deps"],
    cwd: rootDir,
  },
  "admin:dev": {
    cmd: "npm.cmd",
    args: ["--prefix", adminDir, "run", "dev"],
    cwd: rootDir,
  },
  "admin:build": {
    cmd: "npm.cmd",
    args: ["--prefix", adminDir, "run", "build"],
    cwd: rootDir,
  },
  "home:install": {
    cmd: "node",
    args: [path.join(rootDir, "tools", "install-home.js")],
    cwd: rootDir,
  },
  "home:dev": {
    cmd: "npm.cmd",
    args: ["--prefix", homeDir, "run", "dev"],
    cwd: rootDir,
  },
  "home:build": {
    cmd: "npm.cmd",
    args: ["--prefix", homeDir, "run", "build"],
    cwd: rootDir,
  },
};

function quoteWindowsArg(value) {
  if (!/[ \t"]/.test(value)) {
    return value;
  }
  return `"${value.replace(/"/g, '\\"')}"`;
}

function printHelp() {
  console.log("Usage: node tools/project-cli.js <command>");
  console.log("");
  console.log("Commands:");
  console.log("  backend:run");
  console.log("  backend:compile");
  console.log("  admin:install");
  console.log("  admin:dev");
  console.log("  admin:build");
  console.log("  home:install");
  console.log("  home:dev");
  console.log("  home:build");
}

const commandName = process.argv[2];
if (!commandName || !commands[commandName]) {
  printHelp();
  process.exit(commandName ? 1 : 0);
}

const selected = commands[commandName];
const env = {
  ...process.env,
  SPRING_PROFILES_ACTIVE: process.env.SPRING_PROFILES_ACTIVE || "local",
  VUE_APP_API_BASE_URL: process.env.VUE_APP_API_BASE_URL || "/",
  VUE_APP_DEV_PROXY_TARGET: process.env.VUE_APP_DEV_PROXY_TARGET || "http://127.0.0.1:5000",
  HTTP_PROXY: "",
  HTTPS_PROXY: "",
  ALL_PROXY: "",
  GIT_HTTP_PROXY: "",
  GIT_HTTPS_PROXY: "",
  http_proxy: "",
  https_proxy: "",
  all_proxy: "",
  git_http_proxy: "",
  git_https_proxy: "",
  npm_config_offline: "false",
  NPM_CONFIG_OFFLINE: "false",
  npm_config_cache: path.join(rootDir, ".npm-cache"),
  NPM_CONFIG_CACHE: path.join(rootDir, ".npm-cache"),
};

const isCmdScript = /\.(cmd|bat)$/i.test(selected.cmd);
const child = spawn(
  isCmdScript ? (process.env.ComSpec || "cmd.exe") : selected.cmd,
  isCmdScript
    ? [
      "/d",
      "/s",
      "/c",
      [selected.cmd, ...selected.args].map(quoteWindowsArg).join(" "),
    ]
    : selected.args,
  {
    cwd: selected.cwd,
    env,
    stdio: "inherit",
    shell: false,
  }
);

child.on("exit", (code) => {
  process.exit(code || 0);
});

child.on("error", (error) => {
  console.error(error.message);
  process.exit(1);
});
