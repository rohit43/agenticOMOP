dbGetQuery(con, "
  SELECT COUNT(*)                               AS total_measurements,
         COUNT(DISTINCT measurement_concept_id) AS unique_types,
         COUNT(DISTINCT person_id)              AS patients,
         ROUND(AVG(CASE WHEN value_as_number IS NOT NULL
                        THEN 1.0 ELSE 0 END) * 100, 1) AS pct_with_numeric_value
  FROM measurement
") |> kable()

dbGetQuery(con, "
  SELECT COUNT(*)                               AS total_observations,
         COUNT(DISTINCT observation_concept_id) AS unique_types,
         COUNT(DISTINCT person_id)              AS patients
  FROM observation
") |> kable()