Debugging is the art and science of fixing unexpected problems in your
code.

When we talk about in debugging in R, there is a slight negative aspect
in people who work on python and other programming IDEs. There are some
useful functions in R itself like traceback() and browser(), and
interactive tools in RStudio.

### There are three key debugging tools:

-   RStudio’s error inspector and traceback() which list the sequence of
    calls that lead to the error.

-   RStudio’s “Rerun with Debug” tool and options(error = browser) which
    open an interactive session where the error occurred.

-   RStudio’s breakpoints and browser() which open an interactive
    session at an arbitrary location in the code.

Lets draw a function mentioned below and apply these methods.

f &lt;- function(a) g(a) g &lt;- function(b) h(b) h &lt;- function(c)
i(c) i &lt;- function(d) j(d) j &lt;- function(e) “a” + e

f(10)

![Snapshot of the error by running the program](Capture1.png)

![Browsing the error](Capture2.png)

![Using Traceback](Capture3.png)

### Browsing on error

When you are debugging using previous methods then there are a few
special commands you can use in debug mode. You can access them either
with the [!RStudio toolbar()](Capture4.png) or with the keyboard:

-   ![Next](Capture5.png), n: executes the next step in the function. Be
    careful if you have a variable named n; to print it you’ll need to
    do print(n).

-   ![Step into](Capture6.png), or s: works like next, but if the next
    step is a function, it will step into that function so you can work
    through each line.

-   ![Finish](Capture7.png), or f: finishes execution of the current
    loop or function.

-   [!Continue](Capture8.png), c: leaves interactive debugging and
    continues regular execution of the function. This is useful if
    you’ve fixed the bad state and want to check that the function
    proceeds correctly.

-   ![Stop](Capture9.png), Q: stops debugging, terminates the function,
    and returns to the global workspace. Use this once you’ve figured
    out where the problem is, and you’re ready to fix it and reload the
    code.

### Browsing arbitrary code

As well as entering an interactive console on error, you can enter it at
an arbitrary code location by using either an Rstudio breakpoint or
browser(). You can set a breakpoint in Rstudio by clicking to the left
of the line number, or pressing Shift + F9. Equivalently, add browser()
where you want execution to pause. Breakpoints behave similarly to
browser() but they are easier to set (one click instead of nine key
presses), and you don’t run the risk of accidentally including a
browser() statement in your source code. There are two small downsides
to breakpoints:

-   There are a few unusual situations in which breakpoints will not
    work: read (breakpoint
    troubleshooting)\[<https://support.rstudio.com/hc/en-us/articles/200534337-Breakpoint-Troubleshooting>\]
    for more details.

-   RStudio currently does not support conditional breakpoints, whereas
    you can always put browser() inside an if statement.

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

There are few more arguments that you can incorporate:

-   show.all : By setting this argument `TRUE` you can see all objects
    for the criteria.
-   msg : It is used to add a static text message.
-   show.frame : By setting this argument as `FALSE` you can remove
    upper and lower border.
-   halt : By setting this argument as `TRUE` you can stop the
    transaction as soon as the criteria is fullfilled.
