# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Employee Sample Database - Dev Guide

## Database Installation Commands

### MySQL
```bash
# Install dataset (choose one size)
cd mysql/dataset_small && mysql -u <username> < employee.sql
cd mysql/dataset_large && mysql -u <username> < employee.sql  
cd mysql/dataset_full && mysql -u <username> < employee.sql

# Alternative using install script
mysql/install_dataset_small.sh . <username>

# Test installation
cd mysql/dataset_small && mysql -t < test_employee_md5.sql
cd mysql/dataset_large && mysql -t < test_employee_md5.sql
cd mysql/dataset_full && mysql -t < test_employee_md5.sql

# Load optional functions (after dataset installation)
cd mysql/dataset_small && mysql < object.sql
```

### PostgreSQL
```bash
# Install dataset (choose one size)
cd postgres/dataset_small && psql -c "CREATE DATABASE employee" && psql employee < employee.sql
cd postgres/dataset_large && psql -c "CREATE DATABASE employee" && psql employee < employee.sql
cd postgres/dataset_full && psql -c "CREATE DATABASE employee" && psql employee < employee.sql
```

### SQLite
```bash
# Install dataset (small only)
cd sqlite/dataset_small && sqlite3 employee.db < employee.sql

# Test installation
cd sqlite/dataset_small && sqlite3 employee.db < test_employee_md5.sql
```

## Architecture Overview

This is a multi-database employee sample dataset repository with three database implementations (MySQL, PostgreSQL, SQLite) and three dataset sizes:

- **dataset_small** (~600KB, 1,000 employees) - For development and testing
- **dataset_large** (~6MB, 10,000 employees) - For performance testing
- **dataset_full** (~170MB, 300,024 employees) - Full production-scale dataset

### Core Tables Schema
- `employee` - Employee records with personal info
- `department` - Department definitions  
- `dept_emp` - Employee-department relationships
- `dept_manager` - Department manager assignments
- `salary` - Employee salary history
- `title` - Employee title history

### Key Design Patterns
- Each table has individual load files (`load_employee.sql`, `load_department.sql`, etc.)
- All datasets maintain referential integrity and identical schema
- MD5 checksums verify data integrity after installation
- Singular table names (not plural) across all implementations
- MySQL includes optional stored functions (`object.sql`)

## Important Notes

### Cloud Database Setup
For AWS RDS and similar cloud MySQL instances, disable binary logging before loading functions:
```sql
SET sql_log_bin = 0;
```

### Data Verification
Always run the MD5 test after installation to ensure data integrity. The test compares record counts and checksums against expected values for each table.