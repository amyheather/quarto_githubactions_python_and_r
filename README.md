# Quarto via GitHub actions (w/ Python and R code)

This repository demonstrates how to render and deploy a quarto site on GitHub pages via GitHub actions, when it contains executable Python and R code.

1. Make `environment.yaml`.

2. Build conda environment.

```
conda env create --file environment.yaml
conda activate quarto_python_r
```

3. Open RStudio and create `.Rproj`.

4. Create `DESCRIPTION`.

5. Set-up R environment with `renv` (if working from terminal, use `R` to open R console and `q()` to close it). Use `implicit` snapshot.

```
renv::init()
renv::install()
renv::snapshot()
```

6. Created a simple quarto site and tested local render - all fine.

With the environments and getting site working, there was a bunch of troubleshooting, as was having issues installing incompatible packages and stuff in packages not working etc. Also, set python interpreter in VSCode. Moving on...

7. Published on GitHub pages.

```
quarto publish gh-pages
```

8. Created `Dockerfile` and `.github/workflows/quarto.yaml`. Uses two step process: (a) create docker image and host on GHCR, and (b) render within docker. Why? To avoid the long process of setting up the environments everytime render - can move quicker if docker already has everything needed!