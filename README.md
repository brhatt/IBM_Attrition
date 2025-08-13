# Employee Attrition — SQL • Python • Tableau

**Live dashboard:** https://public.tableau.com/app/profile/brhat.bg/viz/main_17550130484860/D_Attrition

Lean, end‑to‑end analysis of employee attrition with 6 SQL cuts, an interpretable Logistic Regression, and a compact Tableau dashboard.

---

## TL;DR — What this shows
- Overall attrition ≈ **16.1%**.
- **Top risk drivers (odds ratios):**
  - **JobRole: Laboratory Technician ~2.25×**
  - **OverTime: Yes ~2.17×**
  - **BusinessTravel: Travel_Frequently ~2.06×**
- **Protective drivers:**
  - **TotalWorkingYears OR ~0.52**
  - **YearsWithCurrManager OR ~0.63**
  - **EducationField: Life Sciences OR ~0.61**
- Model: Logistic Regression with class weighting; hold‑out **ROC‑AUC ≈ 0.80**.

Interpretation: **OR > 1** increases odds of leaving; **OR < 1** decreases odds, holding other features constant.

---

## Project map
```
IBM_Attrition/
├─ README.md
├─ requirements.txt
├─ gitignore
├─ attrition.sqlite
├─ data/
│  └─ ibm_hr_attrition.xlsx
├─ notebook/
│  ├─ attrition_master.ipynb
│  └─ model_coefficients.csv
├─ sql/
│  ├─ queries.sql
│  └─ sql_outputs/
│     ├─ 01_overall.csv
│     ├─ 02_by_department.csv
│     ├─ 03_by_jobrole.csv
│     ├─ 04_by_travel.csv
│     ├─ 05_overtime_dept.csv
│     └─ 06_years_curve.csv
└─ assets/
   ├─ Attrition rates by tenure in company.png
   └─ Attrition rates by top 5 jobroles.png
```
> The SQLite DB file (`attrition.sqlite`)can be made locally, create it by instructions (below).

---

## Reproduce locally

### 0) Environment
```bash
# from attrition_project/
python3 -m venv .venv
source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install -U pip
pip install -r requirements.txt
```

### 1) SQL cuts (6 queries)
Ready‑made CSVs live in `sql/sql_outputs/`. To regenerate:

**Create the SQLite DB (only if you don’t already have one):**
```bash
sqlite3 attrition.sqlite
-- inside sqlite prompt:
.mode csv
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
  Age INTEGER, Attrition TEXT, BusinessTravel TEXT, DailyRate INTEGER, Department TEXT,
  DistanceFromHome INTEGER, Education INTEGER, EducationField TEXT, EmployeeCount INTEGER,
  EmployeeNumber INTEGER, EnvironmentSatisfaction INTEGER, Gender TEXT, HourlyRate INTEGER,
  JobInvolvement INTEGER, JobLevel INTEGER, JobRole TEXT, JobSatisfaction INTEGER,
  MaritalStatus TEXT, MonthlyIncome INTEGER, MonthlyRate INTEGER, NumCompaniesWorked INTEGER,
  Over18 TEXT, OverTime TEXT, PercentSalaryHike INTEGER, PerformanceRating INTEGER,
  RelationshipSatisfaction INTEGER, StandardHours INTEGER, StockOptionLevel INTEGER,
  TotalWorkingYears INTEGER, TrainingTimesLastYear INTEGER, WorkLifeBalance INTEGER,
  YearsAtCompany INTEGER, YearsInCurrentRole INTEGER, YearsSinceLastPromotion INTEGER,
  YearsWithCurrManager INTEGER
);
.import data/ibm_hr_attrition.csv employees     -- export XLSX to CSV if needed
DELETE FROM employees WHERE Attrition='Attrition';
.quit
```

**Run the queries:**
```bash
cd sql
sqlite3 ../attrition.sqlite ".read queries.sql"
cd ..
```
Outputs refresh in `sql/sql_outputs/`.

### 2) Model (Logistic Regression)
Open `notebook/attrition_master.ipynb` and run all cells. It writes `notebook/model_coefficients.csv` and prints the **Top ↑ risk** and **Top protective** drivers.

**Reference metrics:** Accuracy **0.7449** • Precision **0.3372** • Recall **0.6170** • F1 **0.4361** • ROC‑AUC **0.7958**

---

## Dashboard (Tableau)
Key views: Dept/Role ranking, OverTime×Department, tenure curve (years with **<10 employees** filtered to avoid noisy outliers).  
**Live:** https://public.tableau.com/app/profile/brhat.bg/viz/main_17550130484860/D_Attrition

---

## Modeling notes
- One‑hot encoding; dataset has no missing values.
- 80/20 stratified split on `Attrition`; `class_weight='balanced'`; default threshold 0.5.
- Focused on interpretability and actionability over squeezing extra accuracy.

---

## Talk track 
- “Attrition ~16%. Overtime and frequent travel roughly **double** odds of leaving; Lab Tech role ~**2.25×**.”
- “Experience and manager continuity are protective.”
- “Lean Approach: 6 SQL cuts → one interpretable model → one compact dashboard.”

---

## Requirements
```
pandas
numpy
scikit-learn
matplotlib
seaborn
openpyxl
```
