 [![Build Status](https://travis-ci.org/schmidtchristoph/reach.svg?branch=master)](https://travis-ci.org/schmidtchristoph/reach)

# reach:
## R < > Matlab interoperability
##### version 0.2.4

For building a combined R — Matlab software pipeline and workflow, being able to exchange data by reading and writing .mat files in R sessions is of great importance and for this the [R.matlab package](http://cran.r-project.org/web/packages/R.matlab/index.html) exists.

The reach package contains utility functions in R (and one in Matlab) that enhance compatibility between R and Matlab somewhat beyond reading and writing .mat files (and starting a Matlab server, see below). I wrote these functions for helping me with my own research projects, facilitating the reuse of existing Matlab code within R code.

There are currently functions for

- converting .mat files into .RData files 
- starting Matlab scripts and functions in R 
- exporting R lists with unnamed entries to Matlab and recovering multi-dimensional matrices contained in exported R lists in Matlab

R and Matlab cannot directly exchange data, but it is possible to start a Matlab server and let R communicate with Matlab (which is great) with the help of the [R.matlab package](http://cran.r-project.org/web/packages/R.matlab/index.html). However, I found this not always working reliably, especially when using different machines (like switching to a computer cluster) to run the R code. The R.matlab package manual states that „The R to MATLAB interface, that is the Matlab class, is less prioritized and should be considered a beta version.“. Therefore, I adopted the strategy to write Matlab scripts and run them from within R using functions of the reach package. I write these scripts to control the computations performed by Matlab, save the results as .mat files and quit the Matlab process. I then instruct R to read the .mat files after Matlab terminated, then to further process their data and to finally delete them. Thus, the data exchange between R and Matlab is indirect, but robust, using the file system.

- - -
### How to install this package from GitHub

There are several ways of installing the package, e.g.:

- install the "devtools" package first, then use devtools::install_github("schmidtchristoph/reach/reach")

- download the binary package (OS X), then run on the command line: R CMD INSTALL reach_0.2.4.tgz

- download the source package, then run on the command line: R CMD INSTALL reach_0.2.4.tar.gz

- install the "devtools" package first, clone the repository, then use devtools::install("path/to/repository/reach")

- - - 
The packages passes devtools::check( ) with zero problems, notes or warnings on my machine running OS X 10.10.5.

- - - 
The [MIT License (MIT)](http://opensource.org/licenses/MIT)
Copyright (c) 2015 Christoph Schmidt

- - -
My ORCID iD: http://orcid.org/0000-0002-5442-551X

<img src="orcid.png" align="left" />
