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


### Developing against Kubernetes
#### Minikube (Local testing and deployment)
>> Our devcontainers will start a minkube **kubernetes distribution** instance and will be ready for you to develop, test and deploy to kubernetes. 
Our current application and deployment code live inside the same repo. This will change and must change, but it's important to move fast, so our application and deployment will not have the seperation that is considered best practice. 

* If you want minikube to provide a load balancer for use by Istio: `minikube tunnel`.
* The best practice and standards on how to treat your local laptop like a production kubernetes instance will be discussed and documented in the future. 
* For now, our focus is primarily on can the code be deployed to kubernetes. In the future, we will expand further into ci/cd pipeline and architecture (istio, argo-rollouts) requirements.
* In the future, we will have unique and independent clusters, but now isolation happens within different namespaces.

>> Deploying to development
    * We use the dev namespace and a namePrefix to ensure an isolated environment. All development work will be deployed to the dev namespace for testing.
>> Deploying to staging
    * After testing, we will promote our dev images to staging. We will run performance tests and validations. All resources should be in the staging namespace.
>> Deploying to production
    * Promotion to production occurs after a minimum of 2 weeks of staging or a significant amount of testing has occured. All resources are deployed into the prod namespace.  

#### Argocd
>> Argocd allows us to monitor our git repo and track changes and automatically pull these changes into the cluster automatically. We define these resources in our `clusters/` folder using **kustomize**, We try and avoid helm at all costs. 


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