# Transaction_CRUD_Api
A CRUD API for many MySQL Systems, and others in the future

Single file PHP 5.6 script that adds a REST API to a MySQL 5.6 InnoDB, MariaDB databases. 

## Requirements

  - PHP 5.6 or higher with PDO drivers for MySQL, PgSQL, Oracle or SqlSrv enabled
  
## Installation

This is a single file application! Upload "`api.php`" somewhere and enjoy!

## Configuration
You modify the configuration part at the end of the api.php file:
```php
if (stripos($_SERVER['REQUEST_URI'], 'localhost') !== "false") {
    $api = new DbFactory(array(
        'dbengine' => 'MySQL',
        'hostname' => 'localhost',
        'username' => 'root',
        'password' => '',
        'database' => 'dbname',
        'charset' => 'utf8mb4',
        'extraoperations' => 'apiExtraOperations.php',
        'auth' => false,
    ));
    $api->execute();
} else {
    $api = new DbFactory(array(
        'dbengine' => 'MySQL',
        'hostname' => 'Production IP Address',
        'username' => 'username',
        'password' => 'password',
        'database' => 'dbname',
        'charset' => 'utf8mb4',
        'extraoperations' => '<extra operations file name>.php',
        'auth' => false,
    ));
    $api->execute();
}
```
  
## Features

The following features are supported:

  - Single PHP file, easy to deploy.
  - Very little code, easy to adapt and maintain
  - Supports GET, POST, PUT, DELETE and cusotmized operations
  - Supports a JSON object as input
  - Supports a JSON array as input (batch operations)
  - Multi-domain CORS support for cross-domain requests
  - Search support on multiple criteria
  
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
  - "gt": greater than (number is higher than value)
  - "lt": lower than (number is lower than value)
  - "gte": greater or equal (number is higher than or equal to value)
  - "lte": lower or equal (number is lower than or equal to value)
  - "bt": between (number is between two comma separated values)
  - "in": in (number or string is in comma separated list of values)
```JSON
{
  "method":"get",
  "table":"users",
  "where":"id,bt,12,50^(name,cs,dav~age,gte,30)"
}
```  
The above operation are send using the POST method. It will fetch all rows from table users.
Where id is between 12 and 50 AND (name contains string 'dav' OR age >=30).


### Multiple and complex filters
Stay tuned...

### Column selection
Stay tuned...

### Ordering
Stay tuned...

### Limit size
Stay tuned...

### Pagination
Stay tuned...

### Transaction Operations
Stay tuned...

### Spatial support
Stay tuned...
### Authentication
Supports Authentication

### File uploads
Stay tuned...