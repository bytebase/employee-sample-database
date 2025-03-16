# Employee Sample Database for SQLite

This is derived from the [MySQL counterpart](https://github.com/bytebase/employee-sample-database/tree/main/mysql).

## Schema

The schema matches the MySQL and PostgreSQL versions, with appropriate adaptations for SQLite syntax.

## Installation:

1. Download the repository
2. Change directory to the repository
3. Change directory to `dataset_small`

Run:

```bash
cd dataset_small
```

Then run:

```bash
sqlite3 employee.db < employee.sql
```

## Testing the installation

```bash
# Under 'dataset_small' directory
sqlite3 employee.db < test_employee_md5.sql
```

This will verify the integrity of the loaded data by comparing record counts and MD5 checksums against expected values.