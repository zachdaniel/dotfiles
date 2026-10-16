import { ActionPanel, Action, List } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { useState } from "react";
import { describe, rows, score, sessionizer, switchWith } from "./sessionizer";

interface Project {
  project: string;
  sessionId: string;
  name: string;
  org: string;
}

// The other Mac's projects, read from it through Rex. Projects with a session
// open there are tagged.
export default function Command() {
  const { data, isLoading, error } = usePromise(async () =>
    rows(await sessionizer("--projects", "--other")).map(
      ([project, sessionId]): Project => ({
        project,
        sessionId: sessionId ?? "",
        ...describe(project),
      }),
    ),
  );
  const [searchText, setSearchText] = useState("");

  const filtered = (data ?? [])
    .map((project) => ({
      project,
      s: score(project.name, project.org, searchText),
    }))
    .filter((x): x is { project: Project; s: number } => x.s !== null)
    .sort((a, b) => b.s - a.s || a.project.name.localeCompare(b.project.name));

  return (
    <List
      searchBarPlaceholder="Search the other Mac's projects..."
      isLoading={isLoading}
      filtering={false}
      onSearchTextChange={setSearchText}
    >
      {error && (
        <List.EmptyView
          title="Couldn't read the other Mac's projects"
          description={error.message}
        />
      )}
      {filtered.map(({ project }) => (
        <List.Item
          key={project.project}
          title={project.name}
          subtitle={project.org}
          accessories={[
            ...(project.sessionId ? [{ tag: "open" }] : []),
            { text: project.project },
          ]}
          actions={
            <ActionPanel>
              <Action
                title="Switch to Project"
                onAction={() => switchWith(["--other", project.project])}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
