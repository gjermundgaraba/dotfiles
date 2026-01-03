import { existsSync, readdirSync } from "fs";
import { resolve, join, dirname } from "path";
import type { Config, ProjectConfig, Agent } from "./sync";
import { SUPPORTED_AGENTS } from "./sync";

function getSyncDir(): string {
  const isCompiled = import.meta.dir.startsWith("/$bunfs");
  if (isCompiled) {
    return dirname(process.execPath);
  }
  return import.meta.dir;
}

function getAvailableSkills(skillsDir: string): string[] {
  if (!existsSync(skillsDir)) {
    return [];
  }
  return readdirSync(skillsDir, { withFileTypes: true })
    .filter((dirent) => dirent.isDirectory())
    .map((dirent) => dirent.name);
}

export async function generateExample(): Promise<void> {
  const syncDir = getSyncDir();
  const rootDir = resolve(syncDir, "..");
  const skillsSourceDir = join(rootDir, "skills");

  const availableSkills = getAvailableSkills(skillsSourceDir);

  const exampleProject: ProjectConfig = {
    path: "/path/to/your/project",
    skills: availableSkills.length > 0 ? availableSkills : ["skill-creator"],
    agents: [...SUPPORTED_AGENTS],
  };

  const exampleConfig: Config = {
    projects: [exampleProject],
  };

  const output = JSON.stringify(exampleConfig, null, 2);

  console.log("Example config.json:\n");
  console.log(output);
  console.log("\n---");
  console.log(`Available skills: ${availableSkills.join(", ") || "none found"}`);
  console.log(`Available agents: ${SUPPORTED_AGENTS.join(", ")}`);
  console.log("\nTo use: save this to sync/config.json and update the project path");
}
