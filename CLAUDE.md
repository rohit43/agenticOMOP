# OMOP Data Summarizer

## What this project does
Summarizes OMOP synthetic EHR data from CSV files into a self-contained HTML report.

## Data
All OMOP CSVs are in `data/`. Tables:
person, observation_period, condition_occurrence, condition_era,
drug_exposure, drug_era, visit_occurrence, procedure_occurrence,
measurement, observation

## When asked to generate the report

### 1. Check row counts first
Before writing the report, run this to understand data size:
```bash
Rscript -e "
library(duckdb)
con <- dbConnect(duckdb())
tables <- c('person','observation_period','condition_occurrence','condition_era',
            'drug_exposure','drug_era','visit_occurrence','procedure_occurrence',
            'measurement','observation')
for(t in tables) {
  dbExecute(con, sprintf('CREATE VIEW %s AS SELECT * FROM read_csv_auto(\"data/%s.csv\")', t, t))
  n <- dbGetQuery(con, sprintf('SELECT COUNT(*) AS n FROM %s', t))[[1]]
  cat(t, ':', n, '\n')
}
"
```

### 2. Write report.qmd
Write a Quarto document with these performance rules:
- **Tables**: use only `knitr::kable()` — do NOT use gt or kableExtra (they are slow)
- **Plots**: if any table has > 50k rows, sample down to 50k before plotting using DuckDB TABLESAMPLE or LIMIT
- **Quarto header**: set `execute: cache: true` so chunks are cached after first run
- **Chunk options**: set `echo: false`, `warning: false`, `message: false` globally
- **One DuckDB connection**: open once in the setup chunk, reuse throughout — do not reconnect per chunk
- **Suppress dbExecute output**: always wrap `dbExecute()` calls in `invisible()` — e.g. `invisible(dbExecute(con, sql))` — otherwise Quarto prints `[1] 0` for every DDL statement

### 3. QC rules (apply before all analysis)
Create clean views that exclude:
- Patients with age < 0 or > 100
- Records with missing person_id or key date fields
- Future-dated events (after today)
- Negative-length eras
- Events outside a patient's observation period

### 4. Report sections
- QC summary table (kable, failed counts in bold)
- Dataset summary table (raw / excluded / clean per table)
- Demographics: age stats table + age histogram + gender bar
- Conditions: counts table + top 10 bar chart
- Drugs: counts table + top 10 bar chart
- Visits: counts table + visit types bar + LOS histogram
- Clinical: measurements + observations counts table
- Patient utilization: joined summary table + visits-per-patient histogram
- Lab trends: top 5 measurement concepts + value histograms

### 5. Render
```bash
quarto render report.qmd --to html --output outputs/summary_report.html
```

### 6. If quarto not installed
```bash
brew install quarto
```

## Output
`outputs/summary_report.html` — self-contained, plots embedded as base64

## Performance targets
- Should render in under 60 seconds
- If it exceeds that, the likely cause is table rendering — confirm only kable() is used