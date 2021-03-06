% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cophenetic_generator.R
\name{cophenetic_generator}
\alias{cophenetic_generator}
\title{Cophenetic Correlation Coefficient Plot Generator}
\usage{
cophenetic_generator(
  data,
  rank_range = 2:20,
  nrun = 12,
  nmf_seed = 123456,
  .options = "p4",
  .pbackend = "",
  colors = TRUE,
  clear_low_variance = FALSE,
  transformation_type = "",
  blind = TRUE
)
}
\arguments{
\item{data}{Gene expression target data, a matrix-like object. The rows should represent genes, and each row must have a unique row name. Each column should represent a different sample.}

\item{rank_range}{Any numeric vector containing ranks of factorization to try (does not need to be continuous). Duplicates are removed, and the vector will be sorted in increasing order before use. All values should be positive and greater than 1.}

\item{nrun}{The desired number of NMF runs. For simply determing the cohpenetic correlation coefficient for each rank, it is not entirely necessary to perform a high number of runs or as many runs as normal when running NMF. This function defaults to 12, but any number of runs can be used.}

\item{nmf_seed}{The desired seed to be used for NMF}

\item{.options}{This argument is used to set runtime options. See \link[NMF]{nmf} for detailed information.}

\item{.pbackend}{This argument is used in accordance with the .options parameter. See \link[NMF]{nmf} for detailed information.}

\item{colors}{A boolean argument determining whether or not the specified points in the documentation (maximum value, point preceding the largest drop) should be highlighted in color. If TRUE, the points will be highlighted. If false, no points will be highlighted.}

\item{clear_low_variance}{A boolean variable that determines whether or not rows with variance less than 1 should be removed from the original dataset.}

\item{transformation_type}{A string variable that determines whether or not a log or VST transformation should be done on the original dataset. If this argument is intended to be used to perform a transformation, it should be "vst" or "log" only.}

\item{blind}{If a VST is to be done, this boolean value determines whether it is blind or not.}
}
\value{
A line graph that displays the cophenetic coefficients for the values in the range of ranks you selected. This function also plots it for you.
}
\description{
\code{cophenetic_generator} will run non-negative matrix factorization to determine the cophenetic correlation coefficient for each rank of factorization in a desired range of ranks decided by the user. The cophenetic correlation coefficient can be helpful for the user in deciding what rank to use when running NMF. The raw cophenetic correlation coefficient value, the elbow method, or any other applicable approach can help determine a desirable rank for NMF. The higher the cophenetic correlation coefficient is, the more stable and reproducible the NMF results are. In the plot returned by this graph, the rank with the highest cophenetic correlation coefficient will be highlighted in red. If the input vector for \code{rank_range} is continuous, the rank directly before the biggest drop in cophenetic correlation coefficient, before any positive slopes, will be highlighted in cyan. If these two points are the same, the point will be highlighted in magenta. In the extremely rare event of a tie in numerical values, the first index is selected. However, it is ultimately up to the user to decide what rank is best fit for NMF runs.
}
