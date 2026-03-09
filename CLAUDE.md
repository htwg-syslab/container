# Container Project

## Overview
This repo builds Docker images for university lab environments (Bsys/Esys courses).
Images are published to `systemlabor/bsys` on Docker Hub via GitHub Actions.

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
- **3Esys**: FROM `systemlabor/bsys:pocketlabbase` - adds qemu, cross-compile tools (arch-dependent)

## Legacy / Other
- `bsysobsolete/` - old base/ui images (not in active workflows)
- `pi-esys/` + `pi-esys-runner/` - Raspberry Pi Esys images

## GitHub Actions Workflows
- `0_minimal-python.yml` - builds 0Minimal
- `1_base.yml` - builds 1Base
- `2_ui.yml` - builds 2UI
- `3_esys.yml` - builds 3Esys

## Conventions
- User in Minimal: `pythonlab` / `pythonlab`
- User in Base/UI/Esys: `pocketlab` / `pocketlab`
- All images expose port 22 (SSH), UI also exposes 5901 (VNC) and 40001 (noVNC)
- `dos2unix` is used throughout for cross-platform line ending compatibility
