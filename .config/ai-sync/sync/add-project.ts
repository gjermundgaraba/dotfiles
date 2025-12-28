import { existsSync, readdirSync } from "fs";
import { resolve, join, dirname } from "path";

interface ProjectConfig {
  path: string;
  skills?: string[];
}

interface Config {
  projects: ProjectConfig[];
}

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

export async function addProject(): Promise<void> {
  const syncDir = getSyncDir();
  const rootDir = resolve(syncDir, "..");
  const skillsSourceDir = join(rootDir, "skills");
  const configPath = join(syncDir, "config.json");
  const cwd = process.cwd();

  let config: Config = { projects: [] };
  if (existsSync(configPath)) {
    const text = await Bun.file(configPath).text();
    config = JSON.parse(text);
  }

  const existingProject = config.projects.find(
    (p) => resolve(p.path) === resolve(cwd)
  );
  if (existingProject) {
    console.log(`Project already exists: ${cwd}`);
    console.log(`Skills: ${existingProject.skills?.join(", ") || "none"}`);
    return;
  }

  const availableSkills = getAvailableSkills(skillsSourceDir);
  if (availableSkills.length === 0) {
    console.warn(`No skills found in: ${skillsSourceDir}`);
  }

  const newProject: ProjectConfig = {
    path: cwd,
    skills: availableSkills,
  };

  config.projects.push(newProject);

  await Bun.write(configPath, JSON.stringify(config, null, 2) + "\n");

  console.log(`Added project: ${cwd}`);
  console.log(`Skills: ${availableSkills.join(", ") || "none"}`);
}
