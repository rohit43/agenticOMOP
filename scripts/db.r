library(duckdb)
library(dplyr)
library(ggplot2)
library(knitr)

con <- dbConnect(duckdb())

# Custom ggplot theme for OMOP reports
theme_omop <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(face = "bold", size = 14),
      axis.title = element_text(size = 11),
      axis.text = element_text(size = 10)
    )
}

tables <- c("person", "observation_period",
            "condition_occurrence", "condition_era",
            "drug_exposure", "drug_era",
            "visit_occurrence", "procedure_occurrence",
            "measurement", "observation")

for (t in tables) {
  dbExecute(con, sprintf(
    "CREATE VIEW %s AS SELECT * FROM read_csv_auto('data/%s.csv')", t, t
  ))
}