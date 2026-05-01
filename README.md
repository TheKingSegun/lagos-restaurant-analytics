# Lagos Restaurant Analytics & Growth Dashboard

A data analytics project analysing restaurant performance metrics on delivery platforms (Glovo, Chowdeck) in Lagos, Nigeria — covering menu optimisation, order trends, and platform algorithm mechanics.

## Project Overview

Built from real-world experience managing restaurant growth on Glovo, this project models the KPIs and analytical frameworks used to drive order volume, improve menu performance, and track platform visibility metrics.

## Key Analysis Areas
- Menu engineering: contribution margin by item, star/dog/plowhouse/puzzle classification
- Order volume trends: hourly, daily, weekly seasonality patterns
- Platform visibility: rating impact, acceptance rate, prep time benchmarks
- Customer behaviour: reorder rate, basket size, peak hour concentration
- Delivery zone performance: order density by neighbourhood (Lekki, VI, Ikoyi, Surulere)

## Tools & Technologies
| Tool | Purpose |
|------|---------|
| Python (pandas, plotly) | Data processing & visualisation |
| SQL (PostgreSQL) | Data extraction & aggregation |
| Power BI | Executive dashboard |
| Excel | Menu engineering matrix |

## Project Structure
```
lagos-restaurant-analytics/
├── data/                     # Sample anonymised restaurant data
├── notebooks/                # EDA and analysis notebooks
├── sql/                      # SQL queries for platform data extraction
├── dashboard/screenshots/    # Power BI dashboard exports
└── src/                      # Python analysis scripts
```

## Key Findings (Sample Restaurant)
- Top 20% of menu items drive 68% of revenue (Pareto holds)
- Orders peak Friday-Sunday 12-2pm and 7-9pm
- A 0.2 rating increase correlates with ~12% more weekly orders
- Average basket size: NGN 8,400 | Reorder rate: 34%

## Data Sources
- Anonymised restaurant order exports (Glovo/Chowdeck format)
- Platform API documentation
- Nigerian food delivery market reports
