dbGetQuery(con, "
  SELECT COUNT(*)                        AS total_exposures,
         COUNT(DISTINCT drug_concept_id) AS unique_drugs,
         COUNT(DISTINCT person_id)       AS patients_with_drugs
  FROM drug_exposure
") |> kable()

dbGetQuery(con, "
  SELECT COUNT(*) AS total_eras,
         ROUND(AVG(DATEDIFF('day',
           drug_era_start_date,
           drug_era_end_date)), 1) AS mean_era_days
  FROM drug_era
") |> kable()

top <- dbGetQuery(con, "
  SELECT CAST(drug_concept_id AS VARCHAR) AS drug, COUNT(*) AS n
  FROM drug_exposure
  GROUP BY 1 ORDER BY 2 DESC LIMIT 10
")
ggplot(top, aes(x = reorder(drug, n), y = n)) +
  geom_col(fill = "#6BCB77") +
  coord_flip() +
  labs(title = "Top 10 Drugs by Exposure", x = "Drug Concept ID", y = "Count") +
  theme_omop()