Linux Log Analyzer

A simple Bash-based tool for analyzing Linux system logs and SSH authentication events.

The project helps identify suspicious SSH login activity and summarize system log severity levels.

Features

Validate input log files.

Analyze system log severity levels (INFO, WARNING, ERROR, CRITICAL).

Detect failed SSH login attempts.

Extract IP addresses from failed login events.

Identify suspicious IP addresses based on a configurable threshold.

Generate a text-based analysis report.

Support multiple command-line options.

Project Structure

linux-log-analyzer/
├── bin/
│   └── log-analyzer.sh
├── lib/
│   ├── validation.sh
│   ├── parser.sh
│   ├── analysis.sh
│   └── reporting.sh
├── samples/
│   ├── auth.log
│   └── system.log
├── reports/
├── README.md
├── LICENSE
└── .gitignore

Requirements

Linux or WSL

Bash

GNU grep

AWK

Usage

Clone the repository:

git clone https://github.com/beelirri-star/linux-log-analyzer.git
cd linux-log-analyzer

Run the analyzer:

bash bin/log-analyzer.sh \
  --file samples/auth.log \
  --file samples/system.log \
  --threshold 3

Enable verbose output:

bash bin/log-analyzer.sh \
  --file samples/auth.log \
  --file samples/system.log \
  --threshold 3 \
  --verbose

Specify a custom output directory:

bash bin/log-analyzer.sh \
  --file samples/auth.log \
  --file samples/system.log \
  --threshold 3 \
  --output reports/

Command-Line Options

Option

Description

--file FILE

Specify an input log file.

--threshold N

Set the failed login threshold.

--output DIR

Specify the report output directory.

--verbose

Display additional execution information.

--help

Display usage information.

--version

Display the project version.

Both auth.log and system.log are required.

Example Analysis

With a threshold of 3, the sample authentication logs produce results similar to:

10.0.0.15 5 SUSPICIOUS
192.168.1.20 3 SUSPICIOUS
192.168.1.30 2 NORMAL

The analyzer also summarizes system log entries:

INFO: 1
WARNING: 1
ERROR: 2
CRITICAL: 1

Output

The generated report is saved in the reports/ directory.

It includes:

Input file information

Report generation date and time

System log severity summary

SSH failed login analysis

Limitations

Designed for text-based log files.

Performs batch analysis, not real-time monitoring.

Suspicious IP detection is based on failed login counts and does not prove a system compromise.

Uses sample logs for testing.

Author

Developed as a hands-on Bash and Linux project to practice scripting, log analysis, input validation, and command-line automation.

License

This project is licensed under the MIT License. See the LICENSE file for details.