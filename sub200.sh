#!/bin/bash

#============================#
#         SUB200 TOOL        #
#============================#

# Colours
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

# ASCII ART (Provided)
echo -e "${CYAN}"
echo "   _____ _    _ ____    ___   ___   ___  "
echo "  / ____| |  | |  _ \  |__ \ / _ \ / _ \ "
echo " | (___ | |  | | |_) |    ) | | | | | | |"
echo "  \___ \| |  | |  _ <    / /| | | | | | |"
echo "  ____) | |__| | |_) |  / /_| |_| | |_| |"
echo " |_____/ \____/|____/  |____|\___/ \___/ "
echo -e "               ${YELLOW}Subdomain 200 Scanner${RESET}\n"

#============================#
#        USER INPUT          #
#============================#

read -rp "Enter the company/domain (example: tesla.com): " company

# Take only the part before the first dot for filenames: tesla.com -> tesla
base_name="${company%%.*}"
if [[ -z "$base_name" ]]; then
    base_name="$company"
fi

subdomain_file="${base_name}subdomains.txt"
live200_file="${base_name}200.txt"

#============================#
#        DEP CHECK           #
#============================#

# 1) Check subfinder
if ! command -v subfinder &> /dev/null; then
    echo -e "${RED}[!] subfinder not installed. Please install subfinder.${RESET}"
    exit 1
fi

# 2) Decide which httpx binary to use
httpx_cmd=""

# Prefer a ProjectDiscovery-compatible httpx
if command -v httpx &> /dev/null; then
    # Check if this httpx looks like ProjectDiscovery (has -silent or mentions ProjectDiscovery)
    if httpx -h 2>&1 | grep -qi "projectdiscovery"; then
        httpx_cmd="httpx"
    elif httpx -h 2>&1 | grep -q "\-silent"; then
        httpx_cmd="httpx"
    else
        echo -e "${YELLOW}[!] Found a different 'httpx' command (not ProjectDiscovery). Ignoring it.${RESET}"
    fi
fi

# Fallback to httpx-toolkit if main httpx is missing/incompatible
if [[ -z "$httpx_cmd" ]] && command -v httpx-toolkit &> /dev/null; then
    if httpx-toolkit -h 2>&1 | grep -q "\-silent"; then
        httpx_cmd="httpx-toolkit"
    fi
fi

# If still empty, nothing usable found
if [[ -z "$httpx_cmd" ]]; then
    echo -e "${RED}[!] Neither compatible httpx nor httpx-toolkit found."
    echo -e "    Please install ProjectDiscovery httpx: https://github.com/projectdiscovery/httpx${RESET}"
    exit 1
fi

echo -e "${GREEN}[✔] Using HTTP probe tool: ${httpx_cmd}${RESET}"

#============================#
#         PROCESS            #
#============================#

echo -e "${YELLOW}[+] Running subfinder for: ${company}${RESET}"
subfinder -d "$company" -silent -o "$subdomain_file"

if [[ ! -s "$subdomain_file" ]]; then
    echo -e "${RED}[!] No subdomains found or file is empty: $subdomain_file${RESET}"
    exit 1
fi

echo -e "${GREEN}[✔] Subdomains saved to: $subdomain_file${RESET}"

echo -e "${YELLOW}[+] Scanning for HTTP 200 live hosts...${RESET}"
if ! cat "$subdomain_file" | $httpx_cmd -silent -mc 200 -o "$live200_file"; then
    echo -e "${RED}[!] ${httpx_cmd} scan failed. Please verify your httpx installation.${RESET}"
    exit 1
fi

echo -e "${GREEN}[✔] Live 200 hosts saved to: $live200_file${RESET}"
echo -e "${GREEN}[+] Scan finished successfully.${RESET}"
