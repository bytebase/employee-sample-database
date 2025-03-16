# Employee Sample Database - Dev Guide

## Commands
- **Install MySQL small dataset**: `cd mysql/dataset_small && mysql -u <username> < employee.sql`
- **Install PostgreSQL small dataset**: `cd postgres/dataset_small && psql -c "CREATE DATABASE employee" && psql employee < employee.sql`
- **Install SQLite small dataset**: `cd sqlite/dataset_small && sqlite3 employee.db < employee.sql`
- **Test MySQL installation**: `cd mysql/dataset_small && mysql -t < test_employee_md5.sql`
- **Test SQLite installation**: `cd sqlite/dataset_small && sqlite3 employee.db < test_employee_md5.sql`
- **Load functions**: `mysql < object.sql` (Note: For cloud instances like AWS RDS, turn off binary logging first)

## Code Style Guidelines
- **Naming**: Use singular form for table names (e.g., `employee` not `employees`)
- **SQL Files**: Each table has its own load file (e.g., `load_employee.sql`, `load_department.sql`)
- **Database Structure**: Three dataset sizes available - small (~600KB), large (~6MB), and full (~170MB)
- **Schema**: Follow the entity-relationship model shown in `mysql/schema.png`
- **Verification**: Use MD5 checksums to verify data integrity after installation

## Repository Structure
- `/mysql` - MySQL database scripts and documentation
- `/postgres` - PostgreSQL equivalent scripts
- `/sqlite` - SQLite equivalent scripts (small dataset only)
- Each database has identical `dataset_small`, `dataset_large`, and `dataset_full` directories