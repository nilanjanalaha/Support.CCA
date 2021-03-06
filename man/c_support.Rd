% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Initial.R
\name{c_support}
\alias{c_support}
\title{Support recovery of the first pair of canonical directions}
\usage{
c_support(x, y, sv, c, B, tau, nl, Sx, Sy, is.standardize)
}
\arguments{
\item{x}{A matrix with n rows and p columns;
corresponds to the first data matrix.}

\item{y}{A matrix with n rows and q columns; corresponds to the second data matrix.}

\item{sv}{Optional. A vector giving the number of non-zero elements in the canonical
covariates \eqn{\alpha} and \eqn{\beta}, respectively. See 'details'
for more information.}

\item{c}{Optional. A positive constant corresponding to the threshold level in the
co-ordinate thresholding step to estimate the covariance matrix. The default choice is
one.}

\item{B}{Optional. The condition number of \eqn{\Sigma}, the joint covariance 
matrix of \eqn{x} and \eqn{y}.}

\item{tau}{Optional. A positive tuning parameter corresponding to the cut-off level in the
cleaning step of the co-ordinate thresholding algorithm. If 
not provided, it is calculated from the data.}

\item{nl}{Optional. A positive tuning parameter taking value in (0,0.50).  Corresponds to the cut-off level in the
cleaning step of the co-ordinate thresholding algorithm. If 
not provided, it is calculated from the data.}

\item{Sx}{Optional. A \eqn{p\times p} matrix, the variance of X. Must be positive definite. If missing, estimated from the data.}

\item{Sy}{Optional. A \eqn{q\times q} matrix, the variance of Y. Must be positive definite.  If missing, estimated from the data.}

\item{is.standardize}{Can be either ``TRUE" or ``FALSE". Indicats hether the variables will be standardized to have mean zero.
The default is TRUE.}
}
\value{
A list of two arrays.
\itemize{
\item sup.x - An array with length p with binary entries. If the i-th element
            is 0, it means that i is not in the support of \eqn{\alpha}.
            Conversely, if the i-th element is 1, it means i is in the support
            of \eqn{\alpha}.
\item sup.y - An array with length p with binary entries. If the i-th element
            is 0, it means that i is not in the support of \eqn{\beta}.
            Conversely, if the i-th element is 1, it means i is in the support
            of \eqn{\beta}.
}
}
\description{
This function implements the coordinate thresholding algorithm of \emph{Laha et al. (2020)}. 
to estimate the support of the first pair of canonical directions of X and Y.
}
\details{
\code{sv}: sv can be a rough estimate of the sparsity (number of non-zero elements)
            of \eqn{\alpha} and \eqn{\beta}, since only the order is important (see laha et al., 2020) 
            here. The returned supports of \eqn{\alpha} and \eqn{\beta} will not necessarily  match
            the same sparsity levels as provided in sv. In absence of user specified sv,
            it is estimated from the data using Mai and Zhang (2017)'s SCCA.

\code{c1, c2}:   See Theorem 3 of Laha and Mukherjee (2020) to see how
                        these tuning parameters control the thresholding of
                        the covariance matrix. Larger value of c1 and c2 will
                        result in a higher value of thresholding parameter, which
                        will give a sparser estimator of the covariance matrix. The method is
                        less sensitive to c2 than it is to c1.

\code{tau, nl}:   The cleaning step of the co-ordinate threshold
                          uses the cut-off level
                          \deqn{tau \frac{\log(2s)^{0.5+nl}}{s}.}
                          Therefore, higher values of tau and nl result in
                          a higher cut-off value, shrinking the estimated support.
                          See Theorem 4 of Laha and Mukherjee (2020) for more details.
}
\examples{
library(mvtnorm)
#Simulate  standard normal data matrix: first generate alpha and beta
p <- 500; q <- 200; al <- c(rep(1, 10), rep(0, 490));
be <- c(rep(0,150), rnorm(50,1))

#Normalize alpha and beta
al <- al/sqrt(sum(al^2))
 be <- be/sqrt(sum(be^2))
n <- 300; rho <- 0.5

 #Creating the  covariance matrix
Sigma_mat <- function(p,q,al,be, rho)
{
Sx <- diag(rep(1,p), p, p)
Sy <- diag(rep(1,q), q, q)
Sxy <- tcrossprod(crossprod(rho*Sx, outer(al, be)), Sy)
Syx <- t(Sxy)
rbind(cbind(Sx, Sxy), cbind(Syx, Sy))
}
truesigma <-  Sigma_mat(p,q,al,be, rho)

#Simulating the data
Z <- mvtnorm::rmvnorm(n, sigma = truesigma)
x <- Z[,1:p]
y <- Z[,(p+1):(p+q)]

#Support of alpha
which(c_support(x=x, y=y, sv=c(10, 50))$sup.x==1)
}
\references{
Laha, N., Mukherjee, R. (2021) 
\emph{Support recovery of canonical correlation analysis}. Submitted

Mai, Q., Zhang, X. (2019) \emph{An iterative penalized least squares 
approach to sparse canonical correlation analysis}, Biometrics, 75, 734-744.
}
\seealso{
\code{\link{g_support}}
}
\author{
\href{https://connects.catalyst.harvard.edu/Profiles/display/Person/184207}{Nilanjana Laha}
(maintainer), \email{nlaha@hsph.harvard.edu},
Rajarshi Mukherjee, \email{ram521@mail.harvard.edu}.
}
