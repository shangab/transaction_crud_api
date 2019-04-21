# Transaction_CRUD_Api
A CRUD API for many RDBMS Systems

Single file PHP 5.6 script that adds a REST API to a MySQL 5.6 InnoDB database. 
PostgreSQL 9.1 (Comming soon), Oracle 11 (Comming soon) and MS SQL Server 2012 are fully supported. 

## Requirements

  - PHP 5.6 or higher with PDO drivers for MySQL, PgSQL, Oracle or SqlSrv enabled
  
## Installation

This is a single file application! Upload "`api.php`" somewhere and enjoy!

## Configuration
Stay tuned...

## Limitations

These limitation and constrains apply:

  - Primary keys should either be auto-increment (from 1 to 2^53) or UUID
  - Composite primary or foreign keys are not supported
  - Complex writes (transactions) are not supported
  - Complex queries calling functions (like "concat" or "sum") are not supported
  - Database must support and define foreign key constraints
  
## Features

The following features are supported:

  - Single PHP file, easy to deploy.
  - Very little code, easy to adapt and maintain
  - Supports POST variables as input (x-www-form-urlencoded)
  - Supports a JSON object as input
  - Supports a JSON array as input (batch insert)
  - Permission system for databases, tables, columns and records
  - Multi-domain CORS support for cross-domain requests
  - Search support on multiple criteria
  - Pagination, sorting, top N list and column selection (Comming soon)
  - Relation detection with nested results (belongsTo, hasMany and HABTM) (Comming soon)
  - Binary fields supported with base64 encoding (Comming soon)

### CRUD + List
Stay tuned...

#### Create
Stay tuned...

#### Read
Stay tuned...

#### Update
Stay tuned...

#### Delete
Stay tuned...

#### List
Stay tuned...

### Filters

Filters provide search functionality, on list calls, using the "filter" parameter. You need to specify the column
name, a comma, the match type, another commma and the value you want to filter on. These are supported match types:

  - "cs": contain string (string contains value)
  - "eq": equal (string or number matches exactly)
  - "neq": Not equal (string or number matches exactly)
  - "lt": lower than (number is lower than value)
  - "le": lower or equal (number is lower than or equal to value)
  - "ge": greater or equal (number is higher than or equal to value)
  - "gt": greater than (number is higher than value)
  - "bt": between (number is between two comma separated values)
  - "in": in (number or string is in comma separated list of values)
  

### Multiple filters
Stay tuned...

### Column selection
Stay tuned...

### Ordering
Stay tuned...

### Limit size
Stay tuned...

### Pagination
Stay tuned...

### Joins
Stay tuned...

### Batch operations
Stay tuned...

### Spatial support
Stay tuned...
### Authentication
Stay tuned...
### File uploads
Stay tuned...