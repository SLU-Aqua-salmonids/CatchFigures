library(dplyr)
library(tidyr)
library(readxl)
library(writexl)
library(ggplot2)
library(svglite)
library(scales)
library(SLUcolors)
library(RColorBrewer)

first_year <- 2001
## Fig 5
sv_catch_data <- read_excel("Data/figure_data_long.xlsx") %>%
  filter(År >= first_year) %>%
    mutate(År = factor(År),
           Fiske = factor(Fiske, levels = c("Fritidsfiske fällor kust",
                                            "Fritidsfiske trolling hav",
                                            "Fritidsfiske spö älv",
                                            "Fritidsfiske husbehov älv",
                                            "Yrkesfiske hav",
                                            "Yrkesfiske kust",
                                            "Yrkesfiske älv (odlad)",
                                            "Avelsfiske älv")))

#colors <-  SLU_cols(1:length(unique(sv_catch_data$Fiske)))
# colors <-  c(SLUpalette("blue")[2:4],
#              SLUpalette("green")[2:4],
#              SLUpalette("red")[3:4])
#colors <-  c("#000000", SLUpalette("wong_234516"), "#FCFCFC")
#colors <- RColorBrewer::brewer.pal(8, "Set2")
colors <- RColorBrewer::brewer.pal(8, "Paired")

names(colors) <- unique(sv_catch_data$Fiske)

#last_year <- max(sv_catch_data$År)
sv_catch <- ggplot(sv_catch_data, aes(x = År, y = Antal, fill = Fiske)) +
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_manual(values = colors) +
  scale_y_continuous(labels = comma_format(big.mark = " ")) +
#  xlim(first_year, last_year) +
  labs(x=NULL, y="Antal laxar") + 
  theme_bw() +
  theme(text = element_text(family="Times New Roman"),
#        plot.title = element_text(hjust = 0.5),
        axis.text.x=element_text(size=7, angle=45, hjust=1),
        axis.text.y=element_text(size=9),
        axis.line = element_line(colour = "black", linewidth = 0.3),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        legend.position="bottom",
        legend.text=element_text(size=7),
        legend.direction="horizontal",
        legend.title = element_blank())

WIDTH <- 14
HEIGHT <- 9
ggsave("swe_catch_detailed.png", sv_catch,
       width = WIDTH, height = HEIGHT, units = "cm")
ggsave("swe_catch_detailed.svg", sv_catch,
       width = WIDTH, height = HEIGHT, units = "cm")


