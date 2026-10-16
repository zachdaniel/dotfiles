import { closeMainWindow, showHUD } from "@raycast/api";
import { execSync } from "child_process";

// The picker runs on the other Mac, in a temporary Rex session the app
// switches to, so it lists that Mac's projects.
export default async function Command() {
  await closeMainWindow();
  try {
    execSync("~/.dotfiles/scripts/rex-sessionizer --other", {
      shell: "/bin/bash",
      timeout: 10000,
    });
  } catch (e) {
    await showHUD(`Failed to open the other Mac's projects: ${String(e)}`);
  }
}
