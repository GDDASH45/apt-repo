# GDDASH45 APT Repository

An APT package repository hosted using GitHub Pages.

## Repository layout

- `conf/distributions` - APT distribution configuration.
- `packages/` - Debian packages to publish.
- `scripts/build-repo.sh` - Builds the repository using reprepro.
- `.github/workflows/pages.yml` - GitHub Pages publishing workflow.

## Repository information

| Setting | Value |
|---|---|
| Distribution | stable |
| Component | main |
| Architecture | amd64 |
| Hosting | GitHub Pages |
| Package format | .deb |

## Adding packages

Place `.deb` packages in `packages/` and push them to `main`.

GitHub Actions will build and publish the APT repository.

## APT source

After publishing and distributing the repository's public signing key:

```text
deb [signed-by=/etc/apt/keyrings/gddash45-archive-keyring.gpg] https://gddash45.github.io/apt-repo stable main