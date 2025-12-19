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