Using Docker, bash and bitcoin-core write a script that launches a private Bitcoin Network (regtest) with at least 2 nodes. Pair them between each other and mine some blocks. After, send at least one transaction from one node to the other.
Create a public Github repository where you are pushing your code as you write it. Creating a pipeline in Github actions to run such systems is a plus but not a requirement.



# BitGo DevOps Regtest Demo

This repository demonstrates setting up a private Bitcoin regtest network with 2 nodes using Docker and bash, mining blocks, and sending a transaction.

## 🚀 Quick Start

1. **Clone** the repo:
   ```bash
   git clone https://github.com/silentstorm29/Bitgo-assessment-bitcoin-regtest.git
   cd Bitgo-assessment-bitcoin-regtest


2. **Build and start the Docker containers**:
   ```bash
   docker-compose up --build -d
   ```

3. **Run the setup script** to initialize the nodes and mine blocks:
   ```bash
   ./scripts/setup.sh
   ```

4. **Check the logs** to see the transaction and mined blocks:
   ```bash
   docker-compose logs -f
   ```
5. **Stop the containers** when done:
   ```bash
   docker-compose down
   ```  
## 🗂️ Directory Structure

Bitgo-assessment-bitcoin-regtest/
├── docker/
│   ├── node1/
│   │   ├── Dockerfile
│   │   └── bitcoin.conf
│   └── node2/
│       ├── Dockerfile
│       └── bitcoin.conf
├── scripts/
│   └── setup.sh
├── docker-compose.yml
├── .gitignore
├── README.md
└── .github/
    └── workflows/
        └── ci.yml 