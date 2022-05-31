``mkconda`` is a scientific computing stack of useful Python and R
scientific computing conda packages for GPU servers with Intel
CPUS and NVIDIA GPUS, among them:

* mkpy - Kutas Lab data interchange utilities
* spudtr - some useful Pandas data transforms
* fitgrid - multichannel regression modeling
* MNE Python - EEG/MEG data analysis
* jupyterlab - Jupyter notebook desktop + Python and R kernels
* spyder - Python IDE
* tidyverse - data wrangling utilities in R
* pytorch - tensor library for deep learning
* numba - CPU and GPU Python acclerators
* Intel Math Kernel (MKL) library - math libraries optimized for Intel CPUs

**DROPPED PENDING FIX OF cudatoolkit-dev 11.4 MAMBA INSTALL**

* ~~cudatoolkit-dev~~
* ~~rapids - NVIDIA Python GPU accelerators~~


## Installation
 
### Users

In a bash terminal window, create a new named mkconda working
environment like so. The order of conda channels is important 
and if you copy the command make sure the backslash is the last 
character on the line, no trailing whitespace.

```
mamba create --name mkconda_072221 mkconda \
    --strict-channel-priority -c conda-forge -c defaults -c ejolly -c kutaslab
```
Then you can activate the environment as usual.

```
conda activate mkconda_072221
```

The mkconda environment comes with Python, R, and over 500 packages
including matplotlib, seaborn. To see which, install a
mkconda working environment and then run ```conda list```.

If you need additional packages, mamba (or conda) install them into the working
environment like so:

```
(mkconda_072221) $ conda list
(mkconda_072221) $ mamba install --strict-channel-priority -c conda-forge -c defaults package_a package_b ...

```

### Development mode

To run a mkconda member package in development mode, create a working
mkconda environment, navigate to where you want the package source
code to reside, and install the development branch from source into
the working environment in editable ("development") mode like so:

```
(base) $ mamba create --name mkconda_072221 --strict-channel-priority -c conda-forge -c defaults -c ejolly -c kutaslab
(base) $ conda activate mkconda_072221
(mkconda_072221) $ cd path/to/local_source_dirs
(mkconda_072221) $ git clone https://github.com/the_package --single-branch -b the_branch
(mkconda_072221) $ cd the_package
(mkconda_072221) $ git checkout the_branch
(mkconda_072221) $ pip install --no-deps -e .
(mkconda_072221) $
```
