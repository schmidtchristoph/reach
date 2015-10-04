# reach in 0.3.0
- reach can now seamlessly call Matlab functions and return their results directly using ```runMatlabFct()```
- to give an example:
    
    ```
    a       <- c(1,2,1,4,1,5,4,3,2,2,1,6,3,1,3,5,5)
    b       <- c(4,6,9)
    results <- runMatlabFct( "[bool, pos] = ismember(b,a)" )
    ```

    would return the following results

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