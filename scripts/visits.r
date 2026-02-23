dbGetQuery(con, "
  SELECT COUNT(*)                  AS total_visits,
         COUNT(DISTINCT person_id) AS patients_with_visits,
         ROUND(AVG(DATEDIFF('day', visit_start_date, visit_end_date)), 1) AS mean_los_days
  FROM visit_occurrence
") |> kable()

dbGetQuery(con, "
  SELECT COUNT(*)                             AS total_procedures,
         COUNT(DISTINCT procedure_concept_id) AS unique_procedures,
         COUNT(DISTINCT person_id)            AS patients_with_procedures
  FROM procedure_occurrence
") |> kable()

# Visit types bar
vtypes <- dbGetQuery(con, "
  SELECT CAST(visit_concept_id AS VARCHAR) AS visit_type, COUNT(*) AS n
  FROM visit_occurrence GROUP BY 1 ORDER BY 2 DESC
")
ggplot(vtypes, aes(x = reorder(visit_type, n), y = n)) +
  geom_col(fill = "#F4845F") +
  coord_flip() +
  labs(title = "Visit Types", x = "Visit Concept ID", y = "Count") +
  theme_omop()

# LOS distribution
los <- dbGetQuery(con, "
  SELECT DATEDIFF('day', visit_start_date, visit_end_date) AS los
  FROM visit_occurrence
  WHERE DATEDIFF('day', visit_start_date, visit_end_date) <= 30
")
ggplot(los, aes(x = los)) +
  geom_histogram(binwidth = 1, fill = "#FFD166", color = "white") +
  labs(title = "Length of Stay (≤30 days)", x = "Days", y = "Count") +
  theme_omop()