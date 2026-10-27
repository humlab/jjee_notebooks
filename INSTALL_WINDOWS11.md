# Install and Run on Windows 11

These instructions use the public GHCR image
`ghcr.io/roger-mahler/westac-jupyter:jjee-adaptations`. You do not need to
install Podman Desktop, clone the repository, build the image, or log in to
GHCR. You do need the Podman CLI, a Podman machine, and a local `data` folder.

## 1. Install WSL 2

Podman runs Linux containers in a Linux virtual machine. If WSL 2 is not
already installed, open **PowerShell as Administrator** and run:

```powershell
wsl --install --no-distribution
```

Restart Windows if prompted. Open PowerShell and check WSL:

```powershell
wsl --update
wsl --status
```

If WSL reports that virtualization is unavailable, enable hardware
virtualization in your PC's BIOS/UEFI. See Microsoft's
[WSL installation guide](https://learn.microsoft.com/windows/wsl/install)
for details.

## 2. Install the Podman CLI

In PowerShell, install the standalone Podman CLI with WinGet:

```powershell
winget install --exact --id RedHat.Podman
```

Open a new PowerShell window and check that the CLI is available:

```powershell
podman --version
podman machine list
```

If no Podman machine is listed, create one:

```powershell
podman machine init
```

Start the machine if it is stopped, then verify Podman:

```powershell
podman machine start
podman info
```

Podman Desktop is optional. Refer to the
[Podman Windows installation guide](https://podman.io/docs/installation#windows)
for prerequisites and alternatives.

## 3. Pull the public image

Pull the image from GHCR. No GHCR login or token is needed because the package
is public:

```powershell
podman pull ghcr.io/roger-mahler/westac-jupyter:jjee-adaptations
```

## 4. Copy and mount your data

Copy your `data` folder to the Windows computer. In PowerShell, change to the
directory that contains `data`. For example, if it is
`C:\Users\<your-name>\data`, run:

```powershell
Set-Location "$HOME"
$dataPath = (Resolve-Path .\data).Path
```

If the folder is elsewhere, use `Set-Location` to go to its parent directory
before resolving the path. Then start Jupyter:

```powershell
podman run --rm -it `
  --publish 127.0.0.1:8888:8888 `
  --mount "type=bind,source=$dataPath,target=/workspace/data" `
  --env PYTHONPATH=/workspace `
  ghcr.io/roger-mahler/westac-jupyter:jjee-adaptations `
  jupyter lab . --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

The image starts as root, so `--allow-root` is needed to let Jupyter start.
The `PYTHONPATH` setting makes repository-root modules such as `notebooks`
available to notebook kernels.

### Command Prompt (CMD)

If you use CMD instead of PowerShell, first change to the directory containing
your `data` folder and set its path. This example assumes it is under your
Windows profile:

```cmd
cd /d "%USERPROFILE%"
set "DATA_PATH=%CD%\data"
```

Then run:

```cmd
podman run --rm -it ^
  --publish 127.0.0.1:8888:8888 ^
  --mount "type=bind,source=%DATA_PATH%,target=/workspace/data" ^
  --env PYTHONPATH=/workspace ^
  ghcr.io/roger-mahler/westac-jupyter:jjee-adaptations ^
  jupyter lab . --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

If `data` is elsewhere, set `DATA_PATH` to its actual path before running the
command, for example `set "DATA_PATH=D:\datasets\data"`.

The host `data` folder is mounted read/write at `/workspace/data` in the
container; it is not copied into the image.

## 5. Open Jupyter Lab

Open **http://localhost:8888** in your browser. Use the access token printed
in the PowerShell window. Leave that window open while using Jupyter Lab.

To check the mount, confirm your host files appear in the `data` folder in
Jupyter Lab. You can also create a small test file there and verify that it
appears in the host `data` folder.

Press **Ctrl+C** in PowerShell to stop Jupyter. The `--rm` option removes the
stopped container; it does not remove the image or your host data.

## Troubleshooting

- **Podman cannot connect:** Check `podman machine list`; start the machine if
  it is stopped. If WSL is not running correctly, try `wsl --update` and
  restart Windows.
- **The `data` path cannot be resolved:** Make sure the folder exists and
  change PowerShell to its parent directory before running
  `(Resolve-Path .\data).Path`.
- **Port 8888 is already in use:** Change the host port in `--publish` to
  `127.0.0.1:8889:8888`, then open `http://localhost:8889`.
- **`ModuleNotFoundError: No module named 'notebooks'`:** Confirm the run
  command includes `--env PYTHONPATH=/workspace`, then restart the container
  and notebook kernel.
- **A public-image pull reports unauthorized:** Clear any saved registry
  credentials with `podman logout ghcr.io`, then retry the `podman pull`.
