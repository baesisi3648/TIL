"""
[USER QUESTION]
테이블명을 알려줘
"""

import pandas as pd

# Assuming the dataset is provided as a CSV file
# Replace 'your_dataset.csv' with the actual file name
file_path = 'your_dataset.csv'

# Load the dataset into a DataFrame
df = pd.read_csv(file_path)

# Print the table name (file name without extension)
table_name = file_path.split('/')[-1].split('.')[0]
print(f'Table name: {table_name}')