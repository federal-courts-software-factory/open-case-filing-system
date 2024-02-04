## this is not used, but is here for historical purposes (if we ever go to postgres)
## This script can be run locally, but was designed to run to migrate and test our application against github actions.
#!/usr/bin/env bash
set -x
set -eo pipefail
# Check to see if psql and sqlx is installed and then do the heavy lifting
if ! [ -x "$(command -v psql)" ]; then
echo >&2 "Error: psql is not installed."
exit 1
fi
if ! [ -x "$(command -v sqlx)" ]; then
echo >&2 "Error: sqlx is not installed."
echo >&2 "Use:"
echo >&2 " cargo install --version='~0.6' sqlx-cli \
--no-default-features --features rustls,postgres"
echo >&2 "to install it."
exit 1
fi

# Check if a custom user has been set, otherwise default to 'postgres'
DB_USER=${POSTGRES_USER:=postgres}
# Check if a custom password has been set, otherwise default to 'password'
DB_PASSWORD="${POSTGRES_PASSWORD:=postgres}"
# Check if a custom database name has been set, otherwise default to 'newsletter'
DB_NAME="${POSTGRES_DB:=docket-api}"
# Check if a custom port has been set, otherwise default to '5432'
DB_PORT="${POSTGRES_PORT:=5432}"
# Check if a custom host has been set, otherwise default to 'localhost'
DB_HOST="${POSTGRES_HOST:=localhost}"



if [[ -z "${SKIP_PSQL}" ]]
then
# Keep pinging Postgres until it's ready to accept commands
export PGPASSWORD="${DB_PASSWORD}"
until psql -h "${DB_HOST}" -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q'; do
>&2 echo "Postgres is still unavailable - sleeping"
sleep 1
done
>&2 echo "Postgres is up and running on port ${DB_PORT} - running migrations now!"
fi
DATABASE_URL=postgres://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
export DATABASE_URL
sqlx database create
sqlx migrate run

>&2 echo "Postgres has been migrated, ready to go!"