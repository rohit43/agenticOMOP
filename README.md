# agenticOMOP

Turn raw OMOP EHR data into a beautiful, self-contained HTML report.

![R](https://img.shields.io/badge/R-4.0%2B-276DC3?logo=r&logoColor=white)
![DuckDB](https://img.shields.io/badge/DuckDB-powered-FFC832?logo=duckdb&logoColor=black)
![Quarto](https://img.shields.io/badge/Quarto-report-4A90D9)
![License](https://img.shields.io/badge/license-MIT-green)

---

## What it does

This project reads standard [OMOP CDM](https://ohdsi.github.io/CommonDataModel/) CSV files and generates a single, fully self-contained HTML report covering:

- **Data quality checks** — flags bad ages, missing IDs, future-dated events, and out-of-period records
- **Demographics** — age stats, age histogram, gender distribution
- **Conditions** — occurrence counts, era lengths, top 10 bar chart
- **Drugs** — exposure counts, era stats, top 10 bar chart
- **Visits** — visit types, length-of-stay distribution
- **Clinical** — measurement and observation summaries
- **Patient utilization** — per-patient visit summaries and histograms
- **Lab trends** — top 5 measurement concepts with value distributions

All plots are embedded as base64 — no external dependencies, just one `.html` file you can share anywhere.

---

## Quick Start

### 1. Clone the repo

```bash
git clone https://github.com/rohit43/agenticOMOP.git
cd agenticOMOP
```

### 2. Add your OMOP data

Drop your OMOP CSV files into the `data/` folder. The following tables are expected:

```
data/
├── person.csv
├── observation_period.csv
├── condition_occurrence.csv
├── condition_era.csv
├── drug_exposure.csv
├── drug_era.csv
├── visit_occurrence.csv
├── procedure_occurrence.csv
├── measurement.csv
└── observation.csv
```

> [!WARNING]
> **Data Compliance Notice**  
> This project is intended for properly authorized data only.  
> You are responsible for ensuring compliance with HIPAA, GDPR, and institutional policies before using real patient data.

### 3. Install dependencies

**R packages:**
```r
install.packages(c("duckdb", "dplyr", "ggplot2", "knitr", "quarto"))
```

**Quarto** (if not already installed):
```bash
# macOS
brew install quarto

# Or download from https://quarto.org/docs/get-started/
```

### 4. Generate the report

The easiest way to run this project is with [Claude Code](https://claude.ai/code). Open the project folder in Claude Code and type:

```
Generate OMOP Report
```

That single prompt is all you need. Claude Code reads the instructions in `CLAUDE.md` and handles everything — checking row counts, writing the Quarto document, applying QC rules, and rendering the final output to `outputs/summary_report.html`.

---

## Project Structure

```
agenticOMOP/
├── data/                      # Your OMOP CSV files go here
├── outputs/                   # Generated report lands here
├── report.qmd                 # Main Quarto report document
├── scripts/
│   ├── db.r                   # DuckDB connection + shared theme
│   ├── demographics.r         # Demographics section
│   ├── conditions.r           # Conditions section
│   ├── drugs.r                # Drugs section
│   ├── visits.r               # Visits section
│   ├── clinical.r             # Clinical measurements section
│   ├── pt_utilization.r       # Patient utilization section
│   └── pt_labs.r              # Lab trends section
└── CLAUDE.md                  # Instructions for Claude Code
```

---

## Data Quality Checks

Before any analysis, the report applies these QC filters and shows you exactly what was excluded:

| Check | What it catches |
|---|---|
| Age out of range | Patients with age < 0 or > 100 |
| Missing identifiers | NULL `person_id` or key date fields |
| Future-dated events | Records dated after today |
| Negative-length eras | Eras where end date < start date |
| Out-of-period events | Events outside a patient's observation window |

The QC section displays a summary table with excluded record counts in bold so problems are immediately visible.

---

## The Claude Code Workflow

This project is designed to be driven by [Claude Code](https://claude.ai/code). The `CLAUDE.md` file contains detailed instructions that tell Claude exactly how to build and render the report — including performance rules, QC logic, and section structure.

To use it, open the project in Claude Code and type:

```
Generate OMOP Report
```

You can extend the project the same way. Want a new section or a different chart? Describe it in plain English and Claude Code handles the implementation.

---

## Contributing

Contributions are welcome. Some ideas for extensions:

- Procedure occurrence section
- Concept name lookups via OMOP vocabulary tables
- Interactive plots with `plotly`
- Support for database backends (Postgres, BigQuery) in addition to CSV
- Parameterized report (date range, cohort filters)

Please open an issue first to discuss larger changes.

---

## License

MIT — see [LICENSE](LICENSE) for details.

---

## Acknowledgements

- [OHDSI](https://www.ohdsi.org/) for the OMOP Common Data Model
- [DuckDB](https://duckdb.org/) for making in-process analytics fast and frictionless
- [Quarto](https://quarto.org/) for beautiful, reproducible documents