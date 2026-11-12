# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Initial commit: Pelican Panel + Wings + MariaDB + Redis compose stack for a
  contained Enshrouded dedicated server.
- Enshrouded egg (`eggs/enshrouded.json`) for the mornedhels image.
- Mod installation guide and EML seed script (`mods/`).
- Wings daemon configuration template (`wings/config.yml.example`).

### Changed
- Renamed `docker-compose.yml` to `enshrouded-server.compose.yaml`.
- Grouped management ports: panel 36747, Wings 36748, Wings SFTP 36479.
- Database name/username updated to `pelicanpaneldb` / `pelicanpanel`.
- Enshrouded egg defaults corrected to standard ports (game 15636, query 15637).

### Fixed
- Panel image and Wings image references corrected to `ghcr.io/pelican/...`.
- Panel log volume mount removed to avoid permission errors on startup.