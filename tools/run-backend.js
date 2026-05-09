const path = require("path");
const {
  explodeJar,
  getExplodedClasspath,
  prepareTargetResources,
  rootDir,
  runCommand,
  stopRunningBackend,
} = require("./backend-support");

async function main() {
  stopRunningBackend();
  prepareTargetResources();
  const packageCode = await runCommand("node", [
    path.join(rootDir, "tools", "package-backend.js"),
  ]);
  if (packageCode) {
    process.exit(packageCode);
    return;
  }

  explodeJar();
  const runCode = await runCommand("java", [
    "-cp",
    getExplodedClasspath(),
    "com.project.demo.Application",
  ]);
  process.exit(runCode);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
