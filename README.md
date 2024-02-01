# Open Case Filing System (OCFS)
>> Under Heavy Construction.

The Open Case Filing System (OCFS) is a state-of-the-art platform designed to enhance court proceedings efficiency. It offers a modern solution for managing court operations, leveraging the latest technology to streamline processes.
### Built With

* [![Rust][Rust]][Rust-url]
* [![Axum][Axum]][Axum-url]
* [![SurrealDB][SurrealDB]][SurrealDB-url]
  
## Getting Started

### Devcontainer Setup (Recommended)
Follow these steps to set up OCFS using a [development container](https://code.visualstudio.com/docs/devcontainers/containers) in Visual Studio Code:

1. **Prerequisites**:
   - Ensure [Docker](https://docs.docker.com/engine/install/) is installed and running on your local machine.
   - Ensure [git](https://git-scm.com/) is installed and running on your operating system of choice. `git --version`
   - Install [Visual Studio Code](https://code.visualstudio.com/) or a [code editor](https://containers.dev/supporting) that supports devcontainers.
   - Install [devcontainers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in VS Code.
   - `git clone git@github.com:federal-courts-software-factory/open-case-filing-system.git`

2. **Setup**:
   - Open Visual Studio Code in the open-case-filing-system directory. If you have Visual Studio Code installed in your system path: `code open-case-filing-system`
   - Install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension if you haven't already
   - Use the Windows/Linux hotkey: `Ctrl + SHIFT + P` or OSX hotkey: `CMD + SHIFT + P` to open up the window.
   - Search for "dev containers" and select "Dev Containers: Rebuild and Reopen in Container."
   - The code will load in a development container, providing an isolated environment.
   - to work with git inside the container, it might be necessary to run `git config --global --add safe.directory /workspaces/open-case-filing-system`

### Local Setup (Not Recommended and not tested)
To set up OCFS locally:

1. **Environment Setup**:
   - Copy `.devcontainers/.env` file to the open-case-filing-system root directory.
   - This step enables running the application locally.

2. **Database Deployment**:
   - Deploy a Postgres Docker container using:
     ```
     docker-compose up -f .devcontainer/docker-compose.yml
     ```
<p align="right">(<a href="#readme-top">back to top</a>)</p>
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
<p align="right">(<a href="#readme-top">back to top</a>)</p>
## Running Tests

Execute tests in a separate window:


1. Ensure the server is running (`cargo run`).
2. Run tests with:
- `cargo watch -q -c -w tests/ -x "test -q quick_dev -- --nocapture"`
3. Flag definitions:
- `-q`: Quiet mode
- `-c`: Clear screen before each run
- `-w`: Watch files for changes

<p align="right">(<a href="#readme-top">back to top</a>)</p>
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
<p align="right">(<a href="#readme-top">back to top</a>)</p>
## Architecture

OCFS employs a cutting-edge tech stack, aiming for high developer productivity and customer satisfaction.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
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
    * Expose the Argocd service so you can reach the web ui:
      ```
      kubectl port-forward svc/argocd-server -n argocd 8080:443
      ```
    - In your browser go to: `http://localhost:80880`

    * Find the randomly created admin password:
      ```
      kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
      ```
    - Admin login: use the username, `admin` and use password from kubectl get secret command directly above.
<p align="right">(<a href="#readme-top">back to top</a>)</p>
## Argocd ApplicationSets
### How to Manually apply applicationSets:
This step should not be needed, but in case somebody didn't run as expected you can always cd into the open case filing system directory on your computer and run the following:  **Notice: --upsert flag** is required if you already applied these applicationSets before.

  * 
    ```
    argocd appset create clusters/environment/appsets/dev-docket-api.yaml --upsert && argocd appset create clusters/environment/appsets/dev-web.yaml --upsert
    ```

## Utilizing Cargo Workspaces
- **Efficient Package Management**: We use [Cargo workspaces](https://doc.rust-lang.org/book/ch14-03-cargo-workspaces.html) to manage packages efficiently, offering benefits like unified dependencies and reduced overhead in space and time.

## Postgres (active)
- **Main database driver** We currently use postgres as our main driver until we can move to surealdb. 

## SurealDB (planned in v2)
- **Database Flexibility**: [SurealDB](https://surealdb.com) is our choice for database management, given its flexibility in handling SQL and graph queries, which suits the complex needs of the legal system.

## Web Interface with htmx
- **Enhanced UI Reactivity**: We plan to use htmx for our web interface. It enhances HTML to increase UI reactivity without the need for JavaScript, leading to faster performance and simplified development.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Open Case Filing System License
- **License Type**: This work is licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/).
    - ![CC BY 4.0 License Image](https://i.creativecommons.org/l/by/4.0/88x31.png)
    - ![CC BY 4.0 Shield](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)
<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/vitorlfaria/rust_clean_api.svg?style=for-the-badge
[contributors-url]: https://github.com/federal-courts-software-factory/open-case-filing-system/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/vitorlfaria/rust_clean_api.svg?style=for-the-badge
[forks-url]: https://github.com/federal-courts-software-factory/open-case-filing-system/network/members
[stars-shield]: https://img.shields.io/github/stars/vitorlfaria/rust_clean_api.svg?style=for-the-badge
[stars-url]: https://github.com/federal-courts-software-factory/open-case-filing-system/stargazers
[issues-shield]: https://img.shields.io/github/issues/vitorlfaria/rust_clean_api.svg?style=for-the-badge
[issues-url]: https://github.com/federal-courts-software-factory/open-case-filing-system/issues
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/vitor-lacerda-faria
[Rust]: https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white
[Rust-url]: https://rust-lang.org/
[Axum]: https://img.shields.io/badge/Axum-d97d0d?style=for-the-badge
[Axum-url]: https://github.com/tokio-rs/axum
[SurrealDB]: https://img.shields.io/badge/SurrealDB-cc108d?style=for-the-badge
[SurrealDB-url]: https://surrealdb.com/
