import { ActionPanel, Action, List, closeMainWindow, showToast, Toast } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { execSync } from "child_process";
import { access, readdir, stat } from "fs/promises";
import { homedir } from "os";
import { join } from "path";

const PROJECT_MARKERS = [
  ".git", "mix.exs", "Cargo.toml", "package.json", "go.mod",
  "pyproject.toml", "Gemfile", "build.zig", "flake.nix", "Makefile",
  "dune-project", ".project-root",
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

function switchToProject(project: Project) {
  try {
    execSync(`~/.dotfiles/scripts/ghostty-sessionizer "${project.path}"`, {
      shell: "/bin/bash",
      timeout: 10000,
    });
  } catch (e) {
    showToast({ style: Toast.Style.Failure, title: "Failed to switch", message: String(e) });
  }
}

export default function Command() {
  const { data: projects, isLoading } = usePromise(getProjects);

  return (
    <List searchBarPlaceholder="Search projects..." isLoading={isLoading}>
      {(projects ?? []).map((project) => (
        <List.Item
          key={project.path}
          title={project.name}
          subtitle={project.org}
          accessories={[{ text: project.path.replace(homedir(), "~") }]}
          actions={
            <ActionPanel>
              <Action
                title="Switch to Project"
                onAction={async () => {
                  await closeMainWindow();
                  switchToProject(project);
                }}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
