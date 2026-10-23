# hx-update

A small Bash tool to install and update the latest stable [Helix](https://helix-editor.com) release from GitHub into your home directory, without root. Useful on distributions (like Debian stable) whose repositories ship an older Helix.

## Features

- Install the latest stable release into `~/.local/opt/helix-<version>`
- Verifies the SHA-256 digest published by GitHub (when available), the archive, and that the binary reports the expected version
- Atomic switching via symlinks: an interrupted update never leaves a broken install
- `--rollback` swaps between the current and previous version
- Keeps the last 3 versions and removes older ones
- Supports `x86_64` and `aarch64` Linux
- Safe against concurrent runs (`flock`)

## Requirements

`bash`, `curl`, `jq`, `tar`, `xz`, `flock`, `sha256sum`.

On Debian/Ubuntu:

```bash
sudo apt install curl jq xz-utils util-linux
```

## Install

```bash
git clone https://github.com/Layomx/helix-update.git
cd hx-update
./install.sh
```

Or just download the script:

```bash
mkdir -p ~/.local/bin
curl -fsSL -o ~/.local/bin/hx-update \
  https://raw.githubusercontent.com/Layomx/hx-update/main/hx-update
chmod +x ~/.local/bin/hx-update
```

Make sure `~/.local/bin` is in your `PATH`, and **before** `/usr/bin` if you have Helix installed from your distro.

## Usage

```text
hx-update              Install the latest stable release if it is newer
hx-update --check      Report whether an update is available (exit 10 if so)
hx-update --force      Reinstall the latest release
hx-update --rollback   Swap back to the previous version
hx-update --list       List installed versions
hx-update --version    Print the hx-update version
```

After the first run, `hx` is a symlink in `~/.local/bin` pointing to the active version.

### Environment variables

| Variable         | Default         | Purpose                            |
|------------------|-----------------|------------------------------------|
| `GITHUB_TOKEN`   | unset           | Raises the GitHub API rate limit   |
| `HX_UPDATE_BASE` | `~/.local/opt`  | Where versions are installed       |
| `HX_UPDATE_BIN`  | `~/.local/bin`  | Where the symlink is created       |
| `HX_UPDATE_NAME` | `hx`            | Name of the symlink                |
| `HX_UPDATE_KEEP` | `3`             | Number of versions to keep         |

## Layout

```text
~/.local/opt/
├── helix-25.07.1/        # one directory per version (binary + runtime)
├── helix-24.07/
├── helix-current  ->  helix-25.07.1
└── helix-previous ->  helix-24.07
~/.local/bin/hx    ->  ~/.local/opt/helix-current/hx
```

## Uninstall

```bash
./install.sh --uninstall      # removes hx-update only
rm -f ~/.local/bin/hx         # the symlink
rm -rf ~/.local/opt/helix-*   # installed versions
```

## License

MIT
