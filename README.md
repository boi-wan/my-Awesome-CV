# my-Awesome-CV

A personal CV built on top of [posquit0/Awesome-CV](https://github.com/posquit0/Awesome-CV), compiled with XeLaTeX inside a Docker container.

## Prerequisites

- **Docker** – the Makefile auto-detects it; if Docker is not found, it falls back to a local `xelatex`.
- **Git** – submodules are pulled automatically on every build.
- **[Adobe Source Sans 3](https://github.com/adobe-fonts/source-sans)** – bundled under `adobe-fonts/source-sans/`; the TTF files are installed into the Docker container at build time.

## Usage

| Command                 | Description                                                                                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `make` or `make cv.pdf` | Compiles `my-cv.tex` via `texlive/texlive:latest` (if Docker is available). Source Sans 3 and Roboto fonts are installed inside the container automatically. |
| `make clean`            | Removes build artifacts (`.pdf`, `.aux`, `.log`, `.out`, `.fls`, `.fdb_latexmk`) inside the container.                                                       |
| `make docker-shell`     | Drops you into an interactive shell in the container at `/workdir` with your repo mounted — handy for debugging fonts or TeX paths.                          |
| `make docker-build`     | Pulls the latest `texlive/texlive` Docker image.                                                                                                             |
