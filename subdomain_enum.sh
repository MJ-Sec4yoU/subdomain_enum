#!/bin/bash

# Script for subdomain enumeration
# Author: Bug Bounty Hunter

# Colors for banner and output
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display the banner
function display_banner() {
  echo -e "${CYAN}"
  echo "###########################################################"
  echo "#                                                         #"
  echo "#        Subdomain Enumeration Tool by MJ-Sec4yoU         #"
  echo "#                                                         #"
  echo "###########################################################"
  echo -e "${NC}"
}

# Check if the required tools are installed
function check_tools() {
  for tool in amass subfinder httpx; do
    if ! command -v $tool &>/dev/null; then
      echo -e "${RED}Error: $tool is not installed. Please install it before running this script.${NC}"
      exit 1
    fi
  done
}

# Usage instructions
function usage() {
  echo -e "${GREEN}Usage: $0 -d domain -o output_file${NC}"
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
  echo -e "${GREEN}[+] Enumerating subdomains for: $domain${NC}"

  # Create a temporary directory
  tmp_dir=$(mktemp -d)
  echo -e "${GREEN}[+] Using temporary directory: $tmp_dir${NC}"

  # Run Amass
  echo -e "${CYAN}[+] Running Amass...${NC}"
  amass enum -d $domain -o $tmp_dir/amass.txt

  # Run Subfinder
  echo -e "${CYAN}[+] Running Subfinder...${NC}"
  subfinder -d $domain -o $tmp_dir/subfinder.txt

  # Combine results and remove duplicates
  echo -e "${CYAN}[+] Combining results and removing duplicates...${NC}"
  cat $tmp_dir/amass.txt $tmp_dir/subfinder.txt | sort -u > $tmp_dir/all_subdomains.txt

  # Probe for live subdomains using HTTPX
  echo -e "${CYAN}[+] Probing live subdomains with HTTPX...${NC}"
  httpx -l $tmp_dir/all_subdomains.txt -silent -o $output_file

  # Cleanup
  echo -e "${CYAN}[+] Cleaning up temporary files...${NC}"
  rm -rf $tmp_dir

  echo -e "${GREEN}[+] Subdomain enumeration completed! Results saved to: $output_file${NC}"
}

# Main script execution
display_banner
check_tools
enumerate_subdomains
