#' AGED Violin Plot Generator
#'
#' \code{violin_generator} will pull metagene information from \code{AGED} results to plot expression from each sample for each metagene
#'
#' @param aged_results The results of a successful call to \code{AGED}
#'
#' @param data The original data that was plugged into the initial call of \code{AGED}
#'
#' @param batch A string vector representation of size \code{n} where \code{n} equals the number of samples. This vector should detail how each sample should be categorized within each violin plot. Using a column from a data's sample information dataframe is common. For example, one might want to separate violin plots by treatment or batch. 
#' 
#' @param batch_order A string vector representation that details the order in which the samples should be displayed on the violin plot and legend. This vector should be of size \code{p} where \code{p} equals the number of different categories, treatments, batches, etc. that were included in the batch parameter, and the strings must match exactly to the ones given in \code{batch}.
#' 
#' @param var_axis A string representing the desired value to be printed on the axis representing the categorization/batch set by \code{batch}. Defaults to "treatment".
#' 
#' @param clear_low_variance A boolean variable that determines whether rows with var < 1 are removed or not. This is done before any type of transformation is performed.
#' 
#' @param transformation_type A string variable that determines whether or not a log or VST transformation should be done on the original data. If this argument is used, it should be "vst" or "log" only. If no transformation is to be performed, the default value or any string other than "vst" or "log" can be used.
#' 
#' @param blind If a VST is to be done, this boolean value determines whether it is blind or not.
#' 
#' @param nrow The number of violin plots that should be in each row
#' 
#' @param scales_free A character string indicating the preference for scales for the violin plots. This argument should take one of the following four values: "fixed", "free", "free_x", "free_y".
#' 
#' @param beeswarm_size A numerical value indicating the desired size for the beeswarm points
#' 
#' @param beeswarm_color A character string inidcating the desired color for the beeswarm points 
#'
#' @return Returns a object of type 'list' produced by the ggplot2 package that is ready to be plotted
#'
#' @export
#' 
#' @import ggplot2
#' @import ggbeeswarm
#' @import DESeq2

violin_generator <- function(aged_results, data, batch, batch_order = names(table(batch)), var_axis = "treatment", clear_low_variance = F, transformation_type = "", blind = TRUE, nrow = 2, scales_free = "fixed", beeswarm_size = 1, beeswarm_color = "black") {
  
  # verify and prepare data
  data <- aged::verify_and_transform_data(data,clear_low_variance = clear_low_variance, transformation_type = transformation_type, blind = blind)
  
  rank <- length(aged_results) - 2
  n <- length(aged_results[[1]][[1]])
  for (i in 1:rank) {
    n <- max(length(aged_results[[i]][[1]]))
  }
  batches <- table(batch)
  for (i in 1:length(batches)) {
    df <- data.frame(matrix(ncol=3,nrow=(rank*unname(batches[i]))))
    df$X3 <- names(batches)[i]
    assign(paste("treatment_matrix_",i,sep=""), df)
  }
  for (i in 1:rank) {
    desired_vector <- aged_results[[i]][[1]]
    desired_vector_names <- names(desired_vector)
    metagene_matrix <- data[rownames(data) %in% desired_vector_names[1:n],]
    metagene_matrix_column_means <- colMeans(metagene_matrix)
    for (j in 1:length(batches)) {
      lower_index <- (1 + (i-1)*unname(batches[j]))
      upper_index <- (i * unname(batches[j]))
      df <- get(paste("treatment_matrix_",j,sep=""))
      df$X1[lower_index:upper_index] <- i
      df$X2[lower_index:upper_index] <- metagene_matrix_column_means[which(batch %in% names(table(batch))[j])]
      assign(paste("treatment_matrix_",j,sep=""), df)
    }
  }
  treatment_matrix <- data.frame()
  for (i in 1:length(batches)) {
    treatment_matrix <- rbind(treatment_matrix, get(paste("treatment_matrix_",i,sep="")))
  }
  names(treatment_matrix)[1] <- "metagene"
  names(treatment_matrix)[2] <- "score"
  names(treatment_matrix)[3] <- "treatment"
  treatment_matrix$treatment <- factor(treatment_matrix$treatment, levels = batch_order)
  label_maker <- function(string, prefix = "Metagene ") paste(prefix, string)
  g <- ggplot(data = treatment_matrix, aes(x = treatment, y = score)) +
    geom_violin(aes(fill = treatment)) +
    xlab(var_axis) +
    coord_flip() +
    facet_wrap(facets = vars(factor(metagene)), scales = scales_free, nrow = nrow, labeller = as_labeller(label_maker)) +
    scale_x_discrete(limits=rev(batch_order)) +
    geom_beeswarm(aes(x = treatment), size = beeswarm_size, color = beeswarm_color) +
    guides(fill=guide_legend(title=var_axis))
  return(g)
}