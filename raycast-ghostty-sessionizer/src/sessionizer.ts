import { closeMainWindow, showHUD } from "@raycast/api";
import { execFile } from "child_process";
import { appendFile, mkdir } from "fs/promises";
import { homedir } from "os";
import { join } from "path";
import { promisify } from "util";

const SCRIPT = join(homedir(), ".dotfiles", "scripts", "rex-sessionizer");
const STATE = join(homedir(), ".local", "state", "rex-sessionizer");

// Run rex-sessionizer and return what it printed
export async function sessionizer(...args: string[]): Promise<string> {
  const { stdout } = await promisify(execFile)(SCRIPT, args, {
    timeout: 15000,
  });
  return stdout;
}

// rex-sessionizer's tab-separated output, as fields
export function rows(output: string): string[][] {
  return output
    .split("\n")
    .filter((line) => line !== "")
    .map((line) => line.split("\t"));
}

// A project, written as a path from ~, by its name and parent directory
export function describe(project: string): { name: string; org: string } {
  const parts = project.split("/");
  return {
    name: parts[parts.length - 1],
    org: parts.length > 2 ? parts[parts.length - 2] : "~",
  };
}

// Close Raycast and run rex-sessionizer with args, which switches Rex. A
// failure shows as a HUD, since the window is gone, and the full error goes to
// errors.log in the state directory.
export async function switchWith(args: string[]) {
  await closeMainWindow();
  try {
    await sessionizer(...args);
  } catch (e) {
    const err = e as Error & { stderr?: string };
    const message = err.stderr?.trim() || err.message;
    await showHUD(`Failed to switch: ${message.split("\n").pop()}`);
    await mkdir(STATE, { recursive: true });
    await appendFile(
      join(STATE, "errors.log"),
      `${new Date().toISOString()} rex-sessionizer ${args.join(" ")}\n${err.message}\n${err.stderr ?? ""}\n`,
    );
  }
}

// Higher is better; null means no match.
export function score(
  name: string,
  other: string,
  query: string,
): number | null {
  name = name.toLowerCase();
  const q = query.toLowerCase();
  if (q === "") return 0;
  if (name === q) return 1000;
  if (name.startsWith(q)) return 500 - name.length;
  const idx = name.indexOf(q);
  if (idx >= 0) return 250 - idx - name.length;
  // subsequence match, e.g. "agq" -> "ash_graphql"
  let i = 0;
  for (const ch of name) {
    if (ch === q[i]) i++;
    if (i === q.length) return 100 - name.length;
  }
  if (other.toLowerCase().includes(q)) return 50;
  return null;
}
