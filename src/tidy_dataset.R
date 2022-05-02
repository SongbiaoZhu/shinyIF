library(tidyverse)
library(magrittr)

# Import JCR database
jcrfs <- list.files(path = "./www", pattern = "JCR.+csv$")
years <- stringr::str_extract(jcrfs, '\\d+')
jcrs <- lapply(jcrfs, function(x)
  read.csv(file.path("www", x)))
jcr_latest <- read.csv(file.path("www", jcrfs[length(jcrfs)]))

# List of choices for selectInput
journals <- as.list(jcr_latest$Full.Journal.Title)

saveRDS(object = list(jcrfs = jcrfs,
                      years = years,
                      jcrs = jcrs,
                      jcr_latest = jcr_latest,
                      journals = journals),
        file = "www/ifDatasets.RDS")
