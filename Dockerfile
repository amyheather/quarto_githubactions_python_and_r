# Start from a base R image
FROM rocker/r-ver:4.4.1

# Install system dependencies for R and Python packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libharfbuzz-dev \
        libfribidi-dev \
        libfontconfig1-dev \
        wget \
        curl \
        git \
        libpng-dev \
        libxml2-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        python3-pip \
        python3-venv \
        build-essential \
        pandoc \
        # Required for chrome
        fonts-liberation \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libatspi2.0-0 \
        libcups2 \
        libdbus-1-3 \
        libgbm1 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libvulkan1 \
        libxcomposite1 \
        libxdamage1 \
        libxkbcommon0 \
        libxrandr2 \
        xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Quarto CLI
RUN wget -qO- https://quarto.org/download/latest/quarto-linux-amd64.deb > /tmp/quarto.deb && \
    dpkg -i /tmp/quarto.deb && \
    rm /tmp/quarto.deb

# Install Miniconda (for Python/Conda envs)
ENV CONDA_DIR=/opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh
ENV PATH=$CONDA_DIR/bin:$PATH

# Copy environment files and source code
WORKDIR /workspace
COPY . /workspace

# Accept Anaconda ToS for required channels in non-interactive builds
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# Create the conda environment
RUN conda env create -f environment.yaml

# Activate the conda environment and set as the Python path
RUN echo "conda activate quarto_python_r" >> ~/.bashrc
ENV PATH=/opt/conda/envs/quarto_python_r/bin:$PATH

# Force conda's C++ runtime to be used first
ENV LD_LIBRARY_PATH=/opt/conda/envs/quarto_python_r/lib:/usr/lib/x86_64-linux-gnu

# Set path to renv
ENV RENV_PATHS_LIBRARY=/workspace/renv/library

# Install renv and restore R packages
RUN Rscript -e "install.packages('renv', repos='https://cloud.r-project.org')" \
    && Rscript -e "renv::restore()"

# Set conda environment as default for reticulate
ENV RETICULATE_PYTHON=/opt/conda/envs/quarto_python_r/bin/python
