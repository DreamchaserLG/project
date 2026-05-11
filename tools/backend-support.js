const fs = require("fs");
const path = require("path");
const { spawn, spawnSync } = require("child_process");

const rootDir = path.resolve(__dirname, "..");
const targetClassesDir = path.join(rootDir, "target", "classes");
const mapperSourceDir = path.join(rootDir, "src", "main", "resources", "mapper");
const mapperTargetDir = path.join(targetClassesDir, "mapper");
const bundledMavenCmd = path.join(rootDir, "maven", "bin", "mvn.cmd");
const bundledMavenSettings = path.join(rootDir, "maven", "conf", "settings.xml");
const mavenCmd = fs.existsSync(bundledMavenCmd) ? bundledMavenCmd : "mvn";
const mavenSettings = fs.existsSync(bundledMavenSettings) ? bundledMavenSettings : null;
const jarPath = path.join(rootDir, "target", "project-spring_boot-1.0-SNAPSHOT.jar");
const runtimeJarPath = path.join(rootDir, "target", "runtime", "project-spring_boot-run.jar");
const explodedDir = path.join(rootDir, "target", "exploded");

function ensureDir(dirPath) {
  fs.mkdirSync(dirPath, { recursive: true });
}

function copyFileIfPresent(sourcePath, targetPath) {
  if (!fs.existsSync(sourcePath)) {
    return;
  }
  ensureDir(path.dirname(targetPath));
  fs.copyFileSync(sourcePath, targetPath);
}

function copyDirectory(sourceDir, targetDir) {
  ensureDir(targetDir);
  for (const entry of fs.readdirSync(sourceDir, { withFileTypes: true })) {
    const fromPath = path.join(sourceDir, entry.name);
    const toPath = path.join(targetDir, entry.name);
    if (entry.isDirectory()) {
      copyDirectory(fromPath, toPath);
    } else {
      fs.copyFileSync(fromPath, toPath);
    }
  }
}

function prepareTargetResources() {
  ensureDir(targetClassesDir);
  copyFileIfPresent(
    path.join(rootDir, "src", "main", "resources", "application.yml"),
    path.join(targetClassesDir, "application.yml")
  );
  copyFileIfPresent(
    path.join(rootDir, "src", "main", "resources", "application-local.yml"),
    path.join(targetClassesDir, "application-local.yml")
  );
  copyFileIfPresent(
    path.join(rootDir, "src", "main", "resources", "application-local.example.yml"),
    path.join(targetClassesDir, "application-local.example.yml")
  );
  if (fs.existsSync(mapperSourceDir)) {
    copyDirectory(mapperSourceDir, mapperTargetDir);
  }
}

function getConfiguredBackendPort() {
  const localConfigPath = path.join(rootDir, "src", "main", "resources", "application-local.yml");
  if (fs.existsSync(localConfigPath)) {
    const content = fs.readFileSync(localConfigPath, "utf8");
    const match = content.match(/^\s*port:\s*(\d+)\s*$/m);
    if (match) {
      return Number(match[1]) || 5000;
    }
  }

  const mainConfigPath = path.join(rootDir, "src", "main", "resources", "application.yml");
  if (fs.existsSync(mainConfigPath)) {
    const content = fs.readFileSync(mainConfigPath, "utf8");
    const match = content.match(/^\s*port:\s*\$\{SERVER_PORT:(\d+)\}\s*$/m);
    if (match) {
      return Number(match[1]) || 5000;
    }
  }

  return 5000;
}

function getBackendPorts() {
  return [...new Set([getConfiguredBackendPort(), 5000, 5001, 5002])];
}

function stopRunningBackend() {
  if (process.platform !== "win32") {
    return;
  }

  const pids = new Set();
  for (const port of getBackendPorts()) {
    const netstat = spawnSync(
      process.env.ComSpec || "cmd.exe",
      ["/d", "/s", "/c", `netstat -ano -p tcp | findstr LISTENING | findstr :${port}`],
      {
        cwd: rootDir,
        encoding: "utf8",
        windowsHide: true,
      }
    );

    for (const line of (netstat.stdout || "").split(/\r?\n/)) {
      const columns = line.trim().split(/\s+/);
      const pid = columns[columns.length - 1];
      if (/^\d+$/.test(pid)) {
        pids.add(pid);
      }
    }
  }

  for (const pid of pids) {
    spawnSync("taskkill", ["/PID", pid, "/F", "/T"], {
      cwd: rootDir,
      stdio: "ignore",
      windowsHide: true,
    });
  }

  spawnSync(process.env.ComSpec || "cmd.exe", ["/d", "/s", "/c", "timeout /t 1 /nobreak >nul"], {
    cwd: rootDir,
    stdio: "ignore",
    windowsHide: true,
  });
}

function copyJarToRuntime() {
  if (!fs.existsSync(jarPath)) {
    throw new Error(`Jar not found: ${jarPath}`);
  }
  ensureDir(path.dirname(runtimeJarPath));
  fs.copyFileSync(jarPath, runtimeJarPath);
}

function cleanupPackagedArtifacts() {
  fs.rmSync(jarPath, { force: true });
  fs.rmSync(`${jarPath}.original`, { force: true });
  fs.rmSync(runtimeJarPath, { force: true });
  fs.rmSync(explodedDir, { recursive: true, force: true });
}

function explodeJar() {
  if (!fs.existsSync(jarPath)) {
    throw new Error(`Jar not found: ${jarPath}`);
  }

  fs.rmSync(explodedDir, { recursive: true, force: true });
  ensureDir(explodedDir);

  const result = spawnSync("jar", ["xf", jarPath], {
    cwd: explodedDir,
    encoding: "utf8",
    windowsHide: true,
  });

  if (result.status !== 0) {
    throw new Error(result.stderr || result.stdout || "Failed to explode backend jar");
  }
}

function getExplodedClasspath() {
  return [
    path.join(explodedDir, "BOOT-INF", "classes"),
    path.join(explodedDir, "BOOT-INF", "lib", "*"),
  ].join(path.delimiter);
}

function quoteWindowsArg(value) {
  if (!/[ \t"]/.test(value)) {
    return value;
  }
  return `"${value.replace(/"/g, '\\"')}"`;
}

function runCommand(file, args, extraEnv) {
  const env = {
    ...process.env,
    SPRING_PROFILES_ACTIVE: process.env.SPRING_PROFILES_ACTIVE || "local",
    ...extraEnv,
  };
  const isCmdScript = /\.(cmd|bat)$/i.test(file);
  const child = spawn(
    isCmdScript ? (process.env.ComSpec || "cmd.exe") : file,
    isCmdScript
      ? ["/d", "/s", "/c", [file, ...args].map(quoteWindowsArg).join(" ")]
      : args,
    {
      cwd: rootDir,
      env,
      stdio: "inherit",
      shell: false,
    }
  );

  return new Promise((resolve, reject) => {
    child.on("exit", (code) => resolve(code || 0));
    child.on("error", reject);
  });
}

module.exports = {
  jarPath,
  mavenCmd,
  mavenSettings,
  prepareTargetResources,
  copyJarToRuntime,
  cleanupPackagedArtifacts,
  explodedDir,
  explodeJar,
  getExplodedClasspath,
  getConfiguredBackendPort,
  rootDir,
  runCommand,
  runtimeJarPath,
  stopRunningBackend,
};
