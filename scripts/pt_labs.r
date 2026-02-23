top_concepts <- dbGetQuery(con, "
  SELECT measurement_concept_id, COUNT(*) AS n
  FROM measurement
  WHERE value_as_number IS NOT NULL
  GROUP BY 1 ORDER BY 2 DESC LIMIT 5
")

top_concepts |> kable(caption = "Top 5 numeric measurement types")

for (cid in top_concepts$measurement_concept_id) {
  cat(sprintf("\n\n**Concept %s**\n\n", cid))

  dbGetQuery(con, sprintf("
    SELECT person_id,
           COUNT(*)                       AS n_measurements,
           ROUND(MIN(value_as_number), 2) AS min_val,
           ROUND(AVG(value_as_number), 2) AS mean_val,
           ROUND(MAX(value_as_number), 2) AS max_val
    FROM measurement
    WHERE measurement_concept_id = %s AND value_as_number IS NOT NULL
    GROUP BY 1 ORDER BY n_measurements DESC LIMIT 10
  ", cid)) |> kable() |> print()

  vals <- dbGetQuery(con, sprintf("
    SELECT value_as_number AS value
    FROM measurement
    WHERE measurement_concept_id = %s AND value_as_number IS NOT NULL
  ", cid))

  print(
    ggplot(vals, aes(x = value)) +
      geom_histogram(bins = 30, fill = "#4C9BE8", color = "white") +
      labs(title = sprintf("Value Distribution — Concept %s", cid), x = "Value", y = "Count") +
      theme_omop()
  )
}