# Open Case Filing System (OCFS)

The Open Case Filing System (OCFS) is a state-of-the-art platform designed to enhance court proceedings efficiency. It offers a modern solution for managing court operations, leveraging the latest technology to streamline processes.

## Getting Started

### Devcontainer Setup (Recommended)
Follow these steps to set up OCFS using a development container in Visual Studio Code:

1. **Prerequisites**:
   - Ensure Docker is running on your local machine.
   - Install Visual Studio Code.

2. **Setup**:
   - Open Visual Studio Code.
   - Use the hotkey `Ctrl + SHIFT + P`.
   - Search for "dev containers" and select "Rebuild Container."
   - The code will load in a development container, providing an isolated environment.

### Local Setup (Not Recommended)
To set up OCFS locally:

1. **Environment Setup**:
   - Copy `.devcontainers/.env` file to the project's root directory.
   - This step enables running the application locally.

2. **Database Deployment**:
   - Deploy a Postgres Docker container using:
     ```
     docker-compose up -f .devcontainer/docker-compose.yml
     ```

## Local setup
This is not recommended, but in case we don't have access to devcontainers, you can run still run locally. You will need to copy the .env file from our .devcontainers folder into the root folder of the service. Example) cp .devcontainers/.env docket-api/.env. Skipping the step will result in a `set `DATABASE_URL` to use query macros online` error. In the future, we will take advantage of the sql offline and this step will no longer be needed.

## Database Setup

To configure the database:

1. Navigate to the API directory:
- `cd docket-api`

2. Run the following commands:
- Create the database:
  ```
  sqlx database create
  ```
- Apply migrations:
  ```
  sqlx migrate run
  ```
- Start the application:
  ```
  cargo run
  ```

## Running Tests

Execute tests in a separate window:


1. Ensure the server is running (`cargo run`).
2. Run tests with:
- `cargo watch -q -c -w tests/ -x "test -q quick_dev -- --nocapture"`
3. Flag definitions:
- `-q`: Quiet mode
- `-c`: Clear screen before each run
- `-w`: Watch files for changes


## Database Troubleshooting

If you encounter database issues:

1. **Reset Database**:
- **Warning**: This will destroy your current database.
- Run:
  ```
  sqlx database drop -f; sqlx database create; sqlx migrate run
  ```

## Architecture

OCFS employs a cutting-edge tech stack, aiming for high developer productivity and customer satisfaction.

### Cargo Workspaces

- Utilizes [Cargo workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html) for efficient package management.
- Benefits include unified dependencies and reduced space and time overhead.

### SurealDB

- We use [SurealDB](https://surealdb.com) for its flexibility in SQL and graph queries, accommodating the complex needs of the legal system.

### htmx

- For the web interface, we plan to use htmx, enhancing HTML for UI reactivity without JavaScript, ensuring fast performance and simplicity.

# Open Case Filing System License
Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg