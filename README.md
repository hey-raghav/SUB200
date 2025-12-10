# SUB200  
Uncover Hidden Opportunities with Rapid Subdomain Discovery

![last-commit](https://img.shields.io/github/last-commit/hey-raghav/SUB200?style=flat&logo=git&logoColor=white&color=0080ff)
![repo-top-language](https://img.shields.io/github/languages/top/hey-raghav/SUB200?style=flat&color=0080ff)
![repo-language-count](https://img.shields.io/github/languages/count/hey-raghav/SUB200?style=flat&color=0080ff)
![GNU Bash](https://img.shields.io/badge/GNU%20Bash-4EAA25.svg?style=flat&logo=GNU-Bash&logoColor=white)

---

## Overview

SUB200 is a lightweight yet powerful Bash-based reconnaissance tool designed to:
- Enumerate subdomains via subfinder
- Probe live hosts using httpx
- Output only HTTP 200 responding assets

Ideal for penetration testers, bug bounty hunters, and infrastructure visibility mapping.

---

## Features

| Feature | Description |
|--------|-------------|
| Subdomain enumeration | Collects subdomains from multiple sources |
| HTTP 200 filtering | Shows only valid reachable assets |
| Bash script | No complicated setup |
| Output logging | Stores results for analysis/reporting |
| Recon automation | Fast and reliable security workflow |

---

## Requirements

You must have these tools installed:

| Tool | Use |
|------|-----|
| Bash | Script runtime |
| subfinder | Subdomain enumeration |
| httpx | Live host checking |

Installation (ProjectDiscovery tools):

    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
    export PATH=$PATH:$(go env GOPATH)/bin

---

## Installation

    git clone https://github.com/hey-raghav/SUB200
    cd SUB200
    chmod +x sub200.sh

---

## Usage

Run the tool and specify a domain:

    ./sub200.sh example.com

Results are stored in:

    results/example.com-200.txt

Example:

    ./sub200.sh tesla.com
    cat results/tesla.com-200.txt

---

## Output Structure

    SUB200/
    ├── sub200.sh
    ├── results/
    │   ├── example.com-all.txt
    │   └── example.com-200.txt

---

## Roadmap

- Map and export all response status codes
- Add screenshots support (gowitness)
- Add JSON & CSV output formats
- Speed optimization + concurrency
- Subdomain takeover detection

---

## Contributing

PRs, enhancements, and issues are welcome.

---

## License

MIT License

---

[Back to Top](#sub200)
