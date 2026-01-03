import { existsSync, mkdirSync, symlinkSync, lstatSync, readlinkSync, unlinkSync, readdirSync } from "fs";
import { resolve, join, dirname } from "path";

export const SUPPORTED_AGENTS = ["claude", "opencode"] as const;
export type Agent = (typeof SUPPORTED_AGENTS)[number];

export const AGENT_SKILL_PATHS: Record<Agent, string> = {
  claude: ".claude/skills",
  opencode: ".opencode/skill",
};

export interface ProjectConfig {
  path: string;
  skills?: string[];
  agents: Agent[];
}

export interface Config {
  projects: ProjectConfig[];
}

function getSyncDir(): string {
  const isCompiled = import.meta.dir.startsWith("/$bunfs");
  if (isCompiled) {
    return dirname(process.execPath);
  }
  return import.meta.dir;
}

function validateAgents(agents: string[], projectPath: string): Agent[] {
  if (!agents || agents.length === 0) {
    console.error(`Error: Project "${projectPath}" has no agents configured.`);
    console.error(`Supported agents: ${SUPPORTED_AGENTS.join(", ")}`);
    process.exit(1);
  }

  const unsupported = agents.filter((a) => !SUPPORTED_AGENTS.includes(a as Agent));
  if (unsupported.length > 0) {
    console.error(`Error: Project "${projectPath}" has unsupported agents: ${unsupported.join(", ")}`);
    console.error(`Supported agents: ${SUPPORTED_AGENTS.join(", ")}`);
    process.exit(1);
  }

  return agents as Agent[];
}

function cleanupOrphanedSymlinks(skills: string[], targetDir: string, skillsSourceDir: string, agent: Agent): void {
  const skillsTargetDir = join(targetDir, AGENT_SKILL_PATHS[agent]);

  if (!existsSync(skillsTargetDir)) {
    return;
  }

  const entries = readdirSync(skillsTargetDir);

  for (const entry of entries) {
    const entryPath = join(skillsTargetDir, entry);

    // Only process symlinks
    if (!lstatSync(entryPath).isSymbolicLink()) {
      continue;
    }

    // Check if this symlink points to our skills source directory
    const linkTarget = readlinkSync(entryPath);
    if (!linkTarget.startsWith(skillsSourceDir)) {
      continue;
    }

    // Remove if skill is no longer in the config
    if (!skills.includes(entry)) {
      unlinkSync(entryPath);
      console.log(`    [cleanup] ${entry} (removed from config)`);
    }
  }
}

function syncSkillsForAgent(skills: string[], targetDir: string, skillsSourceDir: string, agent: Agent): void {
  const skillsTargetDir = join(targetDir, AGENT_SKILL_PATHS[agent]);
  mkdirSync(skillsTargetDir, { recursive: true });

  // Clean up symlinks for skills no longer in config
  cleanupOrphanedSymlinks(skills, targetDir, skillsSourceDir, agent);

  for (const skill of skills) {
    const source = join(skillsSourceDir, skill);
    const target = join(skillsTargetDir, skill);

    if (!existsSync(source)) {
      console.warn(`    [warn] Skill source not found: ${source}`);
      continue;
    }

    if (existsSync(target)) {
      const stat = lstatSync(target);
      if (stat.isSymbolicLink()) {
        const currentLinkTarget = readlinkSync(target);
        if (currentLinkTarget === source) {
          console.log(`    [skip] ${skill} (already linked)`);
          continue;
        }
        unlinkSync(target);
      } else {
        console.warn(`    [warn] ${skill} exists but is not a symlink, skipping`);
        continue;
      }
    }

    symlinkSync(source, target);
    console.log(`    [link] ${skill}`);
  }
}

export interface SyncOptions {
  configPath?: string;
  skillsSourceDir?: string;
}

export async function sync(options: SyncOptions = {}): Promise<void> {
  const syncDir = getSyncDir();
  const rootDir = resolve(syncDir, "..");
  const skillsSourceDir = options.skillsSourceDir ?? join(rootDir, "skills");
  const configPath = options.configPath ?? join(syncDir, "config.json");

  if (!existsSync(configPath)) {
    console.error(`Config not found: ${configPath}`);
    console.error(`Run 'ai-sync generate-example' to see an example configuration.`);
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

    const agents = validateAgents(project.agents, project.path);

    if (!project.skills?.length) {
      console.log("  No skills configured");
      continue;
    }

    for (const agent of agents) {
      console.log(`  [${agent}]`);
      syncSkillsForAgent(project.skills, project.path, skillsSourceDir, agent);
    }
  }

  console.log("\nDone");
}
