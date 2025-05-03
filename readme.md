# Statistical Analysis of Gas Turbine Emissions and Predictive Maintenance Data

This project performs statistical analysis on two datasets:
1.  Gas Turbine CO and NOx Emission Data Set
2.  AI4I 2020 Predictive Maintenance Dataset

The analysis explores relationships between variables, predicts emissions, investigates machine failure patterns, and applies various statistical techniques using R.

---

## Table of Contents

*   [Project Goal](#project-goal)
*   [Datasets](#datasets)
*   [Methodology](#methodology)
*   [Key Findings](#key-findings)
    *   [Gas Turbine Emissions](#gas-turbine-emissions)
    *   [Predictive Maintenance (AI4I)](#predictive-maintenance-ai4i)
*   [Technology Stack](#technology-stack)
*   [Getting Started](#getting-started)
    *   [Prerequisites](#prerequisites)
    *   [Installation](#installation)
*   [Usage](#usage)
*   [Team](#team)
*   [Acknowledgments](#acknowledgments)

---

## Project Goal

This project aims to:

1.  **Emissions Prediction:** Assess how environmental and operational factors influence CO and NOx emissions in gas turbines and develop regression models.
2.  **Failure Analysis:** Analyze relationships between product quality, operational parameters (like rotational speed, torque, temperature), and machine failure rates in a predictive maintenance context.
3.  **Statistical Relationships:** Investigate correlations, test model assumptions (normality, linearity, homoscedasticity), and apply hypothesis testing (ANOVA, T-tests, Chi-square) to understand variable interactions.
4.  **Data Optimization:** Address the impact of outliers and non-linear relationships on model reliability through data cleaning and appropriate statistical test selection.

---

## Datasets

1.  **Gas Turbine CO and NOx Emission Data Set:**
    *   **Source:** UCI Machine Learning Repository ([Link](https://archive.ics.uci.edu/ml/datasets/Gas+Turbine+CO+and+NOx+Emission+Data+Set))
    *   **Description:** Contains 36,733 instances (aggregated hourly) of 11 sensor measures from a gas turbine in Turkey (2011-2015). Data from 2015 (7,384 observations) was primarily used for regression in the R script.
    *   **Key Variables:** Ambient Temperature (AT), Ambient Pressure (AP), Ambient Humidity (AH), Air Filter Difference Pressure (AFDP), Gas Turbine Exhaust Pressure (GTEP), Turbine Inlet Temperature (TIT), Turbine After Temperature (TAT), Compressor Discharge Pressure (CDP), Turbine Energy Yield (TEY), Carbon Monoxide (CO), Nitrogen Oxides (NOx).

2.  **AI4I 2020 Predictive Maintenance Dataset:**
    *   **Source:** UCI Machine Learning Repository ([Link](https://archive.ics.uci.edu/ml/datasets/AI4I+2020+Predictive+Maintenance+Dataset))
    *   **Description:** A synthetic dataset reflecting real predictive maintenance scenarios with 10,000 data points and 14 features.
    *   **Key Variables:** Product ID, Type (L, M, H quality), Air temperature [K], Process temperature [K], Rotational speed [rpm], Torque [Nm], Tool wear [min], Machine failure (Target), and specific failure modes (TWF, HDF, PWF, OSF, RNF).

---

## Methodology

The analysis was performed using the R programming language and involved the following steps:

1.  **Data Loading & Merging:** Loading individual yearly datasets (Gas Turbine) and the AI4I dataset. Merging yearly Gas Turbine data.
2.  **Data Cleaning & Preparation:**
    *   Checking for missing values (none found).
    *   Detecting outliers using boxplots on scaled data.
    *   Imputing outliers using k-Nearest Neighbors (kNN) imputation from the `VIM` package.
    *   Renaming columns for clarity (AI4I dataset).
3.  **Exploratory Data Analysis (EDA):**
    *   Visualizing variable distributions using histograms.
    *   Examining relationships between variables using scatter plots.
4.  **Statistical Analysis (Gas Turbine):**
    *   Testing variable normality (Skewness, Kurtosis, Kolmogorov-Smirnov test). Most variables were found to be non-normal.
    *   Correlation analysis using Spearman correlation (due to non-normality) to identify relationships and multicollinearity.
    *   Linear Regression (`lm`) with stepwise variable selection (`stepAIC` from `MASS`) to model CO emissions.
    *   Residual analysis (histogram, QQ-plot, Skewness, Kurtosis) to check model assumptions.
5.  **Statistical Analysis (AI4I):**
    *   Testing association between categorical variables (Type vs. Machine Failure) using Chi-Square Test (`chisq.test`).
    *   Testing normality of Rotational Speed across different groups (Type, Machine Failure, TWF) using Kolmogorov-Smirnov test (`ks.test`).
    *   Comparing Rotational Speed across groups using appropriate tests based on normality and number of groups:
        *   Kruskal-Wallis test (`kruskal.test`) for Type (3 groups, non-normal).
        *   Wilcoxon-Mann-Whitney test (`wilcox.test`) for Machine Failure (2 groups, non-normal).
        *   Bartlett test (`bartlett.test`) for homogeneity of variances and T-test (`t.test`) / Wilcoxon test for Tool Wear Failure (TWF) (2 groups, mixed normality results).

---

## Key Findings

### Gas Turbine Emissions

*   CO emissions show negative correlations with AFDP, GTEP, TIT, and CDP. TIT has the strongest negative correlation with CO.
*   NOx emissions have a strong negative correlation with Ambient Temperature (AT).
*   Significant multicollinearity exists between GTEP, TIT, TEY, and CDP. Variables (CDP, TEY) were removed to mitigate this in the correlation analysis stage shown in the R script comments.
*   The final stepwise linear regression model for CO emissions explained approximately 54% of the variance (*Note: R-squared value might differ slightly based on exact stepwise implementation shown in presentation vs script*). Key predictors included AP, AH, AFDP, GTEP, TIT, TAT, and NOX (AT was removed by stepwise).
*   Outlier imputation was crucial for obtaining more stable and interpretable results, although it lowered the R-squared compared to a model potentially influenced by extreme values.

### Predictive Maintenance (AI4I)

*   Product Type (L, M, H) has a statistically significant association with Machine Failure (Chi-Square p < 0.05).
*   Rotational Speed does not follow a normal distribution within different Type categories or Machine Failure categories.
*   There is **no** statistically significant difference in Rotational Speed across different Product Types (Kruskal-Wallis p > 0.05).
*   There **is** a statistically significant difference in Rotational Speed between machines that experienced failure and those that did not (Wilcoxon p < 0.05).
*   There is **no** statistically significant difference in Rotational Speed based on Tool Wear Failure (TWF) (T-test/Wilcoxon p > 0.05).

---

## Technology Stack

*   **Language:** R
*   **Key R Packages:**
    *   `corrplot`: For visualizing correlation matrices.
    *   `VIM`: For kNN outlier imputation.
    *   `dplyr`: Data manipulation (implicitly used via dependencies or could be added).
    *   `naniar`: For visualizing missing data.
    *   `MASS`: For stepwise regression (`stepAIC`).
    *   `e1071`: For calculating skewness and kurtosis.
    *   Base R functions were used extensively for plotting, statistical tests, and data handling.

---

## Getting Started

### Prerequisites

*   R: [Download R](https://cran.r-project.org/)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/skander-kechaou/Gas-Turbine-Statistical-Analysis-R-Project.git
    cd Gas-Turbine-Statistical-Analysis-R-Project
    ```
2.  **Obtain Data:**
    *   The data should be present in the `data/` folder.

---

## Usage

1.  Open the R script `scripts/statistical_analysis.R` in R.
2.  Ensure your working directory is set to the root of the project folder (e.g., using `setwd("path/to/your-project-name")` in the console, or by opening the project via an RStudio `.Rproj` file if you create one).
3.  Run the script line by line or source the entire file (`source("scripts/statistical_analysis.R")`) to perform the analysis.
4.  View the console output for statistical test results and model summaries. Plots are saved to the `test_images/`.

---

## Team

*   Donia Ben Othman
*   Yosr Lassoued
*   Skander Kechaou
*   Rania Souei
*   Arij Mahouechi
*   Youssef Ressaissi


---

## Acknowledgments

*   Data sourced from the UCI Machine Learning Repository.
*   Analysis performed using the R programming language and its packages.
*   Presentation template by Slidesgo.
*   SPSS was used for comparative analysis outlined in the accompanying report.

---
