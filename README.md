 [![Build Status](https://travis-ci.org/schmidtchristoph/reach.svg?branch=master)](https://travis-ci.org/schmidtchristoph/reach)

# reach:
## R < > Matlab interoperability
##### version 0.4.2

The reach package contains functions that make it easy to reuse existing Matlab code within R code and to build a robust integrated R — Matlab software pipeline and workflow, enhancing the compatibility between R and Matlab. It enables to run Matlab functions and scripts from within R using .mat files as a means to robustly exchange data between R and a separate Matlab process. The 'reach' functions just work, with no complicated setup required. However, the robust data transfer via the file system comes at the price of an overhead to start and terminate the Matlab process for every function call or Matlab script execution. Primarily, the reach package is meant to be used to batch process a lot of data in each executed Matlab script or to run Matlab functions that have high time complexity. For such computations a few Matlab restarts as well as reading/ writing data to and from the disk (SSD) are neglectable. With 'reach' one can start a chain of R/ Matlab scripts, which can execute and control computations that might take weeks in a row without any further manual intervention from the side of the user.

There are currently functions for

- executing Matlab functions seamlessly as if they were R functions and returning their results directly into the R session (OS X, Linux)
- converting .mat files into .RData files as well as batch converting all .mat files contained within a folder (OS X, Linux, Windows)
- starting Matlab scripts, which can save the results for importing them back into R (OS X, Linux)
- starting Matlab functions and printing their results on the terminal (OS X, Linux)
- exporting R lists with unnamed entries to Matlab and recovering multi-dimensional matrices in Matlab contained in exported R lists (OS X, Linux, Windows)

To give an example of seamlessly executing a Matlab function and returning the results directly back into the R session using ```runMatlabFct()```:
```
a       <- c(1,2,1,4,1,5,4,3,2,2,1,6,3,1,3,5,5)
b       <- c(4,6,9)
results <- runMatlabFct( "[bool, pos] = ismember(b,a)" )
```

returns the following results

```
> results
$bool
    [,1]
[1,]    1
[2,]    1
[3,]    0

$pos
    [,1]
[1,]    4
[2,]   12
[3,]    0
```

Plots using Matlab are possible, too:

```
p <- runMatlabFct( "[X,Y,Z] = peaks(25)" )
X <- p$X
Y <- p$Y
Z <- p$Z
runMatlabFct( "surf(X,Y,Z)" )
```

![3-D shaded surface plot](surf.png "3-D shaded surface plot")


For further details and documentation of all package functions please refer to the reference manual "reach.pdf".

---

##### Note:

R and Matlab cannot directly exchange data, making reading and writing .mat files within R sessions necessary, for which 'reach' relies on the R.matlab package (on [CRAN](http://cran.r-project.org/web/packages/R.matlab/index.html) and also on [Github](https://github.com/HenrikBengtsson/R.matlab/)). Using R.matlab it is also possible to start a Matlab server to let R communicate with Matlab. However, I found this not always working reliably, especially when using different machines (like switching to a computer cluster) to run the R code. The R.matlab package manual states that „The R to MATLAB interface, that is the Matlab class, is less prioritized and should be considered a beta version.“. Therefore, I adopted the strategy to write Matlab scripts and run them from within R using functions of the reach package. I write these Matlab scripts to save results as .mat files and to quit the Matlab process. I then instruct R to read the .mat files after Matlab terminated, then to further process their data and to finally delete them. Thus, the data exchange between R and Matlab is indirect, but robust, using the file system.

- - -

### How to install this package from GitHub

There are several ways of installing the package, e.g.:

- install the "devtools" package first, then use devtools::install_github("schmidtchristoph/reach/reach")

- download the source package, then run on the command line: R CMD INSTALL /path/to/reach_0.4.2.tar.gz

- install the "devtools" package first, clone the repository, then use devtools::install("path/to/repository/reach")

- - - 

The package passes devtools::check( ) with zero problems, notes or warnings on my machine running R 3.2.3 on OS X 10.10.5.

The 'dev' branch can be considered stable, even though it contains incomplete new features. Generally, only changes with devtools::check( ) Status: OK are pushed.

- - - 
The [MIT License (MIT)](http://opensource.org/licenses/MIT)
Copyright (c) 2015 Christoph Schmidt
