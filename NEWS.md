## reach 0.3.1
- fixed: temporary files were not removed by 'runMatlabFct()' under certain circumstances
- 'runMatlabScript()' now complains if the input Matlab script does not exist in the current working directory, therefore one does not have to wait for Matlab to throw the error
- the 'rList2Cell()' Matlab function is now also bundled with the R package in inst/matlab/


## reach 0.3.0
- reach can now seamlessly call Matlab functions and return their results directly using ```runMatlabFct()```
- to give an example:
    
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