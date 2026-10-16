import { ActionPanel, Action, List } from "@raycast/api";
import { usePromise } from "@raycast/utils";
import { useState } from "react";
import { rows, score, sessionizer, switchWith } from "./sessionizer";

interface Session {
  id: string;
  label: string;
  project: string;
}

// The Rex sessions open on this Mac or the other one
export function OpenSessions({ other }: { other: boolean }) {
  const { data, isLoading, error } = usePromise(
    async (other: boolean) =>
      rows(await sessionizer("--sessions", ...(other ? ["--other"] : []))).map(
        ([id, label, project]): Session => ({
          id,
          label,
          project: project ?? "",
        }),
      ),
    [other],
  );
  const [searchText, setSearchText] = useState("");

  const filtered = (data ?? [])
    .map((session) => ({
      session,
      s: score(session.label, session.project, searchText),
    }))
    .filter((x): x is { session: Session; s: number } => x.s !== null)
    .sort(
      (a, b) => b.s - a.s || a.session.label.localeCompare(b.session.label),
    );

  return (
    <List
      searchBarPlaceholder={
        other
          ? "Search projects open on the other Mac..."
          : "Search open projects..."
      }
      isLoading={isLoading}
      filtering={false}
      onSearchTextChange={setSearchText}
    >
      {error && (
        <List.EmptyView
          title="Couldn't list the open sessions"
          description={error.message}
        />
      )}
      {filtered.map(({ session }) => (
        <List.Item
          key={session.id}
          title={session.label}
          accessories={session.project ? [{ text: session.project }] : []}
          actions={
            <ActionPanel>
              <Action
                title="Switch to Session"
                onAction={() => switchWith(["--select", session.id])}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
