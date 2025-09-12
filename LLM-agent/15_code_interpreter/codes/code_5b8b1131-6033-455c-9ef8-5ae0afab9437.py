"""
[USER QUESTION]
select * from dataset;
"""

import pandas as pd

# Assuming the dataset is provided as a CSV file or similar
# Load the dataset into a pandas DataFrame
# Replace 'your_dataset.csv' with the actual file path or name

dataset = pd.read_csv('your_dataset.csv')

# Display the entire dataset
print(dataset)