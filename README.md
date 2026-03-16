# 🚦 Road Accident Analytics Dashboard (2021–2022)

An end-to-end data analytics project that transforms 307,000+ road accident records into actionable insights through an interactive Power BI dashboard, validated against MySQL queries and Excel analysis.

---

## 📌 Project Overview

Road safety agencies and transport departments need fast, reliable access to accident trends to allocate resources and reduce casualties. This project delivers a dynamic dashboard that tracks Key Performance Indicators (KPIs) across severity, vehicle type, road type, location, and time — with Year-on-Year (YoY) comparisons for 2021 and 2022.

**Business Questions Answered:**
- How many total casualties occurred this year, and how does that compare to last year?
- Which vehicle types are responsible for the most casualties?
- Are accidents worse on urban or rural roads? During day or night?
- Which road types carry the highest casualty risk?
- What is the monthly trend of casualties across both years?

---

## 📊 Dashboard Preview

![Road Accident Dashboard](Images/Screenshot%202026-02-28%20055626.png)

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| Power BI | Interactive dashboard and data visualisation |
| MySQL | Data validation and business query verification |
| Microsoft Excel 2021 | Initial data exploration and pivot analysis |
| Power Query | Data cleaning and transformation |
| DAX | Custom measures, KPIs, and YoY calculations |

---

## 📁 Dataset

| Property | Detail |
|---|---|
| File format | CSV |
| Rows | 3,07,973 |
| Columns | 21 |
| Period covered | 2021 – 2022 |

**Key fields:** `Accident_Date`, `Accident_Severity`, `Vehicle_Type`, `Road_Type`, `Urban_or_Rural_Area`, `Light_Conditions`, `Number_of_Casualties`, `Latitude`, `Longitude`

---

## ✅ KPI Requirements

### Primary KPIs
- Total Casualties for Current Year (CY) and YoY growth
- Total Accidents for Current Year and YoY growth

### Primary KPIs by Severity
- Fatal Casualties — CY value and YoY growth
- Serious Casualties — CY value and YoY growth
- Slight Casualties — CY value and YoY growth

### Secondary KPIs
- Total Casualties by Vehicle Type (CY)
- Monthly Casualty Trend — CY vs Previous Year (PY)
- Casualties by Road Type (CY)
- Casualties by Area: Urban vs Rural (CY)
- Casualties by Light Condition: Day vs Night (CY)
- Casualties and Accidents by Geographic Location

---

## 🔄 Project Workflow

1. **Requirement Gathering** — Defined KPIs with stakeholder input
2. **Raw Data Overview** — Inspected 21 fields across 307K records
3. **Data Cleaning** — Handled nulls, standardised date formats, corrected categorical inconsistencies in Power Query
4. **Data Modelling** — Built a Calendar Date Table; established relationships between fact and dimension tables
5. **DAX Measures** — Created CY/PY casualty measures, YoY % change, severity breakdowns
6. **Dashboard Design** — Custom background built in PowerPoint; KPI cards, line charts, donut charts, map visual
7. **SQL Validation** — All major KPI values cross-verified with MySQL queries (see `road_accident_queries.sql`)
8. **Insights & Reporting** — Documented key findings for stakeholder review

---

## 💡 Key Insights

- **Slight severity** accidents account for the majority of casualties (~84%), but **fatal accidents** show a disproportionate concentration on single-carriageway roads.
- **Cars** are the vehicle type with the highest casualty involvement by a significant margin.
- **Urban areas** record more total casualties, but **rural roads** have a higher fatality rate per accident.
- Casualties **peak in October–November** each year, suggesting weather and reduced daylight as contributing factors.
- **Daytime** accidents are more frequent, but **night-time** accidents carry higher severity on average.

---

## 🗃️ Repository Structure

```
Road-Accident-DashBoard/
│
├── Road accident dashboard.pbix     # Power BI dashboard file
├── road_accident_queries.sql         # MySQL validation queries
├── Images/
│   └── Screenshot 2026-02-28 055626.png
├── README.md
└── LICENSE
```

---

## ⚙️ How to Use

### Power BI Dashboard
1. Download `Road accident dashboard.pbix`
2. Open in Power BI Desktop (latest version recommended)
3. If prompted, reconnect to the data source (CSV file)
4. Use the slicers (Year, Severity, Area Type) to interact with the dashboard

### MySQL Queries
1. Import the CSV dataset into MySQL Workbench
2. Open `road_accident_queries.sql`
3. Run queries section by section — results should match Power BI KPI values

## What's in the SQL file:

Section 1–2: Primary KPIs — total casualties, YoY growth, severity breakdown. These directly validate your Power BI numbers.
Section 3–6: Secondary KPIs — vehicle type, monthly trends, road type, urban/rural, day/night splits.
Section 7: Advanced queries using WINDOW FUNCTIONS — LAG() for month-over-month change, RANK(), DENSE_RANK(), CTEs for Pareto analysis. This is what separates you from tutorial-level candidates at Deloitte/Amazon screening.
Section 8: Data quality checks — null detection, duplicate validation, date range verification. Shows professional data engineering awareness.

---

## 👥 Stakeholders

Ministry of Transport · Road Transport Department · Police Force · Emergency Services · Road Safety Corps · Traffic Management Agencies

---

## 🔮 Future Enhancements

- [ ] Deploy dashboard to Power BI Service with scheduled data refresh
- [ ] Add predictive model for accident hotspot forecasting
- [ ] Integrate real-time data feed via API
- [ ] Expand to 2023–2024 data for multi-year trend analysis

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
