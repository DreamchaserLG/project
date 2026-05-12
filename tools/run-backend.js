const path = require("path");
const {
  explodeJar,
  getExplodedClasspath,
  jarPath,
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

  let runCode;
  try {
    explodeJar();
    runCode = await runCommand("java", [
      "-cp",
      getExplodedClasspath(),
      "com.project.demo.Application",
    ]);
  } catch (error) {
    console.warn(`Failed to explode backend jar, fallback to java -jar: ${error.message}`);
    runCode = await runCommand("java", ["-jar", jarPath]);
  }
  process.exit(runCode);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
