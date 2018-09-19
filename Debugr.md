In this tutorial you will learn about debugging in R in Rstudio and
using debugr package.

When we talk about in debugging in R, there is a slight negative aspect
in people who work on python and other programming IDEs. There are some
useful functions in R itself like traceback() and browser(), and
interactive tools in RStudio but somehow there are few limitations which
is not handled by built in functionalities, In such scenarios we got
stuck with our issues and that takes much more time to resolve.

Then arrive the `debugr` package which you can use while writing complex
methods and loops which shows you the runtime variable entries and
assist in solving the bug in much less time, although you require a
preplanning for code entries and the points on action for debugr but its
worth to give some time in it than resolving the issue in hard way at
the time of its execution.

### Aspects of debugging in Rstudio

Rstudio provides an interactive platform for debugging that makes
detecting bugs in complex functions much easier

Lets draw a function mentioned below and apply these methods.

f &lt;- function(a) g(a) g &lt;- function(b) h(b) h &lt;- function(c)
i(c) i &lt;- function(d) j(d) j &lt;- function(e) “a” + e

f(10)

![Snapshot of the error by running the program](Capture1.png)

here you can browse to different functions to check the code in an
iterative way. The function you browse will show its code.

![Browsing the error](Capture2.png)

![Using Traceback](Capture3.png)

You can use traceback to see the flow of function calls made by
individual ones.

### Debugging on error

While executing code in Rstudio if an error comes then Rstudio provides
two methods its interactive console one is traceback, that shows you the
flow of the function calls and the other is Rerun with debug. If you
choose rerun with debug Rstudio will take you to the interactive
debugger session which also pause the execution where error occurred.

When you are in the editor you can use either with the [!RStudio
toolbar()](Capture4.png) or with the keyboard to move in debugging
steps:

-   ![Next](Capture5.png), n: This button will take you to the next
    step.

-   ![Step into](Capture6.png), or s: works like next, but instead of
    next step it steps into next function.

-   ![Finish](Capture7.png), or f: finishes execution of the current
    loop or function.

-   ![Continue](Capture8.png), c: leaves interactive debugging.

-   ![Stop](Capture9.png), Q: stops debugging, terminates the function,
    and returns to the global workspace.

### Setting Break points in arbitrary code

Rstudio enters in an interactive console on error, but you can enter at
an arbitrary code location by using either an Rstudio breakpoint or
browser().

The breakpoint can be added through several methods: 1. You can click on
the left of the line of the code. 2. You can press Shift+F9 on the line
of the code. 3. You can add browser() where execution needs to be
stopped.

-   RStudio currently does not support conditional breakpoints that is
    putting a breakpoint by passing a criteria, which is somewaht
    handled in debugr package discussed in this tutorial. \*

For details on these debugging methods visit
here(<https://support.rstudio.com/hc/en-us/articles/205612627-Debugging-with-RStudio>).

**Now lets talk about the package `debugr`.**

Debugr supports a more simpler aspect of debugging which is easy to
understand if you are involved in less debugging work. Debugr has few
simple functions that are:

-   debugr\_isActive :- Switching debug mode on and off.
-   debugr\_switchOff :- Switching debug mode on and off.
-   debugr\_switchOn :- Switching debug mode on and off.
-   dwatch :- Printing debug outputs during runtime.

Out of all these functions dwatch plays the most important role, it
prints a debug output to a console or a file in a more complicate case.
The output can be static text , one or many values of the variables.

For any debugging function you need switch on the debugging
functionality of debugr which is easily done by `debug_switchOn()`. You
can put your dwatch() function anywhere you want to debug the code
sepcially in production level code and debug it whenever a situation
came by switching it on and later switch it off by using
`debugr_switchOff()` function.

Lets look at the structure of dwatch function in a sample code.

``` r
library(debugr)

debugr_switchOn()

myfunction <- function(x) {
  
  z <- 1

  for(i in 1:x) {
    dwatch(crit = "z > 40000", objs = c("z", "i"))
    z <- z * i
  }
  # avoiding to print the z
  invisible(z)
}

myfunction(10)
```

    ## 
    ## ----------------------------- DEBUGR MESSAGE ------------------------------
    ## 
    ## ** z:
    ## [1] 40320
    ## 
    ## 
    ## ** i:
    ## [1] 9
    ## 
    ## ---------------------------------------------------------------------------
    ## 
    ## ----------------------------- DEBUGR MESSAGE ------------------------------
    ## 
    ## ** z:
    ## [1] 362880
    ## 
    ## 
    ## ** i:
    ## [1] 10
    ## 
    ## ---------------------------------------------------------------------------

``` r
debugr_switchOff()
```

Here the code is going through iterative multiplication or you can apply
any case used in your functions, the dwatch function applied on the
variable z with the criteria **z &gt; 4000**. So as a result messages
are printed when criteria is fullfilled and desired results got printed
that is values of z and i variables.

You can use some sophisticated arguments that manipulates the fromat of
the output.

``` r
debugr_switchOn()

myfunction <- function(x) {
  
  z <- 1

  for(i in 1:x) {
    dwatch(crit = "z > 40000", expr=c("format(z, big.mark = \",\")", "format(i, big.mark = \",\")"))
    z <- z * i
  }
  # avoiding to print the z
  invisible(z)
}

myfunction(10)
```

    ## 
    ## ----------------------------- DEBUGR MESSAGE ------------------------------
    ## 
    ## ** Expression: format(z, big.mark = ",")
    ## [1] "40,320"
    ## 
    ## ** Expression: format(i, big.mark = ",")
    ## [1] "9"
    ## ---------------------------------------------------------------------------
    ## 
    ## ----------------------------- DEBUGR MESSAGE ------------------------------
    ## 
    ## ** Expression: format(z, big.mark = ",")
    ## [1] "362,880"
    ## 
    ## ** Expression: format(i, big.mark = ",")
    ## [1] "10"
    ## ---------------------------------------------------------------------------

``` r
debugr_switchOff()
```

### There are few more arguments that you can incorporate:

-   show.all : By setting this argument `TRUE` you can see all objects
    for the criteria.
-   msg : It is used to add a static text message.
-   show.frame : By setting this argument as `FALSE` you can remove
    upper and lower border.
-   halt : By setting this argument as `TRUE` you can stop the
    transaction as soon as the criteria is fullfilled.
