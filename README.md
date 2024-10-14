# CSV Processor

## Purpose

`csv_processor.sh` is a Bash script designed to help users perform basic operations on CSV files. It allows for filtering rows based on a specific column value, sorting rows by a particular column, and calculating the average of a numerical column. This script provides a convenient way to process CSV data without needing to rely on more complex tools.

## Features

- **Column filtering:** Filter rows where a column matches a specific value.
- **Column sorting:** Sort the data by a specific column.
- **Average calculation:** Calculate the average of a numerical column.
- **Default behavior:** No specific default behavior; all actions are based on user input.
  
## Usage

```bash
./csv_processor.sh -f FILE [-c COLUMN] [-v VALUE] [-s COLUMN] [-a COLUMN] [-h]
    -f FILE          Specify the CSV file to process
    -c COLUMN        Filter rows where the specified COLUMN mathes a VALUE
    -v VALUE         Value to math in the specified column
    -s COLUMN        Sort the CSV data by the specified COLUMN
    -a COLUMN        Calculate the average of numerical column
    -h               Display this help message
```

## Recources
- **Link to kaggle where I got the csv file:** https://www.kaggle.com/datasets/abdulszz/spotify-most-streamed-songs