const {
  cleanupPackagedArtifacts,
  mavenCmd,
  mavenSettings,
  prepareTargetResources,
  runCommand,
  stopRunningBackend,
} = require("./backend-support");

async function main() {
  stopRunningBackend();
  prepareTargetResources();
  cleanupPackagedArtifacts();
  const code = await runCommand(mavenCmd, [
    "-B",
    "-s",
    mavenSettings,
    "-Dmaven.resources.skip=true",
    "-DskipTests",
    "-Dmaven.test.skip=true",
    "package",
  ]);
  process.exit(code);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
