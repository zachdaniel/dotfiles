import { ActionPanel, Action, List, closeMainWindow, showToast, Toast } from "@raycast/api";
import { execSync } from "child_process";
import { existsSync, readdirSync, statSync } from "fs";
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

function getProjects(): Project[] {
  const home = homedir();
  const devDir = join(home, "dev");
  const projects: Project[] = [];

  // ~/.dotfiles
  projects.push({ name: ".dotfiles", path: join(home, ".dotfiles"), org: "~" });

  // ~/dev/<org>/<project> (depth 2), only if it looks like a project
  try {
    for (const org of readdirSync(devDir)) {
      if (org.startsWith(".")) continue;
      const orgPath = join(devDir, org);
      try {
        if (!statSync(orgPath).isDirectory()) continue;
        for (const entry of readdirSync(orgPath)) {
          if (entry.startsWith(".")) continue;
          const entryPath = join(orgPath, entry);
          try {
            if (!statSync(entryPath).isDirectory()) continue;
            const isProject = PROJECT_MARKERS.some((m) => existsSync(join(entryPath, m)));
            if (isProject) {
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
  const projects = getProjects();

  return (
    <List searchBarPlaceholder="Search projects...">
      {projects.map((project) => (
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
