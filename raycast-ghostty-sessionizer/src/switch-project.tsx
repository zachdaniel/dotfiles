import { ActionPanel, Action, List } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { useState } from "react";
import { access, readdir, stat } from "fs/promises";
import { homedir } from "os";
import { join } from "path";
import { score, switchWith } from "./sessionizer";

const PROJECT_MARKERS = [
  ".git",
  "mix.exs",
  "Cargo.toml",
  "package.json",
  "go.mod",
  "pyproject.toml",
  "Gemfile",
  "build.zig",
  "flake.nix",
  "Makefile",
  "dune-project",
  ".project-root",
];

interface Project {
  name: string;
  path: string;
  org: string;
}

async function hasMarker(dir: string): Promise<boolean> {
  for (const m of PROJECT_MARKERS) {
    try {
      await access(join(dir, m));
      return true;
    } catch {
      // marker not found, try next
    }
  }
  return false;
}

async function getProjects(): Promise<Project[]> {
  const home = homedir();
  const devDir = join(home, "dev");
  const projects: Project[] = [];

  // ~/.dotfiles
  projects.push({ name: ".dotfiles", path: join(home, ".dotfiles"), org: "~" });

  // ~/dev/vaults/obsidian
  projects.push({
    name: "obsidian",
    path: join(home, "dev", "vaults", "obsidian"),
    org: "vaults",
  });

  // ~/dev/<org>/<project> (depth 2), only if it looks like a project
  try {
    const orgs = await readdir(devDir);
    for (const org of orgs) {
      if (org.startsWith(".")) continue;
      const orgPath = join(devDir, org);
      try {
        if (!(await stat(orgPath)).isDirectory()) continue;
        const entries = await readdir(orgPath);
        for (const entry of entries) {
          if (entry.startsWith(".")) continue;
          const entryPath = join(orgPath, entry);
          try {
            if (!(await stat(entryPath)).isDirectory()) continue;
            if (await hasMarker(entryPath)) {
              projects.push({ name: entry, path: entryPath, org });
            }
          } catch {
            // skip inaccessible
          }
        }
      } catch {
        // skip inaccessible
      }
    }
  } catch {
    // dev dir doesn't exist
  }

  return projects.sort((a, b) => a.name.localeCompare(b.name));
}

export default function Command() {
  const { data: projects, isLoading } = usePromise(getProjects);
  const [searchText, setSearchText] = useState("");

  const filtered = (projects ?? [])
    .map((project) => ({
      project,
      s: score(project.name, project.org, searchText),
    }))
    .filter((x): x is { project: Project; s: number } => x.s !== null)
    .sort((a, b) => b.s - a.s || a.project.name.localeCompare(b.project.name));

  return (
    <List
      searchBarPlaceholder="Search projects..."
      isLoading={isLoading}
      filtering={false}
      onSearchTextChange={setSearchText}
    >
      {filtered.map(({ project }) => (
        <List.Item
          key={project.path}
          title={project.name}
          subtitle={project.org}
          accessories={[{ text: project.path.replace(homedir(), "~") }]}
          actions={
            <ActionPanel>
              <Action
                title="Switch to Project"
                onAction={() => switchWith([project.path])}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
