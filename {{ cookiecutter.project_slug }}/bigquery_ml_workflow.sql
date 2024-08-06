/* TODO
Train-Test Split Ratio
Model Type
Declarations for parameters
*/

BEGIN

-- Create a temporary table for the raw data
CREATE TEMP TABLE temp_raw_data AS
SELECT 
    * 
FROM 
    `{{ cookiecutter.bq_project }}.{{ cookiecutter.bq_dataset }}.TODO`;

-- Add any filtering or initial transformations if necessary

-- Preprocess and feature engineering
CREATE TEMP TABLE temp_preprocessed_data AS
SELECT
    -- Add your data preprocessing and feature engineering steps here
    -- Example: 
    --   CAST(feature1 AS NUMERIC) AS feature1,
    --   feature2,
    --   target_column
FROM 
    temp_raw_data;

-- Create training and evaluation datasets
CREATE TEMP TABLE temp_training_data AS
SELECT
    *
FROM
    temp_preprocessed_data
WHERE
    MOD(ABS(FARM_FINGERPRINT(CAST(id AS STRING))), 10) < 8;

CREATE TEMP TABLE temp_evaluation_data AS
SELECT
    *
FROM
    temp_preprocessed_data
WHERE
    MOD(ABS(FARM_FINGERPRINT(CAST(id AS STRING))), 10) >= 8;

-- Create and train the machine learning model
CREATE OR REPLACE MODEL `{{ cookiecutter.bq_project }}.{{ cookiecutter.bq_dataset }}.your_model`
OPTIONS(model_type='logistic_reg', input_label_cols=['target_column']) AS
SELECT
    *
FROM
    temp_training_data;

-- Evaluate the model
CREATE TEMP TABLE temp_model_evaluation AS
SELECT
    *
FROM
    ML.EVALUATE(MODEL `{{ cookiecutter.bq_project }}.{{ cookiecutter.bq_dataset }}.{{ cookiecutter.bq_model }}`, TABLE temp_evaluation_data);

/* TODO Make into export */
-- Final output: Select results from the model evaluation
SELECT * FROM temp_model_evaluation;

END
