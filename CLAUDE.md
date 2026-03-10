# Container Project

## Overview
This repo builds Docker images for university lab environments (Bsys/Esys courses).
Images are built via GitHub Actions, pushed to `ghcr.io`, then copied to `systemlabor/bsys` on Docker Hub.

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
- `bsysobsolete/` - old base/ui images (not in active workflows)
- `pi-esys/` + `pi-esys-runner/` - Raspberry Pi Esys images

## GitHub Actions Workflows
- `0_minimal-python.yml` - builds 0Minimal
- `1_base.yml` - builds 1Base
- `2_ui.yml` - builds 2UI
- `3_esys.yml` - builds 3Esys

## Documentation
- `docs/` - User-facing documentation (GitBook), TOC in `docs/SUMMARY.md`
- Docs reference Ubuntu (not Debian)

## Conventions
- User in Minimal: `pythonlab` / `pythonlab`
- User in Base/UI/Esys: `pocketlab` / `pocketlab`
- Container name: `--name=pocketlab`
- All images expose port 22 (SSH), UI also exposes 5901 (VNC) and 40001 (noVNC)
- Host port mapping: `-p 127.0.0.1:40405:22`
- `dos2unix` is used throughout for cross-platform line ending compatibility
