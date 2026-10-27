# Install and Run on Windows 11 with uv

These instructions run Jupyter Lab directly on Windows using a Python
interpreter managed by uv. They do not use Podman or install this repository
as a Python package. The project requires Python 3.12 and its dependencies are
locked in `uv.lock`.

## 1. Install Git and uv

Open PowerShell and install Git and uv with WinGet:

```powershell
winget install --exact --id Git.Git
winget install --exact --id astral-sh.uv
```

Open a new PowerShell window, then verify both commands are available:

```powershell
git --version
uv --version
```

See the official [uv installation guide](https://docs.astral.sh/uv/getting-started/installation/)
for other installation options.

## 2. Install Python 3.12 with uv

Use uv to install and locate the Python version required by this project:

```powershell
uv python install 3.12
uv python find 3.12
```

## 3. Clone the project branch

Clone the `jjee-adaptations` branch and change to the repository directory:

```powershell
New-Item -ItemType Directory -Force "$HOME\work" | Out-Null
Set-Location "$HOME\work"
git clone --depth 1 --branch jjee-adaptations https://github.com/humlab/jjee_notebooks.git
Set-Location .\jjee_notebooks
```

If you already have this branch checked out, use that repository directory
instead of cloning it again.

## 4. Copy the data folder

Copy your `data` folder into the repository root, alongside `pyproject.toml`.
The data stays on your computer and is not installed as a package. The project
ignores `data` in Git, so its contents will not be committed.

The expected layout is:

```text
jjee_notebooks\
  data\
  pyproject.toml
  uv.lock
```

## 5. Create the local environment and install dependencies

From the repository root, run:

```powershell
uv sync --locked --no-dev --no-install-project
```

This creates a `.venv` in the repository, installs the locked runtime
dependencies, and does not install the repository itself as a Python package.
The first sync needs an internet connection and may take a while.

Check the environment:

```powershell
uv run --no-sync python --version
uv run --no-sync jupyter lab --version
```

The Python version should be 3.12.x.

## 6. Start Jupyter Lab

From the repository root, run:

```powershell
$env:PYTHONPATH = (Get-Location).Path
uv run --no-sync jupyter lab . --ip=127.0.0.1 --port=8888
```

Setting `PYTHONPATH` to the repository root lets notebook kernels import
repository modules such as `notebooks`, even when a notebook is in a nested
folder.

Jupyter Lab should open in your browser. If it does not, go to
**http://localhost:8888** and use the access token printed in PowerShell.
Jupyter is bound to the local computer only.

Press **Ctrl+C** in PowerShell to stop Jupyter Lab.

## Updating the checkout and environment

To update the checkout and synchronize dependencies with its lock file:

```powershell
git pull --ff-only
uv sync --locked --no-dev --no-install-project
```

## Troubleshooting

- **`uv` or `git` is not recognized:** Close and reopen PowerShell after
  installing, then try the version checks again.
- **The data folder is not visible:** Confirm it is named `data` and is in the
  repository root, then restart Jupyter Lab from that root.
- **Port 8888 is already in use:** Change `--port=8888` to `--port=8889` and
  open **http://localhost:8889**.
- **`uv sync --locked` reports that the lock file is out of date:** Confirm
  you are on the `jjee-adaptations` branch and that `pyproject.toml` and
  `uv.lock` are from the same checkout.
