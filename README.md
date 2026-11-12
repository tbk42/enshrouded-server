# Enshrouded Server + Pelican Panel (contained management UI)

Self-hosted Enshrouded dedicated server on a local machine, managed through a
contained web UI (Pelican Panel + Wings) — no host-level management agents.

## Stack

| Service | Purpose |
|---|---|
| `panel` | Pelican web UI (port `${PANEL_PORT:-8080}`) |
| `database` | MariaDB for the panel |
| `redis` | Cache + queue backend |
| `wings` | Daemon that manages game-server containers (port `${WINGS_PORT:-8081}`, SFTP `${WINGS_SFTP_PORT:-2022}`) |
| `enshrouded` | Enshrouded server (profile `manual` — created/managed by Wings via the egg) |

## Quick start

```bash
cp .env.example .env
# edit .env (passwords, ports)
docker compose up -d
```

Open the panel at http://localhost:8080 and create your admin account on first run.

## Wire up Wings

1. In the panel: **Admin -> Nodes -> Create Node**.
2. Copy the node UUID + token into `wings/config.yml` (from `wings/config.yml.example`).
3. Set `panel.url` to `http://panel` (or your panel URL).
4. Restart Wings: `docker compose restart wings`.

## Add the Enshrouded server

1. Import the egg: **Admin -> Nests -> Import Egg** -> upload `eggs/enshrouded.json`.
2. Create a server from that egg on your node, allocating ports 15636/15637 (TCP+UDP).
3. Wings creates the container from `mornedhels/enshrouded-server:latest` with the egg's env vars.

## Mods

See `mods/README.md`. Summary of the final mod set:

**Server (container):** EML, Server Guardian (#226), Live Map (#209),
Transmogrification Station (#304, ShroudForge), Town Portals (#255),
Embervale Teleport (#219), Hollow Halls Progression (#272).

**Each client:** Mod Menu (#152), Quick Deposit (#195), Find (#200),
Embervale Teleport (#219), Town Portals (#255), Hollow Halls Progression (#272),
Map HD (#324), Minimap Buff Timers & F8 Panel (#299),
Transmogrification Station (#304, client package).

**Loader strategy (conflict-free):**
- Server process runs EML + ShroudForge + Greeneye.
- Client process runs Greeneye + ShroudForge only (no EML) -> no `dbghelp.dll`
  collision and no EML+Greeneye crash risk.
- `WINEDLLOVERRIDES=dbghelp=native,builtin;winmm=native,builtin` on both.

**Dropped:** Quiver & Spellbook (single-player only), Weapon Transmutation
(redundant with Transmogrification Station), Wardrobe (redundant),
Smart Quick Stack (beta, redundant with Quick Deposit), ESM-Z (redundant
with Pelican), Minimap & Weather Clock #143 (subset of #299).

## Mod loader seeding

SteamCMD `validate` overwrites `dbghelp.dll` after a game update. Keep a backup
copy at `mods/eml-backup/dbghelp.dll` and re-run `mods/seed-eml.sh` (or let the
container entrypoint handle it) to restore the EML loader.

## Notes

- Enshrouded runs via Proton/Wine under Linux: ~4-6 GB RAM and ~10 GB disk for
  the install. Persistent volume at `./gamefiles` (`/opt/enshrouded`).
- ntsync device passthrough (`/dev/ntsync`) requires Linux kernel 6.14+.
- Ports: game 15637 (TCP+UDP), query 15636 (TCP+UDP).
- Stop grace period 120s (world saves).
- Live Map (#209) serves its own web map on a separate port - allocate it in
  the egg/panel when enabling that mod.