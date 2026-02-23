dbGetQuery(con, "
  SELECT COUNT(*)                             AS total_occurrences,
         COUNT(DISTINCT condition_concept_id) AS unique_conditions,
         COUNT(DISTINCT person_id)            AS patients_with_conditions
  FROM condition_occurrence
") |> kable()

dbGetQuery(con, "
  SELECT COUNT(*) AS total_eras,
         ROUND(AVG(DATEDIFF('day',
           condition_era_start_date,
           condition_era_end_date)), 1) AS mean_era_days
  FROM condition_era
") |> kable()

top <- dbGetQuery(con, "
  SELECT CAST(condition_concept_id AS VARCHAR) AS condition, COUNT(*) AS n
  FROM condition_occurrence
  GROUP BY 1 ORDER BY 2 DESC LIMIT 10
")
ggplot(top, aes(x = reorder(condition, n), y = n)) +
  geom_col(fill = "#4C9BE8") +
  coord_flip() +
  labs(title = "Top 10 Conditions", x = "Condition Concept ID", y = "Count") +
  theme_omop()