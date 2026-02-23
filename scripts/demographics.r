dbGetQuery(con, "
  SELECT COUNT(*)                            AS total_patients,
         ROUND(AVG(2020 - year_of_birth), 1) AS mean_age,
         MEDIAN(2020 - year_of_birth)        AS median_age,
         MIN(2020 - year_of_birth)           AS min_age,
         MAX(2020 - year_of_birth)           AS max_age
  FROM person
") |> kable()

dbGetQuery(con, "
  SELECT MIN(observation_period_start_date)  AS earliest,
         MAX(observation_period_end_date)    AS latest,
         ROUND(AVG(DATEDIFF('day',
           observation_period_start_date,
           observation_period_end_date)), 1) AS mean_obs_days
  FROM observation_period
") |> kable()

# Age histogram
ages <- dbGetQuery(con, "SELECT (2020 - year_of_birth) AS age FROM person")
ggplot(ages, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "#4C9BE8", color = "white") +
  labs(title = "Age Distribution", x = "Age (years)", y = "Count") +
  theme_omop()

# Gender bar
gender <- dbGetQuery(con, "
  SELECT CAST(gender_concept_id AS VARCHAR) AS gender, COUNT(*) AS n
  FROM person GROUP BY 1 ORDER BY 2 DESC
")
ggplot(gender, aes(x = reorder(gender, -n), y = n, fill = gender)) +
  geom_col(show.legend = FALSE) +
  scale_fill_manual(values = c("#4C9BE8", "#F4845F", "#6BCB77", "#FFD166")) +
  labs(title = "Gender Distribution", x = "Gender Concept ID", y = "Count") +
  theme_omop()