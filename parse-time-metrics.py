import pandas as pd

# Load the CSV file
file_path = 'On2On_Node_1000.csv'  # Replace with your file path
data = pd.read_csv(file_path, usecols=['Time', 'Data'])

# Initialize variables to store the start time, end time, and the time differences
start_time = None
time_differences = []

# Iterate through each row of the dataset
for index, row in data.iterrows():
    # Check for start of a new simulation
    if start_time is None:
        start_time = row['Time']
    
    # Check for the end of a simulation
    if "Message 100" in str(row['Data']):
        end_time = row['Time']
        time_difference = end_time - start_time
        time_differences.append(time_difference)
        start_time = None  # Reset start time for the next simulation

# Output the time differences
for i, diff in enumerate(time_differences):
    print(f"Simulation {i+1}\t{diff}\tseconds")    