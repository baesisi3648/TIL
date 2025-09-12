"""
[USER QUESTION]
select * from dataset;


"""

import pandas as pd

# Assuming the dataset is in a CSV file named 'dataset.csv'
dataset = pd.read_csv('dataset.csv')

# Display the entire dataset
print(dataset)