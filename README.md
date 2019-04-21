# Transaction_CRUD_Api
A CRUD API for many RDBMS Systems

Single file PHP 7 script that adds a REST API to a MySQL 5.6 InnoDB database. PostgreSQL 9.1 and MS SQL Server 2012 are fully supported. 

## Requirements

  - PHP 7.0 or higher with PDO drivers for MySQL, PgSQL or SqlSrv enabled
  - MySQL 5.6 / MariaDB 10.0 or higher for spatial features in MySQL
  - PostGIS 2.0 or higher for spatial features in PostgreSQL 9.1 or higher
  - SQL Server 2012 or higher (2017 for Linux support)

## Installation

This is a single file application! Upload "`api.php`" somewhere and enjoy!

For local development you may run PHP's built-in web server:

    php -S localhost:8080

Test the script by opening the following URL:

    http://localhost:8080/api.php/records/posts/1

Don't forget to modify the configuration at the bottom of the file.

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
  - Sanitize and validate input using callbacks
  - Permission system for databases, tables, columns and records
  - Multi-tenant database layouts are supported
  - Multi-domain CORS support for cross-domain requests
  - Support for reading joined results from multiple tables
  - Search support on multiple criteria
  - Pagination, sorting, top N list and column selection
  - Relation detection with nested results (belongsTo, hasMany and HABTM)
  - Atomic increment support via PATCH (for counters)
  - Binary fields supported with base64 encoding
  - Spatial/GIS fields and filters supported with WKT
  - Generate API documentation using OpenAPI tools
  - Authentication via JWT token or username/password

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
  - "sw": start with (string starts with value)
  - "ew": end with (string end with value)
  - "eq": equal (string or number matches exactly)
  - "lt": lower than (number is lower than value)
  - "le": lower or equal (number is lower than or equal to value)
  - "ge": greater or equal (number is higher than or equal to value)
  - "gt": greater than (number is higher than value)
  - "bt": between (number is between two comma separated values)
  - "in": in (number or string is in comma separated list of values)
  - "is": is null (field contains "NULL" value)


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