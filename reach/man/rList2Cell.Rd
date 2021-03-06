% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matlabExportList.R
\name{rList2Cell}
\alias{rList2Cell}
\title{Conversion of a R list, which was processed with the R function
"matlabExportList()" and then imported to Matlab to a Matlab cell-array}
\usage{
rList2Cell(importlist)
}
\arguments{
\item{importlist}{the imported struct equivalent of the R list, which was
reformated in R using matlabExportList.R and exported to Matlab using
writeMat() from the R.matlab package}
}
\value{
A Matlab cell-array containing in each cell the corresponding element
  of the original R list data (before it was reformated using
  matlabExportList.R()); also multi-arrays stored in the original R list
  datatype are recovered
}
\description{
This is a Matlab function. It transforms a R list datatype (which is imported
in Matlab as a struct) to a Matlab cell-array. Also recovers/ reformats
multi-arrays contained in this R list (which are only exported as vectors).
}
\author{
Christoph Schmidt <christoph.schmidt@med.uni-jena.de>
}
\seealso{
\code{\link{matlabExportList}}
}

