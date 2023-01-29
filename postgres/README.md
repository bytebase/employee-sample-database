# Employee Sample Database for PostgreSQL

This is derived from the [MySQL counterpart](https://github.com/bytebase/employee-sample-database/tree/main/mysql).

## Installation:

1. Download the repository
2. Change directory to the repository
3. Change directory to either `dataset_full`, `dataset_large` or `dataset_small`

Run:

```bash
cd dataset_small
```

Then run:

```bash
psql -c "CREATE DATABASE employee"
psql employee < employee.sql
```
