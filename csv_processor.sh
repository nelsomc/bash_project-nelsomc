#!/bin/bash

usage() {
    echo "Usage: $0 -f FILE [-c COLUMN] [-v VALUE] [-s COLUMN] [-a COLUMN] [-h]"
    echo " -f FILE          Specify the CSV file to process"
    echo " -c COLUMN        Filter rows where the specified COLUMN matches a VALUE"
    echo " -v VALUE         Value to match in the specified column"
    echo " -s COLUMN        Sort the CSV data by the specified COLUMN"
    echo " -a COLUMN        Calculate the average of numerical column"
    echo " -h               Display this help message"
    exit 1
}


check_file() {
    if [[ ! -f "$1" ]]; then
        echo "Error: CSV file '$1' not found."
        exit 1
    fi
}

calaculate_average() {
    column=$1
    total=$(awk -F, -v col="$column" 'NR>1 {sum+=$col} END {print sum}' "$FILE")
    count=$(awk -F, -v col="$column" 'NR>1 {count++} END {print count}' "$FILE")

    if [[ $count -gt 0 ]]; then
        average=$(echo "$total / $count" | bc -1)
        echo "Average of column $column: $average"
    else
        echo "No data available to calculate average."
    fi
}

filter_column=""
filter_value=""
sort_column=""
average_column=""
FILE=""

while getopts ":f:c:v:s:a:h" opt; do
    case ${opt} in
        f)
            FILE="$OPTARG"
            check_file "$FILE"
            ;;
        c)
            filter_column="$OPTARG"
            ;;
        v)
            filter_value="$OPTARG"
            ;;
        s)
            sort_column="$OPTARG"
            ;;
        a)
            average_column="$OPTARG"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            eccho "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

if [[ -z "$FILE" ]]; then
    echo "Error: You must specify a CSV file with -f."
    usage
fi

if [[ -n "$filter_column" && -n "$filter_value" ]]; then
    col_num=$(awk -F, 'NR==1 {for (i=1;i<=NF;i++) if ($i=="'"$filter_column"'") print i}' "$FILE")
    if [[ -z "$col_num" ]]; then
        echo "Error: Column '$filter_column' not found in the CSV file."
        exit 1
    else
        echo "Filtering rows where column '$filter_column' equals '$filter_value':"
        result=$(awk -F, -v col="$filter_column" -v val="$filter_value" 'NR==1 {for (i=1;i<=NF;i++) if ($i==col) col_num=i} NR>1 {if ($col_num==val) print $0}' "$FILE")
        if [[ -z "$result" ]]; then
            echo "No rows found matching column '$filter_column' with value '$filter_value'."
        else
            echo "$result"
        fi
    fi
fi

if [[ -n "$sort_column" ]]; then
    echo "Sorting rows by column '$sort_column':"
    sort_col=$(awk -F, 'NR==1 {for (i=1;i<=NF;i++) if ($i=="'"$sort_column"'") print i}' "$FILE")
    if [[ -n "$sort_col" ]]; then
        sort -t, -k"$sort_col" "$FILE"
    else
        echo "Error: Column '$sort_column' not found."
    fi
fi

if [[ -n "$average_column" ]]; then
    echo "Calculating average for column '$average_column':"
    col_num=$(awk -F, 'NR==1 {for (i=1;i<=NF;i++) if ($i=="'"$average_column"'") print i}' "$FILE")
    if [[ -n "$col_num" ]]; then
        calculate_average "$col_num"
    else
        echo "Error: Column '$average_column' not found."
    fi
fi

exit 0