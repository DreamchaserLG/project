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
  const mvnArgs = [
    "-B",
    "-Dmaven.resources.skip=true",
    "-DskipTests",
    "-Dmaven.test.skip=true",
    "package",
  ];
  if (mavenSettings) {
    mvnArgs.splice(1, 0, "-s", mavenSettings);
  }
  const code = await runCommand(mavenCmd, mvnArgs);
  process.exit(code);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
