# Chromium Setup for DevTools MCP

This document explains how to configure a Linux environment that has Chromium installed (at /usr/bin/chromium) to work with the DevTools MCP Chrome tools that expect the Google Chrome binary at /opt/google/chrome/chrome. It captures the problem, the resolution steps, verification, and key operational details (remote debugging, isolated profiles, and connection checks) drawn from the Chrome Setup and Configuration guide.

## Background and Problem

- The DevTools MCP chrome-devtools tools assume the browser binary is at /opt/google/chrome/chrome.
- The environment only had Chromium at /usr/bin/chromium.
- Result: The tools failed to initialize because they could not find the expected Chrome binary.

To resolve this without installing Google Chrome, we:
- Launched Chromium with the required remote debugging flags.
- Created a symlink so the tools could find a “chrome” binary at the expected path.

## Prerequisites

- A Linux system with:
  - Chromium installed and available at /usr/bin/chromium.
  - sudo access (to create /opt/google/chrome and a symlink).
- A free port 9222 (or an alternative port if 9222 is already in use).

## Resolution Steps

1) Verify Chromium is installed and on PATH  
Command:
```bash
which chromium
```
Expected output:
```
/usr/bin/chromium
```

2) Launch Chromium with remote debugging enabled  
Command:
```bash
chromium --remote-debugging-port=9222 --no-first-run --no-default-browser-check --user-data-dir=/tmp/remote-profile &
```
Notes:
- --remote-debugging-port=9222 exposes the Chrome DevTools Protocol (CDP) JSON discovery endpoint and per-target WebSocket endpoints on localhost:9222. The DevTools MCP system expects this unless configured otherwise.
- --user-data-dir=/tmp/remote-profile creates an isolated profile that avoids using your default browser profile, which protects personal data and prevents state conflicts during automation.
- --no-first-run and --no-default-browser-check avoid startup prompts that could interfere with automation.
- You may also set --remote-debugging-address=127.0.0.1 to ensure the debug interface is only reachable from the local machine.

3) Create a symlink at the path expected by the tools  
Commands:
```bash
sudo mkdir -p /opt/google/chrome
sudo ln -s /usr/bin/chromium /opt/google/chrome/chrome
```
Explanation:
- This satisfies the hardcoded expectation for /opt/google/chrome/chrome while still using Chromium.

4) Verify connectivity via the JSON discovery endpoint  
- Open http://localhost:9222/json in a browser or curl it:
```bash
curl http://localhost:9222/json
```
- If Chromium is running correctly on port 9222 and at least one tab is open, you should see an array of target objects with fields such as id, type, title, url, and webSocketDebuggerUrl.
- The DevTools MCP system filters for targets where type === "page" and uses webSocketDebuggerUrl to connect.

Once this endpoint returns at least one page target, the chrome-devtools MCP tools should function properly.

## Why These Flags Matter (from Chrome Setup and Configuration)

- --remote-debugging-port=9222: Enables the CDP HTTP JSON endpoint at http://localhost:9222/json and per-target WebSocket endpoints. DevTools MCP discovers tab targets from the JSON list and connects via WebSocket to send commands and receive responses.
- --user-data-dir=<path>: Ensures sessions run in an isolated profile (e.g., /tmp/remote-profile) so that automation doesn’t touch your default browser data and avoids conflicts with an already-running Chrome/Chromium session.
- JSON endpoint verification: Visiting http://localhost:9222/json confirms that the browser is running with remote debugging, that the port is open, and that there are discoverable targets. The key field used for connection is webSocketDebuggerUrl.

Reference: “Chrome Setup and Configuration” (devtools-mcp guide)

## Verification Details

- JSON endpoint:
  - URL: http://localhost:9222/json
  - Expected fields per target:
    - id: Unique target identifier.
    - type: Target type (page, service_worker, etc.). DevTools MCP expects type: "page".
    - title: Page title (informational/logging).
    - url: Page URL (informational/logging).
    - webSocketDebuggerUrl: The CDP WebSocket for this target (used to establish the connection).
- If no page targets are shown, open a new tab in Chromium. Some environments require at least one page/tab to be present before a page target appears.

## Security Considerations

- Bind to localhost: Include --remote-debugging-address=127.0.0.1 if you want to ensure the interface is not exposed on all interfaces (0.0.0.0).
- Never expose remote debugging to untrusted networks: CDP provides full control over the browser, including access to page contents, cookies, and the ability to execute arbitrary JavaScript.
- Use isolated profiles: Always set --user-data-dir to a dedicated temporary directory (e.g., /tmp/remote-profile) to prevent mixing with personal browsing data.

## Troubleshooting

- Port already in use:
  - Symptom: Chrome/Chromium fails to start or logs that 9222 is in use.
  - Fix: Close other instances using that port or change the port:
    ```bash
    chromium --remote-debugging-port=9223 --user-data-dir=/tmp/remote-profile-9223 &
    ```
    Then verify at http://localhost:9223/json.
- No page targets available:
  - Symptom: http://localhost:9222/json shows an empty list or only non-page targets.
  - Fix: Open a new tab in Chromium or navigate an existing tab to any webpage.
- Connection refused:
  - Symptom: curl http://localhost:9222/json fails.
  - Fix: Confirm Chromium is running with the remote debugging flag and that a firewall is not blocking localhost:9222.
- Symlink issues:
  - If Chromium updates or paths change, re-create the symlink.
  - If you later install Google Chrome at /opt/google/chrome/chrome, remove the symlink to avoid confusion:
    ```bash
    sudo rm /opt/google/chrome/chrome
    ```

## Cleanup

- Stop the background Chromium process (replace PID with the actual one):
  ```bash
  kill <PID>
  ```
  or close the browser.
- Remove the temporary user data directory if desired:
  ```bash
  rm -rf /tmp/remote-profile
  ```

## Command Cheat Sheet

- Launch Chromium for DevTools MCP:
  ```bash
  chromium --remote-debugging-port=9222 --remote-debugging-address=127.0.0.1 --no-first-run --no-default-browser-check --user-data-dir=/tmp/remote-profile &
  ```
- Verify JSON endpoint:
  ```bash
  curl http://localhost:9222/json
  ```
- Create symlink to satisfy hardcoded Chrome path:
  ```bash
  sudo mkdir -p /opt/google/chrome
  sudo ln -s /usr/bin/chromium /opt/google/chrome/chrome
  ```

## References

- Chrome Setup and Configuration (devtools-mcp guide): Discusses remote debugging port 9222, isolated user data directories, discovery via the JSON endpoint, and target selection. URL: https://deepwiki.com/stefanli/devtools-mcp/4.2-chrome-setup-and-configuration
