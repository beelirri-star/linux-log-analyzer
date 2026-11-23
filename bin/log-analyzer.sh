#!/bin/bash


files=()
output_dir="reports/"
verbose=false
threshold=5



while [[ $# -gt 0 ]] 
do
case "$1" in

--file)
if [[ $# -lt 2 ]] || [[ "$2" == --* ]] ; then
echo "Error: missing filename "
exit 1
fi
shift
files+=("$1")
shift 


;;

--output)
if [[ $# -lt 2 ]] || [[ "$2" == --* ]] ; then
echo "Error: missing output directory "
exit 1
fi
shift
output_dir="$1"
shift



;;

--verbose)

verbose=true 
shift
;;

--threshold)
if [[ $# -lt 2 ]] || [[ "$2" == --* ]] ; then
echo "Error: --threshold requires a value."
exit 1
fi
shift
threshold="$1"
if [[ ! "$threshold" =~ ^[1-9][0-9]*$ ]]; then
echo "the number must be a positive number"
exit 1
fi
shift
;;

--help)
echo "Usage: log-analyzer.sh [OPTIONS]"
echo "Options:"
echo "  --file FILE        Specify log file"
echo "  --output DIR       Specify output directory"
echo "  --verbose          Enable detailed output"
echo "  --help             Display help"
echo "  --version          Display version"
echo "  --threshold N     Set failed login threshold"
exit 0
;;

--version)
echo "linux-log-analyzer version 1.0.0"
exit 0
;;

*)
echo "Error: Unknown option $1"
exit 1
;;


esac
done


source lib/validation.sh
source lib/reporting.sh

# Validate input files


if [[ ${#files[@]} -ne 2 ]]; then
echo "Error: Please provide auth.log and system.log --file."
exit 1
fi


# Identify input files
auth_file=""
system_file=""



for file in "${files[@]}"
do
    case "$(basename "$file")" in
        auth.log)
            auth_file="$file"
            ;;
        system.log)
            system_file="$file"
            ;;
        *)
            echo "Error: Unsupported input file: $file"
            exit 1
            ;;
    esac
done

if [[ -z "$auth_file" ]] || [[ -z "$system_file" ]]; then
    echo "Error: Both auth.log and system.log are required"
    exit 1
fi

# Validate input files
for file in "$auth_file" "$system_file"
do
    if validate_file "$file"; then
        if [[ "$verbose" == true ]]; then
            echo "Valid log file: $file"
        fi
    else
        echo "Failed to validate file: $file"
        exit 1
    fi
done

# Generate report
if [[ "$verbose" == true ]]; then
    echo "Starting log analysis..."
fi

generate_report "$auth_file" "$system_file" "$threshold" "$output_dir"

if [[ $? -ne 0 ]]; then
    echo "Error: Report generation failed"
    exit 1
fi

if [[ "$verbose" == true ]]; then
    echo "Analysis completed."
fi

exit 0
