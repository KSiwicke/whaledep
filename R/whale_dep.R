#' wrapper function to produce plots
#'
#' @param channel where the at-sea Access database is
#' @param station station number
#'
#' @return plots for viewing
#' @export whale_dep
#'
#' @examples
#' \dontrun{
#' whale_dep(channel, station)
#' }
whale_dep <- function(channel, station) {
  names <- RODBC::sqlQuery(channel , base::paste0("select * from \"Sppcode Catch\"")) %>%
    dplyr::rename_all(tolower)

  strat <- RODBC::sqlQuery(channel , base::paste0("select * from DepthStratum")) %>%
    dplyr::rename_all(tolower)

  dat <- whaledep:::get_data(channel = channel, sta_num = station)
  depth = dat[[1]]
  cat = dat[[2]]

  plot_dat <- whaledep:::make_plot_data(depth = depth, cat = cat, strat = strat, names = names)

  depth_strat <- plot_dat[[1]]
  depth_strat$effective <- 45 - depth_strat$ineffective
  spp_sum_strat <- plot_dat[[2]]
  dep <- plot_dat[[3]]
  catch <- plot_dat[[4]]
  spp_sum <- plot_dat[[5]]
  cpue <- plot_dat[[6]]
  cpue_sab_strat <- plot_dat[[7]]
  roll <- plot_dat[[8]]

  write.csv(cpue_sab_strat[, 1:5], paste0(station, '_cpue.csv'))

  plt <- whaledep:::plot_data(depth_strat = depth_strat, spp_sum_strat = spp_sum_strat, dep = dep, catch = catch, spp_sum = spp_sum, cpue = cpue, cpue_sab_strat = cpue_sab_strat, roll = roll)
}
