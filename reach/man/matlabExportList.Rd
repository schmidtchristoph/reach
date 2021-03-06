% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matlabExportList.R
\name{matlabExportList}
\alias{matlabExportList}
\title{Reformats an R list to be exported to Matlab as cell-array}
\usage{
matlabExportList(rlist)
}
\arguments{
\item{rlist}{List that is exported to Matlab as cell-array}
}
\value{
This function returns a reformated list that can be exported to
  Matlab with writeMat(). In Matlab it should be transformed to a cell-array
  using the Matlab function 'rList2Cell()', which is distributed with this
  package.
}
\description{
Exporting a R list with unnamed entries to Matlab using the
R.matlab::writeMat function yields a Matlab struct with no fields (an empty
struct). With the help of the matlabExportList function such a R list is
reformated so that the export results in a struct with fields (1,2,...),
accessible with the Matlab getfield() function. In Matlab, the loaded struct
can then be further processed with the Matlab function 'rList2Cell()', which
is distributed with this package, to yield a Matlab cell-array. For export,
the package 'R.matlab' has to be used. Note that in particular for storing a
multidimensional matrix one can also use R arrays instead of lists
(a<-array(dim=c(3,3,2); a[,,1]<-matrix(99,3,3); ...) which will be exported
just fine to Matlab and don't need any further processing.
}
\details{
A list containing lists is not supported by the writeMat() function
  and provokes an error. Consequently, this is checked for in
  matlabExportList and triggers an error.
}
\examples{
\dontrun{

rlist <- list(matrix(sample(100,16),4,4), c(1,2,3,4), "somestring")
print(rlist)
matlablist <- matlabExportList(rlist)
print(matlablist)
R.matlab::writeMat("test.mat", myexportdata=matlablist)
# in Matlab or using runMatlabCommand() (and having "rList2Cell.m" on the Matlab path):
runMatlabCommand("load test.mat; myexportdata, rc=rList2Cell(myexportdata); celldisp(rc); quit")
system("rm test.mat")
}

}
\author{
Christoph Schmidt <christoph.schmidt@med.uni-jena.de>
}
\seealso{
\code{\link{rList2Cell}}
}

