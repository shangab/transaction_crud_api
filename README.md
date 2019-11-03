# Transaction_CRUD_Api
A CRUD API for many MySQL Systems, and others in the future

Single file PHP 5.6 script that adds a REST API to a MySQL 5.6 InnoDB, MariaDB databases. 

## Requirements

  - PHP 5.6 or higher with PDO drivers for MySQL, PgSQL, Oracle or SqlSrv enabled

## Features

The following features are supported:

  - Single PHP file, easy to deploy.
  - Very little code, easy to adapt and maintain
  - Supports GET, POST, PUT, DELETE and cusotmized operations
  - Supports a JSON object as input
  - Supports a JSON array as input (batch operations)
  - Multi-domain CORS support for cross-domain requests
  - Search support on multiple criteria
  
## Installation

This is a single file application! Upload "`api.php`" somewhere and enjoy!

## Use our dmodb.sql
The file demodb.sql contains a demo database having 4 tables.
Install WampServer or Xampserver and then run the SQL in this file.
It will setup the demodb with 4 tables:
- products: is a lookup table contain id,name for 3 products only as example.
- cusomters: is a table contains 100 fake cusomters with fields: id, fullname and phone.
- orders: is a table contains 100 orders for the cusomters with fields: id,date, cusomterid and amount
- orderitems: a table contains the items for each order with fields: id, productid, qty, unitprice, totalprice  

## Configuration
You modify the configuration part at the end of the api.php file:
```php

if (stripos($_SERVER['REQUEST_URI'], 'localhost') !== "false") {
    $api = new DbFactory(array(
        'dbengine' => 'MySQL',
        'hostname' => '<production IP Address>',
        'username' => 'username',
        'password' => 'password',
        'database' => '<db name>',
        'charset' => 'utf8mb4',
        'extraoperations' => 'apiExtraOperations.php',
        'auth' => false,
    ));
    $api->execute();
} else {
    $api = new DbFactory(array(
        'dbengine' => 'MySQL',
        'hostname' => 'localhost',
        'username' => 'root',
        'password' => '',
        'database' => 'demodb',
        'charset' => 'utf8mb4',
        'extraoperations' => 'apiExtraOperations.php',
        'auth' => false,
    ));
    $api->execute();
}
}
```
dbengine: is the RDBMS engine now we have only MySQL, stay tuned for extra engines in the near future.
extraoperations: is a PHP file used for operations other than regular: GET, POST, DELETE and PUT.


#### Create
To post a new record in a table use the following body for your POST http query:

```JSON
{
  "method":"post",
  "table":"products",
  "body":{
    "name":"New product"
  }
}
```
When sending this body in your POST query api will insert a new product in the table and send the following response:

```JSON
[12]
```
such that 12 is the new id for the row, as id is an AUTO INCREMENT primary key you do not have to include it in your request body.

#### Read
To get rows from table use the following body for your POST http query:

```JSON
{
  "method":"get",
  "table":"orders",
  "where": "id,gt,5^(customerid,bt,30,50~amount,lte,200)"
}
```
When sending this body in your POST query api will return a JSON array for all orders with id>5 AND (customerid BETWEEN 30 and 50 OR amount <= 200) 

```JSON
[
    {
        "id": 6,
        "customerid": 5,
        "date": "2019-01-24 02:55:12",
        "amount": "189.00"
    },
    {
        "id": 7,
        "customerid": 8,
        "date": "2019-08-27 12:35:23",
        "amount": "163.00"
    },
    {
        "id": 10,
        "customerid": 6,
        "date": "2019-02-03 02:35:09",
        "amount": "168.00"
    },
    {
        "id": 12,
        "customerid": 9,
        "date": "2019-10-05 06:46:54",
        "amount": "118.00"
    },
    {
        "id": 14,
        "customerid": 5,
        "date": "2019-06-11 03:25:16",
        "amount": "133.00"
    },
    ...ect
]
```

#### Update
To update rows use the following JSON as your POST http request: 
```JSON
{
  "method":"put",
  "table":"products",
  "body":{
    "name": "new name",
  },
  "where": "id,eq,2"
}
```
When sending this body in your POST query api will update the product name  to `new name` if the id = 2


#### Delete
To delete rows use the following JSON as your POST http request: 
```JSON
{
  "method":"delete",
  "table":"orderitems",
  "where": "orderid,eq,12~productid,eq,3"
}
```
When sending this body in your http POST query, api will delete all items for order 12 or for product id 3

### Filters

Filters provide search functionality, on where part in your request body. You need to specify the column
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


### Multiple Operations 
Multiple operations are send if you want to make several inserts, several update and several deletes in the same operation, the http POST request body will look like this:
```JSON
[
  {
    "index":0,
    "method":"post",
    "table":"customers",
    "body":{
      "fullname":"Abubaker Shangab",
      "phone":"+249922912923"
    }
  },
  {
    "index":1,
    "method":"post",
    "table":"orders",
    "body":{
      "customerid":"__OP__0",
      "date":"2019-10-05",
      "amount":"230.00"
    }
  }
]
```
The above operation will insert a new customer and same his/her new id in `__OP__0` then it will insert a new order for this new customer and user his newly created id for the field `customerid` field value in the  `orders` table. 


### Column selection
When using ```JSON {"method":"get"}``` you can use extra data such as ```JSON {"method":"get", "fields":"comma separated fields names"}``` to get only these fields or skip using the `fields' attribute to get all columns.

```JSON 
{
  "method":"get",
  "table": "orderitems",
  "fields":"id,qty as QT,unitprice as UPRICE,totalprice, totalprice * 2 as MULTTOT"
}

```
The above request will return columns with different names, and columns manipulated as well. Like total price will be returned two times one with the same amount as totalprice and the other with a new name MULTOT as doubled amount.

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
Supports Authentication. Just use `auth=true` in your configuraiton and the api will not support any operation before sending the `login' method'.

First request to the api will be as the following:
```JSON 
{
  "method":"login",
  "table": "users",
  "where":"username,eq,username^pwd,eq,[md5 or hashed password]"
}
```
Result of the above request will be:
```JSON 
{
  "1d":'user id',
  "name": "full name",
  "phone":"phone number",
  "extrafields":"extra fields in the users table"
}
```
And the API will start a session for this user. When the session is destroyed the user will be blocked from the API.

The logout request is as follows:
```JSON 
{
  "method":"logout"
}
```
Result of the above request will be:
```
User successfully logged out !! 

```
And the API will be blocked from the current user.








### File uploads
Stay tuned...