#!/usr/bin/env bun

import { addProject } from "./add-project";
import { generateExample } from "./generate-example";
import { sync } from "./sync";

const COMMANDS = {
  "add-project": addProject,
  "generate-example": generateExample,
  sync: sync,
} as const;

function printUsage(): void {
  console.log("Usage: ai-sync <command>");
  console.log("");
  console.log("Commands:");
  console.log("  add-project       Add current directory as a project with all available skills");
  console.log("  generate-example  Generate an example config.json with all skills and agents");
  console.log("  sync              Sync skills to all configured projects");
}

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const command = args[0];

  if (!command || command === "--help" || command === "-h") {
    printUsage();
    process.exit(command ? 0 : 1);
  }

  const handler = COMMANDS[command as keyof typeof COMMANDS];
  if (!handler) {
    console.error(`Unknown command: ${command}`);
    printUsage();
    process.exit(1);
  }

  await handler();
}

main();
