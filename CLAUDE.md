# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo defines a multi-arch Docker builder image (`ghcr.io/bazo/builder-image`) used as a CI base image for other projects. It bundles Node.js, npm, Bun, Go, and go-rice into a single Alpine-based image.

## Build & Test

```bash
# Build locally (single platform)
docker build -t builder-image .

# Build for multi-arch (matching CI)
docker buildx build --platform linux/amd64,linux/arm64 -t builder-image .
```

There are no tests or linting — validation is the final `RUN` step in the Dockerfile that prints installed tool versions.

## Architecture

- **Dockerfile** — the entire image definition. Alpine base, installs Node.js/npm via apk, Bun via install script, Go via latest stable tarball, and go-rice via `go install`. Multi-arch support via `TARGETARCH`/`TARGETOS` build args.
- **.github/workflows/docker-build-push.yml** — CI pipeline. Builds multi-arch (amd64 + arm64), pushes to GHCR on main branch pushes and tags, sends Pushover notification on completion. PRs build but don't push.

## CI Notes

- Image is pushed to `ghcr.io/bazo/builder-image` with tags: branch name, semver, sha-prefixed, and `latest` for main.
- Build cache uses GitHub Actions cache (`type=gha`).
- Artifact attestation step exists but is commented out.
