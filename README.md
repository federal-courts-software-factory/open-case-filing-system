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
2. If our pipelines are failing because our database isn't connected. We need to run this first. 
- `cargo sqlx prepare --workspace`

## Architecture

OCFS employs a cutting-edge tech stack, aiming for high developer productivity and customer satisfaction.


## Developing with Kubernetes

### Minikube for Local Testing and Deployment
- **Devcontainer and Minikube Integration**: Our development containers automatically start a Minikube Kubernetes instance, streamlining development, testing, and deployment directly to Kubernetes.
- **Current Repository Structure**: Currently, both application and deployment code coexist in the same repository. This setup is temporary and aimed at accelerating development. Eventually, we'll adopt the best practice of separating these concerns.
- **Load Balancer with Minikube**: For load balancing using Istio, use the command: `minikube tunnel`.
- **Future Plans**: We plan to document best practices for mirroring production Kubernetes environments on local machines. Additionally, future enhancements will include more sophisticated CI/CD pipelines and architectural components like Istio and Argo Rollouts.
- **Current Isolation Approach**: Presently, we achieve environment isolation using different namespaces. However, we plan to transition to unique and independent clusters in the future.

#### Deployment Strategies
- **Development Environment**: We deploy to a 'dev' namespace with a unique namePrefix to ensure isolation during testing.
- **Staging Environment**: After initial testing, we promote development images to a 'staging' environment for further performance testing and validations.
- **Production Environment**: Once thoroughly tested (minimum 2 weeks in staging), we move resources to the 'prod' namespace for production deployment.

### Argocd
- **Automated Deployment**: Argocd is used to monitor our Git repository. It tracks changes and automatically updates the cluster. 
- **Configuration Management**: We manage our resources using **kustomize** in the `clusters/` folder, preferring it over Helm.
    * Add our repo and applications to argo (manually from cli) 
    ```
    argocd app create docket-api --repo https://github.com/federal-courts-software-factory/open-case-filing-system.git --path clusters/apps/docket-api/overlays/dev-cluster --dest-server https://kubernetes.default.svc --dest-namespace dev --self-heal --sync-policy automated --sync-retry-limit 5 && 
     argocd app create web --repo https://github.com/federal-courts-software-factory/open-case-filing-system.git --path clusters/apps/web/overlays/dev-cluster --dest-server https://kubernetes.default.svc --dest-namespace dev --self-heal --sync-policy automated --sync-retry-limit 5 
    ```
    * kubectl port-forward svc/argocd-server -n argocd 8080:443
    * kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
    * Manually apply applicationSets:
    * ```
    argocd appset create clusters/environment/appsets/dev-docket-api.yaml && argocd appset create clusters/environment/appsets/dev-web.yaml --upsert
      ```

## Utilizing Cargo Workspaces
- **Efficient Package Management**: We use [Cargo workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html) to manage packages efficiently, offering benefits like unified dependencies and reduced overhead in space and time.

## SurealDB
- **Database Flexibility**: [SurealDB](https://surealdb.com) is our choice for database management, given its flexibility in handling SQL and graph queries, which suits the complex needs of the legal system.

## Web Interface with htmx
- **Enhanced UI Reactivity**: We plan to use htmx for our web interface. It enhances HTML to increase UI reactivity without the need for JavaScript, leading to faster performance and simplified development.

## Open Case Filing System License
- **License Type**: This work is licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).
    - ![CC BY 4.0 License Image](https://i.creativecommons.org/l/by/4.0/88x31.png)
    - ![CC BY 4.0 Shield](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)
