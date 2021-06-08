# Get the last postgres image
FROM postgres:13.3-alpine

# Adding SQLs to entrypoint
COPY *.sql /docker-entrypoint-initdb.d/
RUN chmod 755 /docker-entrypoint-initdb.d/*.sql

# Postgres default port
EXPOSE 5432
