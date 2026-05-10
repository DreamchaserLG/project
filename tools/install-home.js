const fs = require("fs");
const path = require("path");
const { spawn } = require("child_process");

const rootDir = path.resolve(__dirname, "..");
const homeDir = path.join(rootDir, "frontend", "home");
const npmCacheDir = path.join(rootDir, ".npm-cache");

function quoteWindowsArg(value) {
  if (!/[ \t"]/.test(value)) {
    return value;
  }
  return `"${value.replace(/"/g, '\\"')}"`;
}

function copyIfPresent(fromPath, toPath) {
  if (!fs.existsSync(fromPath)) {
    return;
  }
  fs.copyFileSync(fromPath, toPath);
}

function removeIfPresent(targetPath) {
  fs.rmSync(targetPath, { recursive: true, force: true });
}

function isHomeInstallComplete() {
  return fs.existsSync(
    path.join(homeDir, "node_modules", "@vue", "cli-service", "bin", "vue-cli-service.js")
  );
}

function prepareInstallWorkspace() {
  if (isHomeInstallComplete()) {
    return;
  }

  removeIfPresent(path.join(homeDir, "node_modules"));
  removeIfPresent(path.join(homeDir, "package-lock.json"));
}

function patchVueOfficeEntries() {
  const packages = [
    { name: "docx", copyCss: true },
    { name: "excel", copyCss: true },
    { name: "pptx", copyCss: false },
  ];

  for (const pkg of packages) {
    const libDir = path.join(homeDir, "node_modules", "@vue-office", pkg.name, "lib");
    const v2Dir = path.join(libDir, "v2");
    copyIfPresent(path.join(v2Dir, "index.js"), path.join(libDir, "index.js"));
    if (pkg.copyCss) {
      copyIfPresent(path.join(v2Dir, "index.css"), path.join(libDir, "index.css"));
    }
  }
}

const cmd = process.env.ComSpec || "cmd.exe";
prepareInstallWorkspace();
const commandLine = [
  "npm.cmd",
  "--prefix",
  homeDir,
  "install",
  "--legacy-peer-deps",
  "--ignore-scripts",
].map(quoteWindowsArg).join(" ");

const child = spawn(cmd, ["/d", "/s", "/c", commandLine], {
  cwd: rootDir,
  env: {
    ...process.env,
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
    npm_config_prefer_offline: "false",
    NPM_CONFIG_PREFER_OFFLINE: "false",
    npm_config_cache: npmCacheDir,
    NPM_CONFIG_CACHE: npmCacheDir,
  },
  stdio: "inherit",
  shell: false,
});

child.on("exit", (code) => {
  if (code) {
    process.exit(code);
    return;
  }

  try {
    patchVueOfficeEntries();
  } catch (error) {
    console.error(error.message);
    process.exit(1);
    return;
  }

  process.exit(0);
});

child.on("error", (error) => {
  console.error(error.message);
  process.exit(1);
});
