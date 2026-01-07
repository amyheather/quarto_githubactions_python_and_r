# Quarto via GitHub actions (w/ Python and R code) - version 1

This repository demonstrates how to render and deploy a quarto site on GitHub pages via GitHub actions, when it contains executable Python and R code.

1. Make `environment.yaml`.

2. Build conda environment.

```
conda env create --file environment.yaml
conda activate quarto_python_r
```

3. Open RStudio and create `.Rproj`.

4. Create `DESCRIPTION`.

5. Set-up R environment with `renv` (if working from terminal, use `R` to open R console and `q()` to close it). Use `all` snapshot.

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

## ⚠️ Warning

I encountered an issue with the approach in this repository.

Conda's matplotlib was not compatible with the base rocker image. The matplotlib in conda was built against a newer libstdc++ ABI than rocker/r-ver:4.4.1 so when reticulate imports it we get a CXXABI_1.3.15 mismatch.

I tried to force Python to use conda's libstdc++ at runtime, but that didn't work. In the end, I resolve this by downgrading matplotlib to a version that doesn't require CXXABI_1.3.15.

**Next steps:** I have created a [second version of this repository](https://github.com/amyheather/quarto_githubactions_python_and_r_v2) where I build the site on a different base image, to see if this resolves the problem.

## Common `reticulate` error and solution

When rendering a Quarto document containing executable python code with `reticulate`, you might encounter:

```
Error in `use_condaenv()`:
! Unable to locate conda environment 'des-rap-book'.
Backtrace:
    ▆
 1. └─reticulate::use_condaenv("des-rap-book", required = TRUE)
```

This can occur when multiple Conda or Mamba installations exist (e.g. `mambgaforge`, `miniconda3`), or if R is using a different search path than the shell. By default, `reticulate` only looks in one location for environments, which can cause problems when environments are not where `reticulate` expects.

To fix this, **set the `RETICULATE_CONDA` environment variable** to the correct Conda or Mamba executable. To find the path to your executable, run:

```
conda env list
```

Look for your environment in the list. For example, if your environment is at `/home/amy/mambaforge/envs/des-rap-book`, then your Conda executable is likely at `/home/amy/mambaforge/bin/conda`.

Set the environment variable like so:

```
export RETICULATE_CONDA=/home/amy/mambaforge/bin/conda
```

Now render your book:

```
quarto render
```

To avoid needing to set `RETICULATE_CONDA` every time you open a new terminal, add the export command to an `.Renviron` file in your project directory. This file is not tracked by Git, and is specific to you. Create the file and add:

```
RETICULATE_CONDA=/home/amy/mambaforge/bin/conda
```
