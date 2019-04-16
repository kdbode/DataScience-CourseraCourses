# This function is used to create Matrix objects that
# can have their values cached within the creator function

makeCacheMatrix <- function(x = matrix()) {
    inv<- NULL             # function defines x and the inverse of x which will be inv
                           # make sure not to use a sigular matrix as argument or cacheSolve() will error
    
    set <- function(y){    # function defines set to change and cache matrix
        x <<- y
        inv <<- NULL
    }
    
    get <- function() x                                # function to get matrix in cache
    setinverse <- function(inverse) inv <<- inverse    # function to set/change matrix being used
    getinverse <- function() inv                       # function to return inverse of matrix 
    list(set = set, get = get,                         # return for created Matrix objects
         setinverse = setinverse,
         getinverse = getinverse)
}


# This function takes a makeCacheMatrix object first. It then checks to see if the inverse
# of the matrix has been calculated. If it has it just grabs that data from the object
# otherwise it uses solve to invert the matrix and return the inversion

cacheSolve <- function(x, ...) {
    inv <- x$getinverse()                # uses $getinverse function from makeCacheMatrix function and sets
    #   inv value to the function's return (NULL or Inverse Matrix)
    if(!is.null(inv)){                   # If value isn't NULL then it messages and returns the inverse matrix
        message("getting cached data")
        return(inv)
    }
    data <- x$get()                     # If value was NULL then it using makeCacheMatrix function to get matrix
    inv <- solve(data, ...)             # then it solves for the inverse of the matrix
    x$setinverse(inv)                   # then it caches the inverse matrix for later recall
    inv                                 # finally it returns the inverse matrix
}

