#Load necessary packages
install.packages("cfbfastR")
if (!require("remotes")) install.packages("remotes")
remotes::install_github("Kazink36/cfbplotR")
library(gt)
library(cfbplotR)
library(gtExtras)
#Load 2025 pbp
pbp_25 <- cfbfastR::load_cfb_pbp()

#Filter for SEC defenses
sec_defense_pbp <- pbp_25 |> 
  dplyr::filter(defense_conference == "SEC" & !is.na(EPA))

#aggregate stats
def_stats_by_team <- sec_defense_pbp |> 
  dplyr::group_by(defense_play) |> 
  dplyr::summarise(mean_epa = (mean(EPA),
                   total_epa = sum(EPA),
                   success = mean(epa_success),
                   pass_epa = mean(EPA[pass == 1]),
                   rush_epa = mean(EPA[rush == 1]),
                   sack_rate = mean(sack),
                   int_rate = mean(int)) |> 
  dplyr::arrange(mean_epa)

#put into a table viz
def_stats_by_team |> 
  gt() |> 
  cfbplotR::gt_fmt_cfb_logo(columns = defense_play) |> 
  gt::fmt_number(columns = c(mean_epa,
                             total_epa,
                             pass_epa,
                             rush_epa),
                 decimals = 2) |> 
  gt::fmt_percent(columns = c(success,
                             sack_rate,
                             int_rate)) |> 
  gt::cols_label(defense_play = "Team",
                 mean_epa = "EPA/play",
                 total_epa = "Total EPA",
                 success = "Success %",
                 pass_epa = "EPA/pass",
                 rush_epa = "EPA/rush",
                 sack_rate = "Sack %",
                 int_rate = "INT %") |> 
  gt::tab_header(title = "Defensive Statistics Overview",
                 subtitle = "SEC, 2025 Season") |> 
  gtExtras::gt_color_rows(columns = c(mean_epa,
                                      total_epa,
                                      pass_epa,
                                      rush_epa),
                          palette = "ggsci::blue_material", direction = -1) |> 
  gtExtras::gt_color_rows(columns = c(success,
                                      sack_rate,
                                      int_rate),
                          palette = "ggsci::blue_material")
                   
                          