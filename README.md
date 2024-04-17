# Financial Distress Prediction

## Project Description
This R-based project utilizes logistic regression to predict financial distress in companies. It incorporates various data sampling techniques, such as under-sampling, over-sampling (with ROSE and `ovun.sample`), and SMOTE, to improve the accuracy and robustness of the models. Detailed evaluations using confusion matrices and calculating F1 scores highlight the effectiveness of each sampling approach, making this an invaluable tool for financial risk management.

## Features
- **Data Preprocessing**: Handles missing values and removes irrelevant features to prepare data for modeling.
- **Sampling Techniques**: Implements under-sampling, over-sampling, and SMOTE to address class imbalance in the dataset.
- **Predictive Modeling**: Develops logistic regression models for each type of sampled dataset.
- **Performance Evaluation**: Assesses model performance using confusion matrices and F1 scores.
- **Visualization**: Creates visual representations of model performance through confusion matrices.

## Installation
Ensure R is installed on your machine, which you can download from [CRAN](https://cran.r-project.org/). Install the required R packages by running the following command in your R environment:
```R
install.packages(c("caretEnsemble", "ROSE", "caret", "tidyr", "magrittr", "DMwR2", "smotefamily", "tidyverse", "DataExplorer", "ggcorrplot", "psych", "dplyr", "randomForest", "pROC", "knitr"))

## Usage
Follow these steps to set up and run the project:
1. Clone this repository to your local machine.
2. Make sure the dataset `Financial_Distress.csv` is available in your project directory, or update the dataset path in the script as necessary.
3. Open the R script `Project1.R` in an R environment (such as RStudio).
4. Execute the script to perform the analysis.

## Code Overview
- **Libraries**: Loads all necessary R libraries needed for data manipulation, modeling, and visualization.
- **Data Loading**: Reads the dataset from the specified path.
- **Data Cleaning**: Handles missing data and unnecessary columns are dropped.
- **Feature Engineering**: Converts the target variable into a binary format suitable for logistic regression.
- **Data Sampling**: Applies various sampling techniques to balance the training data.
- **Model Building**: Constructs separate logistic regression models for each sampling dataset.
- **Evaluation**: Evaluates each model using confusion matrices and calculates F1 scores.
- **Visualization**: Plots confusion matrices for each model to visually assess performance.

## Contributing
Contributions are welcome! If you'd like to contribute, please:
- Fork the repository.
- Create a new branch for your features or fixes.
- Commit your changes.
- Push to the branch.
- Submit a pull request.
