# Mod installation guide

This directory holds the server-side mods and a seed script. Client-side mods are
installed by each player on their own machine (see the list in the project README).

## Server-side mods (install into gamefiles/)

Place these under `gamefiles/` (mounted at `/opt/enshrouded` in the container):

```
gamefiles/
  dbghelp.dll                          <- EML loader (rename to eml-dbghelp.dll if using ShroudForge route)
  mods/
    server_guardian/...                <- #226 Server Guardian
    livemap/...                        <- #209 Live Map
    transmog-station/...               <- #304 Transmogrification Station (ShroudForge route)
  greeneye/
    town-portal/...                    <- #255 Town Portals
    embervale-teleport/...             <- #219 Embervale Teleport
    hollow-halls-progression/...       <- #272 Hollow Halls Progression
  dbgcore.dll                          <- Greeneye loader
  shroudforge/...                      <- ShroudForge loader (for Transmogrification Station)
```

## Loader notes

- **EML** (Enshrouded Mod Loader) provides `dbghelp.dll` + `mods/`.
- **Greeneye** provides `dbgcore.dll` + `greeneye/`.
- **ShroudForge** provides its own `dbghelp.dll`-based loader (used by Transmogrification Station).
- EML and ShroudForge both ship a `dbghelp.dll`. If both are needed on the server,
  rename EML's file to `eml-dbghelp.dll` so ShroudForge's loads first and chain-loads EML.
  Transmogrification Station documents compatibility with Greeneye mods.

## WINEDLLOVERRIDES

Set in the egg variables (and in docker-compose for direct runs):
`dbghelp=native,builtin;winmm=native,builtin`

## Seed script (seed-eml.sh)

SteamCMD `validate` overwrites `dbghelp.dll` after a game update. Re-run
`mods/seed-eml.sh` (or let the container entrypoint handle it) to restore the EML
loader DLL from the backup copy kept in `mods/eml-backup/`.

```
mkdir -p mods/eml-backup
# place your dbghelp.dll (EML) copy here once, then:
cp mods/eml-backup/dbghelp.dll gamefiles/dbghelp.dll
```
