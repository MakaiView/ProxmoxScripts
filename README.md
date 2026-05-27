# ProxmoxScripts

Proxmox LXC installer scripts for Makai View Media self-hosted apps.

Forked from [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE) (MIT) and adapted to point to this repository. The `build.func` / `install.func` / `core.func` infrastructure is otherwise structurally identical — the same whiptail wizard, the same container-creation flow, and the same `setup_nodejs` / other helpers from `tools.func`.

## Usage

Run the one-liner for a specific app from a **Proxmox host shell**:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/MakaiView/ProxmoxScripts/main/ct/laser-tracker.sh)"
```

Re-running the same command from inside the created container calls `update_script()` to pull the latest code without recreating the container.

## Apps

| App | CT Script | Source Repo |
|---|---|---|
| Laser Settings Tracker | `ct/laser-tracker.sh` | [MakaiView/LaserSettingsManager](https://github.com/MakaiView/LaserSettingsManager) |

## Adding a New App

1. Create `ct/appname.sh` — set `APP`, `var_*` defaults, implement `update_script()`, call `start` / `build_container` / `description`.
2. Create `install/appname-install.sh` — source `$FUNCTIONS_FILE_PATH`, install deps, clone repo, configure service.
3. The install script filename must match the NSAPP derivation: `APP` lowercased with spaces replaced by hyphens + `-install.sh`.

## License

MIT — see [LICENSE](LICENSE).  
Based on [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE), © community-scripts ORG.  
Modifications © 2024-2026 Makai View Media.
