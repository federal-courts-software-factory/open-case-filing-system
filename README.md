# Open Case Filing System
Open Case Filing System (OCFS) is a modern platform designed to facilitate and streamline court proceedings, providing an efficient solution for managing day-to-day court business.

## Setup:
1. Open Visual Studio Code.
2. Ensure that Docker is running on your local machine.
3. Use the following hotkey in VS Code: Ctrl + SHIFT + P.
4. Search for "dev containers" and select "Rebuild Container."
5. Load the code in a container (devcontainer)

## Database Setup

### This section outlines how to set up the database for the project.
    1. `cd docket-api && cargo run`
    2. `sqlx database create` 
    3. `sqlx migrate run`
    4. `cargo run` or `cargo watch -q -c -x run`

# Run Tests
## Best to run this in a sperate window next to our cargo run command. Server must be running!
    0. `cargo watch -q -c -w tests/ -x "test -q quick_dev -- --nocapture"`
    1. -q Quiet
    2. -c Clear
    3. -w Watch

## Database Troubleshooting
### Troubleshooting steps for database-related issues.
#### Remove everything and migrate the schema.
** Warning this will completely destroy your database. **
>> `sqlx database drop -f; sqlx database create; sqlx migrate run`



## License
This project is in the worldwide public domain.
This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105. Additionally, we waive copyright and related rights in the work worldwide through the CC0 1.0 Universal public domain dedication.
All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.

## Legal Disclaimer
NOTICE
This software package ("software" or "code") was created by the United States Government and is not subject to copyright within the United States. All other rights are reserved.  You may use, modify, or redistribute the code in any manner. However, you may not subsequently copyright the code as it is distributed. The United States Government makes no claim of copyright on the changes you effect, nor will it restrict your distribution of bona fide changes to the software. If you decide to update or redistribute the code, please include this notice with the code. Where relevant, we ask that you credit the Federal Judiciary with the following statement: "Original code developed by the Federal Judiciary of the United States"
USE THIS SOFTWARE AT YOUR OWN RISK. THIS SOFTWARE COMES WITH NO WARRANTY, EITHER EXPRESS OR IMPLIED. THE UNITED STATES GOVERNMENT ASSUMES NO LIABILITY FOR THE USE OR MISUSE OF THIS SOFTWARE OR ITS DERIVATIVES.
THIS SOFTWARE IS OFFERED "AS-IS." THE UNITED STATES GOVERNMENT WILL NOT INSTALL, REMOVE, OPERATE OR SUPPORT THIS SOFTWARE AT YOUR REQUEST. IF YOU ARE UNSURE OF HOW THIS SOFTWARE WILL INTERACT WITH YOUR SYSTEM, DO NOT USE IT.
