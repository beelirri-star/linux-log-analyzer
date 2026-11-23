  #!/bin/bash
# Load required functions
source "$(dirname "${BASH_SOURCE[0]}")/parser.sh"
source "$(dirname "${BASH_SOURCE[0]}")/analysis.sh"


#generate the report

 
generate_report()
{

local auth_file=$1
local system_file=$2
local threshold=$3
local output_dir=$4 

if [[ $# -ne 4 ]];  then
echo "Error: Function requires 4 arguments" >&2
return 2
fi


if ! [[ $threshold =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Threshold must be a positive integer" >&2
    return 2
fi


 #validate the output directory

if [[ ! -d $output_dir ]]; then
echo "ERROR: Output directory does not exist: $output_dir" >&2
return 1
fi




    local timestamp
    timestamp=$(date '+%Y%m%d_%H%M%S')

    local report_file="$output_dir/report-$timestamp.txt"

    # Run analysis functions
    local severity_results
    local ssh_results

    if ! severity_results=$(analyze_log_summary "$system_file"); then
        echo "ERROR: System log analysis failed" >&2
        return 1
    fi

    if ! ssh_results=$(detect_suspicious_ips "$auth_file" "$threshold"); then
        echo "ERROR: SSH analysis failed" >&2
        return 1
    fi


    {
        echo "========================================"
        echo "           LINUX LOG ANALYZER"
        echo "========================================"
        echo
        echo "Report Information"
        echo "----------------------------------------"
        echo "Auth File: $auth_file"
        echo "System File: $system_file"
        echo "Generated At: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "Threshold: $threshold"
        echo
        echo "System Log Summary"
        echo "----------------------------------------"
        printf '%s\n' "$severity_results"
        echo
        echo "SSH Failed Login Analysis"
        echo "----------------------------------------"
        printf '%s\n' "$ssh_results"
        echo
        echo "========================================"
    } > "$report_file" || {
        echo "ERROR: Could not write report" >&2
        return 1
    }

    echo "Report generated successfully: $report_file"
    return 0

}
