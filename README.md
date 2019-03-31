# Requires

[![Travis build status](https://travis-ci.org/davidmasp/Requires.svg?branch=master)](https://travis-ci.org/davidmasp/Requires)

## Installation

```
# install.packages("devtools")
devtools::install_github(repo = "davidmasp/Requires")
```


## Usage

In order to extract dependencies from a script

```
Requires::make_require(file = "R/funs.R")
```

This will generate a set of files containing the dependencies of the packages.

