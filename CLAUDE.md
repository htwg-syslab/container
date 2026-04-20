# Container Project

## Overview
This repo builds Docker images for university lab environments (Bsys/Esys courses).
Images are built via GitHub Actions; 0Minimal and 1Base are pushed to `ghcr.io`, while 2UI and 3Esys are currently only built (no automated publish step). Docker Hub (`systemlabor/bsys`) is updated separately/manually from `ghcr.io`.

## Container Dependency Chain (BsysV2)

```
ubuntu:24.04
  └── 0Minimal (pythonlab) - Python-focused minimal image

ubuntu:22.04
  └── 1Base (pocketlabbase) - Base image with SSH, dev tools, OSTEP homework
        ├── 2UI (pocketlabui) - Desktop UI with VNC/noVNC, Firefox, VSCode
        └── 3Esys - Embedded systems tools (qemu, cross-compilers)
```

- **0Minimal**: Standalone, Ubuntu 24.04, user `pythonlab`, pyenv
- **1Base**: Ubuntu 22.04, user `pocketlab`, SSH + dev toolchain + OSTEP repo
- **2UI**: FROM `systemlabor/bsys:pocketlabbase` - adds Xfce desktop, TurboVNC, noVNC, Firefox, VSCode
- **3Esys**: FROM `systemlabor/bsys:pocketlabbase` - adds qemu, cross-compile tools (arch-dependent), act
  - Build args: `INSTALL_RUST=true` (optional Rust toolchain), `KEEP_OSTEP=true` (keep OSTEP homework from Base)

## Docker Hub Tags (`systemlabor/bsys`)
- `pocketlabbase`, `pocketlabbase-ARM64`
- `pocketlabui`, `pocketlabui-ARM64`
- `minimal-python`, `minimal-python-ARM64`

## Legacy / Other
- `pi-esys/` + `pi-esys-runner/` - Raspberry Pi Esys images

## GitHub Actions Workflows
- `0_minimal-python.yml` - builds 0Minimal
- `1_base.yml` - builds 1Base
- `2_ui.yml` - builds 2UI
- `3_esys.yml` - builds 3Esys

## Documentation
- `docs/` - User-facing documentation, TOC in `docs/SUMMARY.md`
- GitBook: `docs/` on `main` branch
- GitHub Pages (Just the Docs/Jekyll): `docs/` on `github-pages` branch, navigation via `docs/_config.yml`
- Docs reference Ubuntu (not Debian)

## Conventions
- User in Minimal: `pythonlab` / `pythonlab`
- User in Base/UI/Esys: `pocketlab` / `pocketlab`
- Container name: `--name=pocketlab`
- All images expose port 22 (SSH), UI also exposes 5901 (VNC) and 40001 (noVNC)
- Host port mapping: `-p 127.0.0.1:40405:22`
- `dos2unix` is used throughout for cross-platform line ending compatibility

## Branch-Rollen: `main` vs. `github-pages`

Dieses Repo trägt zwei Branches mit komplementären, aber scharf getrennten
Aufgaben. Der Unterschied ist nicht „stabil vs. experimentell", sondern
**Quelle der Wahrheit vs. Deployment-Linie**.

### `main` — Quelle der Wahrheit für Container-Code
- Alle Änderungen an Dockerfiles, `config/**` und `.github/workflows/**`
  landen ausschließlich hier (PR-basiert).
- Triggert **keinen** Push nach `ghcr.io/.../esyslab:latest` — der
  `esyslab.yml`-Workflow filtert `push`-Trigger auf `branches: [github-pages]`
  (siehe PR #93). Das verhindert, dass Zwischenstände das gemeinsame
  `:latest`-Manifest unter der Deployment-Linie wegdrücken.

### `github-pages` — Deployment-Linie + Pages-Serving
- GitHub Pages serviert `docs/**` von diesem Branch (Pages-Settings:
  `source: {branch: github-pages, path: /docs}`, `build_type: legacy`,
  Output: https://htwg-syslab.github.io/container/). Deshalb der Name.
- Zusätzlich veröffentlicht der `esyslab.yml`-Workflow von hier (und nur
  von hier) die Image-Tags `:latest_X64`, `:latest_ARM64` und das
  Multi-Arch-Manifest `:latest`.
- Dockerfile-Änderungen gehören **nicht** direkt auf diesen Branch.
  Stattdessen: main → github-pages mergen, dann pushen. Der Merge-Push
  triggert automatisch den Image-Build.
- Der Parent-Workspace (`esys-workspace`) pinnt sein Submodul auf
  genau diesen Branch, weil das Deployed-State Ihres Containers hier steht.

### Doc-Änderungen in `docs/**`
Direktes Commiten auf `github-pages` ist zulässig (Pages soll schnell
aktualisiert werden). Wenn dieselbe Doku auch woanders gepflegt wird
(GitBook-Space via `.gitbook.yaml` auf `main`), ist ein Rück-Merge nach
main sinnvoll, aber nicht zwingend für den Deploy-Pfad.

### Typischer Deploy-Flow nach einem Code-PR
```bash
# PR auf main gemerged (z.B. Dockerfile.esyslab-Update)
git checkout github-pages && git pull
git merge main              # bringt den neuen Dockerfile auf die Deploy-Linie
git push origin github-pages  # triggert esyslab.yml → neues :latest
```
