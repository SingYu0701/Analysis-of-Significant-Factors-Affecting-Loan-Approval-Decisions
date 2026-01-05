# Analysis-of-Significant-Factors-Affecting-Loan-Approval-Decisions
Final group report of The Analysis of Categorical Data, Jun 2023 @ NCKU Statistics

![Made with R](https://img.shields.io/badge/Made%20with-R-276DC3?logo=r&logoColor=white)

## Background and Motivation

In modern financial planning, loans have become an essential instrument for both individuals and households. However, loan approval is subject to strict screening processes, and not all applicants receive approval. Understanding which applicant characteristics significantly influence loan approval outcomes is therefore crucial for improving **financial decision-making and risk assessment**.

This project aims to identify the key determinants of loan approval decisions using classical categorical data analysis techniques. Instead of focusing solely on predictive performance, this study emphasizes statistical inference, interpretability, and model validity, making it suitable for policy analysis and financial decision support.

## Data Description

The analysis is based on a publicly available loan dataset obtained from Kaggle:

- Source: Kaggle – Loan Approval Dataset

- Original Provider: Referenced as Statista (exact collection methodology not documented)

- Data time: March 2023

- Observations: 614 loan applications (after preprocessing)

Due to limited metadata, the dataset’s temporal and geographic coverage are unknown. Nevertheless, the dataset provides a comprehensive set of demographic, financial, and regional variables suitable for categorical modeling.

## Variables
**Response Variable**

- Loan Status (Y / N)

Indicates whether a loan application was approved.

**Explanatory Variables**

- Gender: Applicant’s gender

- Marital Status: Married or unmarried

- Education Level: Graduate or not

- Employment Type: Self-employed or not

- Applicant Income: Monthly income of the applicant

- Loan Amount: Requested loan amount

- Credit History: Presence of prior credit history

- Residential Area: Urban, semi-urban, or rural

Variables with ambiguous definitions or excessive missing values (e.g., dependents, co-applicant income, loan term) were excluded to ensure model reliability.

## Data Preprocessing

- Missing values were handled using k-Nearest Neighbors (kNN) imputation.

- Categorical variables were converted into factor variables for statistical modeling.

- Continuous variables were assessed separately to avoid inappropriate distributional assumptions.

This preprocessing strategy ensured data completeness while preserving the original categorical structure of the dataset.

## Statistical Methodology

The analytical framework consists of four main stages:

### Difference and Association Analysis

Pearson’s Chi-square tests were applied to evaluate the association between categorical predictors and loan approval status.

Mann–Whitney U tests were used for continuous variables due to uncertain distributional properties.

This step serves as a variable screening process grounded in statistical hypothesis testing.
<img width="864" height="965" alt="圖片" src="https://github.com/user-attachments/assets/dfb44ff7-f8fa-4ffd-91c8-43deaecddb7d" />
<img width="837" height="609" alt="圖片" src="https://github.com/user-attachments/assets/1d8e7458-e292-4e91-a179-4adc284bbe05" />
<img width="1062" height="867" alt="圖片" src="https://github.com/user-attachments/assets/6453faa1-75e4-4e67-b649-db79b4f204ca" />

### Logistic Regression Modeling

Based on significant results from the difference analysis, logistic regression models were constructed to estimate approval probabilities:
<img width="588" height="48" alt="圖片" src="https://github.com/user-attachments/assets/9d59e6a0-7596-462b-a394-f806d47dd2c6" />

Models including interaction terms were also considered to examine whether joint effects between predictors improved explanatory power.

## Model Selection and Validation

- Likelihood Ratio Tests (LRT) were used to compare nested models with and without interaction effects.

- Stepwise AIC selection was applied to identify the most parsimonious model with optimal goodness-of-fit.

- Interaction effects were found to be statistically insignificant and therefore excluded from the final model.

## Performance Evaluation

The final model was evaluated using:

- Confusion matrix

- Accuracy, sensitivity, and specificity

- Receiver Operating Characteristic (ROC) curve and Area Under the Curve (AUC)

## Key Results

The final selected logistic regression model identifies three statistically significant predictors:

- Marital Status

- Credit History

- Residential Area
<img width="1015" height="368" alt="圖片" src="https://github.com/user-attachments/assets/53454475-cb46-4658-9ffd-e3f17b327176" />
<img width="1078" height="650" alt="圖片" src="https://github.com/user-attachments/assets/9c36037b-3fa4-4aed-ae08-f6e09c2524e2" />

Key insights include:

**Applicants with an established credit history have a substantially higher likelihood of loan approval.**

**Married applicants show consistently higher approval rates than unmarried applicants.**

**Semi-urban residents exhibit higher approval probabilities compared to urban and rural applicants.**

These findings highlight the importance of both personal financial credibility and regional characteristics in loan approval decisions.

## Model Performance
<img width="1085" height="1125" alt="圖片" src="https://github.com/user-attachments/assets/8f1cce9b-ffb2-40dc-937f-c4dc79b4c0bf" />
<img width="995" height="312" alt="圖片" src="https://github.com/user-attachments/assets/cb8c33a5-9b26-4f05-95a6-7f2b7a9f8599" />

Accuracy: 82%

Sensitivity (Recall): 98.55%

Specificity: 45.16%

AUC: 0.79
<img width="1032" height="905" alt="圖片" src="https://github.com/user-attachments/assets/e82afc5e-1991-40d4-bc81-d39875cfd2a1" />

The predicted approval counts closely align with observed values, indicating that the model achieves a strong balance between interpretability and predictive accuracy.

## Tools and Technologies

Programming Language: R

Statistical Packages:

- VIM – Missing data imputation

- MASS – Stepwise AIC model selection

- car – Regression diagnostics

- pROC – ROC and AUC analysis

## Academic Context and Limitations

This project was conducted as part of a Categorical Data Analysis course and focuses on methodological rigor rather than real-world deployment. Limitations include incomplete dataset documentation and potential sampling bias.

Nevertheless, the study demonstrates how classical statistical techniques can be effectively applied to real-world financial data to generate interpretable and actionable insights.
