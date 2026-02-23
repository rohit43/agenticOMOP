df <- dbGetQuery(con, "
  SELECT p.person_id,
         (2020 - p.year_of_birth) AS age,
         COUNT(DISTINCT vo.visit_occurrence_id)     AS n_visits,
         COUNT(DISTINCT po.procedure_occurrence_id) AS n_procedures,
         COALESCE(ROUND(SUM(DATEDIFF('day',
           vo.visit_start_date, vo.visit_end_date)), 0), 0) AS total_los_days
  FROM person p
  LEFT JOIN visit_occurrence vo USING (person_id)
  LEFT JOIN procedure_occurrence po USING (person_id)
  GROUP BY 1, 2
  ORDER BY n_visits DESC
")

cat(sprintf("- **Mean visits per patient:** %.1f  \n", mean(df$n_visits, na.rm = TRUE)))
cat(sprintf("- **Mean procedures per patient:** %.1f  \n", mean(df$n_procedures, na.rm = TRUE)))
cat(sprintf("- **Mean total hospital days:** %.1f\n\n", mean(df$total_los_days, na.rm = TRUE)))

head(df, 20) |> kable(caption = "Top 20 patients by visit count")

ggplot(df, aes(x = n_visits)) +
  geom_histogram(binwidth = 1, fill = "#4C9BE8", color = "white") +
  labs(title = "Visits per Patient", x = "Number of Visits", y = "Patients") +
  theme_omop()