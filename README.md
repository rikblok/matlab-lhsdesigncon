# lhsdesigncon (MATLAB)

MATLAB function to generate am NxP latin hypercube sample with bounds
and linear constraints and optional exponential distribution.

## Getting the `lhsdesigncon` MATLAB function

To use the `lhsdesigncon` function:

1. Download from the files from either:
* [MATLAB Central File Exchange](), or
* [GitHub]().
2. Unzip the files and place them on your MATLAB path
   (e.g. your `My Documents/MATLAB` folder on Windows).
3. Use the function (see [examples
   below](#matlab-function-description-and-examples)).

This GitHub repo is a development library. To contribute fork this repo.

### MATLAB Function Description and Examples

Generate am NxP latin hypercube sample with bounds
and linear constraints and optional exponential distribution.

X=LHSDESIGNCON(N,P,LB,UB,ISEXP) generates a latin hypercube sample X
containing N values on each of P variables.  For each column, if ISEXP
is FALSE the N values are randomly distributed with one from each
of N intervals, between LB and UB, of identical widths (UB-LB)/N, and
they are randomly permuted.  For columns with ISEXP=TRUE, the logarithm
of the intervals have identical widths.

X=LHSDESIGNCON(...,A,b) generates a latin hypercube sample subject to 
the linear inequalities A*x ? b. 

X=LHSDESIGNCON(...,'PARAM1',val1,'PARAM2',val2,...) specifies parameter
name/value pairs to control the sample generation.  See LHSDESIGN for 
valid parameters.

Latin hypercube designs are useful when you need a sample that is
random but that is guaranteed to be relatively uniformly/exponentially
distributed over each dimension.

Example:  The following command generates a latin hypercube sample X
          containing 10000 values for each of 2 variables.  The first
          variable is uniformly sampled between -100 and +100, the
          second is exponentially sampled between 10^-1 and 10^2 (ie.
          the exponent is uniformly sampled between -1 and 2).
          Additionally, the samples satisfy the constraints 
          X(1) + X(2) <= 50 and X(2) - X(1) >= 25.

```MATLAB
A = [1, 1; 1, -1]; b = [50; -25]; % A x <= b
x = lhsdesigncon(10000,2,[-100 1e-1],[100 1e2],[false true],A,b);
% Show samples are well distributed within constraints.
figure;
semilogy(x(:,1),x(:,2),'.');
```

### Limitations

* The constraints are not checked for consistency.  If they are inconsistent
the function will loop forever, with just a warning "None of ... samples fit constraints."


## License

The MATLAB Central File Exchange and this source code are distributed
under the [BSD-2 License](LICENSE.txt).

