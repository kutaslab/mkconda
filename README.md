mkconda is a conda metapackage containing a set of linux-64 scientific
computing packages for Kutas Lab research

* mkpy
* fitgrid
* jupyter, with an R kernel
* rstudio

Install it into a bare conda environment and activate it like so, with a sensible
value for `some_env`

```
conda create --name some_env mkconda -c kutaslab -c defaults -c r -c conda-forge
```

This gets a consistent conda environment going. Other packages may
be installed provided the requirements can be satisfied.
