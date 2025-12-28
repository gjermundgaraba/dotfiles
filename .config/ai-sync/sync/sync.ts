import { existsSync, mkdirSync, symlinkSync, lstatSync, readlinkSync, unlinkSync } from "fs";
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

function syncSkillsForProject(skills: string[], targetDir: string, skillsSourceDir: string): void {
  const skillsTargetDir = join(targetDir, ".claude", "skills");
  mkdirSync(skillsTargetDir, { recursive: true });

  for (const skill of skills) {
    const source = join(skillsSourceDir, skill);
    const target = join(skillsTargetDir, skill);

    if (!existsSync(source)) {
      console.warn(`  [warn] Skill source not found: ${source}`);
      continue;
    }

    if (existsSync(target)) {
      const stat = lstatSync(target);
      if (stat.isSymbolicLink()) {
        const currentLinkTarget = readlinkSync(target);
        if (currentLinkTarget === source) {
          console.log(`  [skip] ${skill} (already linked)`);
          continue;
        }
        unlinkSync(target);
      } else {
        console.warn(`  [warn] ${skill} exists but is not a symlink, skipping`);
        continue;
      }
    }

    symlinkSync(source, target);
    console.log(`  [link] ${skill}`);
  }
}

export async function sync(): Promise<void> {
  const syncDir = getSyncDir();
  const rootDir = resolve(syncDir, "..");
  const skillsSourceDir = join(rootDir, "skills");
  const configPath = join(syncDir, "config.json");

  if (!existsSync(configPath)) {
    console.error(`Config not found: ${configPath}`);
    process.exit(1);
  }

  const text = await Bun.file(configPath).text();
  const config: Config = JSON.parse(text);

  if (config.projects.length === 0) {
    console.log("No projects configured. Use 'add-project' to add one.");
    return;
  }

  for (const project of config.projects) {
    console.log(`\nSyncing: ${project.path}`);

    if (!existsSync(project.path)) {
      console.warn(`  [warn] Project path does not exist, skipping`);
      continue;
    }

    if (project.skills?.length) {
      syncSkillsForProject(project.skills, project.path, skillsSourceDir);
    } else {
      console.log("  No skills configured");
    }
  }

  console.log("\nDone");
}
