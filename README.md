# subdomain_enum
My Subdomain Enumeration Tool is an combined based tool. This tool is designed for bug bounty hunters and security researchers to streamline the process of discovering subdomains for a given domain. Subdomain enumeration is a critical step in reconnaissance, helping identify potential attack surfaces for further testing.

# My Bug Bounty Tool
A tool designed for security researchers to enumerate subdomain  discovery .

## Features
1. uses Amass , subfinder , httpx
2. This tools filter the results and share in a outputfile
3. user friendly , fast and accurate .

## Installation
```bash
git clone https://github.com/MJ-sec4yoU/subdomain_enum.git
cd subdomain_enum
chmod +x subdomain_enum
./subdomain_enum -d example.com -o results.txt

