"""
[USER QUESTION]
테이블이 총 몇개야?
"""

import pandas as pd

# Assuming the dataset is provided as a list of DataFrames
# For example, let's say we have a list of DataFrames named `dataframes`

dataframes = [pd.DataFrame({'A': [1, 2], 'B': [3, 4]}),
              pd.DataFrame({'C': [5, 6], 'D': [7, 8]}),
              pd.DataFrame({'E': [9, 10], 'F': [11, 12]})]

# The number of tables is the length of the list of DataFrames
number_of_tables = len(dataframes)

print(f"The total number of tables is: {number_of_tables}")