% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_side_colors.R
\name{get_side_colors}
\alias{get_side_colors}
\title{Get Side Colors}
\usage{
get_side_colors(
  sampInfo,
  sampleTracks = names(sampInfo),
  colorlists = c("gray94", "blue", "green", "yellow", "orange", "red", "black"),
  displaynames = as.list(sampleTracks),
  drop.levels = FALSE
)
}
\description{
\code{get_side_colors} is a helper function used in the \code{heatmap_generator} function that creates a create a sidecolor object from a sample info matrix-like object and a list of tracks.
}
