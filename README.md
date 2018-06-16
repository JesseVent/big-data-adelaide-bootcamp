## Big Data Adelaide Bootcamp
> The Audit Kaggle Competition
> 
Available at [Kaggle Competition - Adelaide Bootcamp- Audit](https://www.kaggle.com/c/big-data-adelaide-bootcamp/)

## Overview
Your task here is to use machine learning to predict if an individuals financial affairs are fraudulent or not.
For each ID in the test set, you must predict a 0 or 1 value for the Target variable.

### Description
The audit dataset is an artificially constructed dataset that has some of the characteristics of a true financial audit dataset for modelling productive and non-productive audits of a person's financial statement.

### Expected Outcomes
The audit dataset is used to illustrate binary classification. The target variable is identified as **Target**.

-   A **productive audit** is one which identifies errors or inaccuracies in the information provided by a client.
-   A **non-productive audit** is usually an audit which found all supplied information to be in order.

> Your task is to predict if an individual has provided inaccuracies in their information

The dataset itself is derived from publicly available data (which has nothing to do with audits).

## Competition Scoring
### Metric

Your score is the percentage of individuals you correctly predict. This is known simply as "accuracy”.

### Submission File Format

You should submit a csv file with exactly 9,676 entries plus a header row. Your submission will show an error if you have extra columns (beyond Id and Target) or rows.

The submission file should have exactly 2 columns:

-   Id (sorted in any order)
-   Target (contains your binary predictions: 1 for productive-audit, 0 for non-productive.)

### Sample Submission

    "ID","Target"
    1000466,0
    1001107,0
    1001779,0
    1002020,1
    1002080,1

## Data Overview

The data has been split into two groups:

-   training set (audit_train.csv)
-   test set (audit_test.csv)

The training set should be used to build your machine learning models. For the training set, we provide the target outcome (also known as the “ground truth”) for each individual. Your model will be based on “features” like individual's occupation or income. You can also use feature engineering to create new features.

The test set should be used to see how well your model performs on unseen data. For the test set, we do not provide the ground truth for each individual.

### Data Format

A data frame. In line with data mining terminology we refer to the rows of the data frame (or the observations) as entities. The columns are refered to as variables. The entities represent people in this case. We describe the variables here:

###  Data Dictionary
    ID         - This is a unique identifier for each person.
    Age        - The age.
    Employment - The type of employment.
    Education  - The highest level of education.
    Marital    - Current marital status.
    Occupation - The type of occupation.
    Income     - The amount of income declared.
    Gender     - The persons gender.
    Deductions - Total amount of expenses that a person claims in their financial statement.
    Hours      - The average hours worked on a weekly basis.
    Accounts   - The main country in which the person has most of their money banked.
    Adjustment - This variable records the monetary amount of any adjustment to the person's financial claims as a result of a productive audit.
    Target     - The target variable for modelling (generally for classification modelling).

### Notes
**Adjustment**
This variable, which should not be treated as an input variable, is thus a measure of the size of the risk associated with the person.

**Target**
This is a numeric field of class integer, but limited to 0 and 1, indicating non-productive and productive audits, respectively. Productive audits are those that result in an adjustment being made to a client's financial statement.
