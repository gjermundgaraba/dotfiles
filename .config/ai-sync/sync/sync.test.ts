import { describe, test, expect, beforeEach, afterEach } from "bun:test";
import { mkdirSync, rmSync, writeFileSync, existsSync, lstatSync, readlinkSync } from "fs";
import { join } from "path";
import { tmpdir } from "os";
import { sync, AGENT_SKILL_PATHS, type Config } from "./sync";

describe("sync", () => {
  let tempDir: string;
  let skillsSourceDir: string;
  let projectDir: string;
  let configPath: string;

  beforeEach(() => {
    // Create unique temp directory for each test
    tempDir = join(tmpdir(), `ai-sync-test-${Date.now()}-${Math.random().toString(36).slice(2)}`);
    skillsSourceDir = join(tempDir, "skills");
    projectDir = join(tempDir, "test-project");
    configPath = join(tempDir, "config.json");

    // Create directory structure
    mkdirSync(skillsSourceDir, { recursive: true });
    mkdirSync(projectDir, { recursive: true });
  });

  afterEach(() => {
    // Cleanup temp directory
    if (existsSync(tempDir)) {
      rmSync(tempDir, { recursive: true, force: true });
    }
  });

  test("syncs skills to project directory for all agents", async () => {
    // Create mock skills
    const skillName = "test-skill";
    const skillDir = join(skillsSourceDir, skillName);
    mkdirSync(skillDir);
    writeFileSync(join(skillDir, "SKILL.md"), "# Test Skill");

    // Create config
    const config: Config = {
      projects: [
        {
          path: projectDir,
          skills: [skillName],
          agents: ["claude", "opencode"],
        },
      ],
    };
    writeFileSync(configPath, JSON.stringify(config, null, 2));

    // Run sync
    await sync({ configPath, skillsSourceDir });

    // Verify symlinks were created for both agents
    for (const agent of ["claude", "opencode"] as const) {
      const expectedSymlinkPath = join(projectDir, AGENT_SKILL_PATHS[agent], skillName);
      
      expect(existsSync(expectedSymlinkPath)).toBe(true);
      
      const stat = lstatSync(expectedSymlinkPath);
      expect(stat.isSymbolicLink()).toBe(true);
      
      const linkTarget = readlinkSync(expectedSymlinkPath);
      expect(linkTarget).toBe(skillDir);
    }
  });

  test("creates skill directories if they don't exist", async () => {
    const skillName = "another-skill";
    const skillDir = join(skillsSourceDir, skillName);
    mkdirSync(skillDir);
    writeFileSync(join(skillDir, "SKILL.md"), "# Another Skill");

    const config: Config = {
      projects: [
        {
          path: projectDir,
          skills: [skillName],
          agents: ["claude"],
        },
      ],
    };
    writeFileSync(configPath, JSON.stringify(config, null, 2));

    // Verify skill dir doesn't exist yet
    const skillTargetDir = join(projectDir, AGENT_SKILL_PATHS.claude);
    expect(existsSync(skillTargetDir)).toBe(false);

    await sync({ configPath, skillsSourceDir });

    // Verify it was created
    expect(existsSync(skillTargetDir)).toBe(true);
  });

  test("skips syncing if skill source doesn't exist", async () => {
    const config: Config = {
      projects: [
        {
          path: projectDir,
          skills: ["nonexistent-skill"],
          agents: ["claude"],
        },
      ],
    };
    writeFileSync(configPath, JSON.stringify(config, null, 2));

    // Should not throw
    await sync({ configPath, skillsSourceDir });

    // Skill directory should exist but be empty (no symlinks)
    const skillTargetDir = join(projectDir, AGENT_SKILL_PATHS.claude);
    expect(existsSync(skillTargetDir)).toBe(true);
    expect(existsSync(join(skillTargetDir, "nonexistent-skill"))).toBe(false);
  });

  test("handles projects with no skills configured", async () => {
    const config: Config = {
      projects: [
        {
          path: projectDir,
          skills: [],
          agents: ["claude"],
        },
      ],
    };
    writeFileSync(configPath, JSON.stringify(config, null, 2));

    // Should not throw
    await sync({ configPath, skillsSourceDir });
  });

  test("skips already linked skills", async () => {
    const skillName = "existing-skill";
    const skillDir = join(skillsSourceDir, skillName);
    mkdirSync(skillDir);
    writeFileSync(join(skillDir, "SKILL.md"), "# Existing");

    const config: Config = {
      projects: [
        {
          path: projectDir,
          skills: [skillName],
          agents: ["claude"],
        },
      ],
    };
    writeFileSync(configPath, JSON.stringify(config, null, 2));

    // Run sync twice
    await sync({ configPath, skillsSourceDir });
    await sync({ configPath, skillsSourceDir });

    // Should still work, symlink should still exist
    const symlinkPath = join(projectDir, AGENT_SKILL_PATHS.claude, skillName);
    expect(existsSync(symlinkPath)).toBe(true);
    expect(lstatSync(symlinkPath).isSymbolicLink()).toBe(true);
  });

  test("handles multiple skills", async () => {
    const skills = ["skill-one", "skill-two", "skill-three"];
    
    for (const skill of skills) {
      const skillDir = join(skillsSourceDir, skill);
      mkdirSync(skillDir);
      writeFileSync(join(skillDir, "SKILL.md"), `# ${skill}`);
    }

    const config: Config = {
      projects: [
        {
          path: projectDir,
          skills,
          agents: ["opencode"],
        },
      ],
    };
    writeFileSync(configPath, JSON.stringify(config, null, 2));

    await sync({ configPath, skillsSourceDir });

    for (const skill of skills) {
      const symlinkPath = join(projectDir, AGENT_SKILL_PATHS.opencode, skill);
      expect(existsSync(symlinkPath)).toBe(true);
      expect(lstatSync(symlinkPath).isSymbolicLink()).toBe(true);
    }
  });

  test("handles multiple projects", async () => {
    const secondProjectDir = join(tempDir, "second-project");
    mkdirSync(secondProjectDir);

    const skillName = "shared-skill";
    const skillDir = join(skillsSourceDir, skillName);
    mkdirSync(skillDir);
    writeFileSync(join(skillDir, "SKILL.md"), "# Shared");

    const config: Config = {
      projects: [
        {
          path: projectDir,
          skills: [skillName],
          agents: ["claude"],
        },
        {
          path: secondProjectDir,
          skills: [skillName],
          agents: ["opencode"],
        },
      ],
    };
    writeFileSync(configPath, JSON.stringify(config, null, 2));

    await sync({ configPath, skillsSourceDir });

    // Verify first project
    expect(existsSync(join(projectDir, AGENT_SKILL_PATHS.claude, skillName))).toBe(true);
    
    // Verify second project
    expect(existsSync(join(secondProjectDir, AGENT_SKILL_PATHS.opencode, skillName))).toBe(true);
  });
});
