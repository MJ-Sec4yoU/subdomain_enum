#!/bin/bash

# Script for subdomain enumeration
# Author: Bug Bounty Hunter

# Check if the required tools are installed
function check_tools() {
  for tool in amass subfinder httpx; do
    if ! command -v $tool &>/dev/null; then
      echo "Error: $tool is not installed. Please install it before running this script."
      exit 1
    fi
  done
}

# Usage instructions
function usage() {
  echo "Usage: $0 -d domain -o output_file"
  echo "  -d domain      : The domain to enumerate subdomains for."
  echo "  -o output_file : The file to save the results to."
  exit 1
}

# Parse command-line arguments
while getopts "d:o:" opt; do
  case $opt in
    d) domain=$OPTARG ;;
    o) output_file=$OPTARG ;;
    *) usage ;;
  esac
done

# Check if domain and output_file are provided
if [[ -z $domain || -z $output_file ]]; then
  usage
fi

# Function to perform subdomain enumeration
function enumerate_subdomains() {
  echo "[+] Enumerating subdomains for: $domain"

  # Create a temporary directory
  tmp_dir=$(mktemp -d)
  echo "[+] Using temporary directory: $tmp_dir"

  # Run Amass
  echo "[+] Running Amass..."
  amass enum -d $domain -o $tmp_dir/amass.txt

  # Run Subfinder
  echo "[+] Running Subfinder..."
  subfinder -d $domain -o $tmp_dir/subfinder.txt

  # Combine results and remove duplicates
  echo "[+] Combining results and removing duplicates..."
  cat $tmp_dir/amass.txt $tmp_dir/subfinder.txt | sort -u > $tmp_dir/all_subdomains.txt

  # Probe for live subdomains using HTTPX
  echo "[+] Probing live subdomains with HTTPX..."
  httpx -l $tmp_dir/all_subdomains.txt -silent -o $output_file

  # Cleanup
  echo "[+] Cleaning up temporary files..."
  rm -rf $tmp_dir

  echo "[+] Subdomain enumeration completed! Results saved to: $output_file"
}

# Main script execution
check_tools
enumerate_subdomains
