# Body Performance Analysis

Exploratory data analysis in R of the [Body Performance](https://www.kaggle.com/datasets/kukuroo3/body-performance-data) dataset (~13k people, age, body measurements, fitness tests, and performance class A–D).

## Files
- `bodyPerformance.csv`: the dataset
- `01_cleaning.R`: import, rename columns, remove impossible values
- `02_overview.R`: summary, gender, class
- `03_height.R`: height
- `04_weight_fat.R`: weight and body fat
- `05_blood_pressure.R`: diastolic and systolic blood pressure
- `06_performance.R`: grip force, flexibility, sit-ups, broad jump
- `grip_force_Bohannon2019.pdf`: reference for grip force
- `old/`: old drafts

## Run
Open `BodyPerformance_kesha.Rproj` in RStudio, then run any script. Scripts 02 to 06 run `01_cleaning.R` by themselves. Only base R is needed.

citation for filtering criteria: Lu Y, Huang C, Mahajan S, Schulz WL, Nasir K, Spatz ES, Krumholz HM. Leveraging the Electronic Health Records for Population Health: A Case Study of Patients With Markedly Elevated Blood Pressure. J Am Heart Assoc. 2020 Apr 7;9(7):e015033. doi: 10.1161/JAHA.119.015033. Epub 2020 Mar 23. PMID: 32200730; PMCID: PMC7428633.
