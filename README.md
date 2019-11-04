# Transaction_CRUD_Api
Thanks to the project [https://github.com/mevdschee/php-crud-api](https://github.com/mevdschee/php-crud-api) as it was my inspiration to create this one.

A CRUD API for many MySQL Systems, and others in the future

Single file PHP 5.6 script that adds a REST API to a MySQL 5.6 InnoDB, MariaDB databases. 

## Requirements

  - PHP 5.6 or higher with PDO drivers for MySQL, PgSQL, Oracle or SqlSrv enabled

## Features

The following features are supported:

  - Single PHP file, easy to deploy.
  - Very little code, easy to adapt and maintain
  - Supports GET, POST, PUT, DELETE and customized operations
  - Supports a JSON object as input
  - Supports a JSON array as input (batch operations)
  - Multi-domain CORS support for cross-domain requests
  - Search support on multiple criteria
  
## Installation

This is a single file application! Upload "`api.php`" somewhere and enjoy!

## Use our demodb.sql
The file demodb.sql contains a demo database having 4 tables.
Install WampServer or Xampserver and then run the SQL in this file.
It will setup the demodb with 4 tables:
- products: is a lookup table contain id,name for 3 products only as example.
- customers: is a table contains 100 fake customers with fields: id, fullname and phone.
- orders: is a table contains 100 orders for the customers with fields: id,date, customerid and amount
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
To read data using the GET method, see this example:

```
http://localhost/site/api.php?table=orders&method=get&order=customerid asc,amount desc&fields=id,customerid,amount&where=customerid,bt,1,5
```
this will get from the table `orders`, orders of customers between 1 and 5, it will select `fields: id, customerid, amount` ony and order the result by customerid assending and amount descending.

Result will look like this:

```JSON
[
    {
        "id": 76,
        "customerid": 1,
        "amount": "467.00"
    },
    {
        "id": 27,
        "customerid": 1,
        "amount": "457.00"
    },
    {
        "id": 34,
        "customerid": 1,
        "amount": "366.00"
    },
    {
        "id": 37,
        "customerid": 1,
        "amount": "356.00"
    },
    ...ect
]
```

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
You can use the `DELETE` http request like so:

`DELETE http://www.domainname.com/api.php?table=orders&where=amount,isnull`
This will delete all orders with null amount.

Or to delete rows use the following JSON as your POST http request: 
```JSON
{
  "method":"delete",
  "table":"orderitems",
  "where": "orderid,eq,12~productid,eq,3"
}
```
When sending this body in your http POST query, api will delete all items for order 12 or for product id 3

#### Extra Operations

Extra operations is when you need more customized get query that may return JSON array that contains sub arrays.
In our apiExtraOperations we have the following operation `get_one_order` that will look like this:
```PHP
switch ($operation['method']) {
    case 'get_one_order':
        $orderid=$operation["orderid"];
        $sql = "
        SELECT *,
        (SELECT CONCAT('[',GROUP_CONCAT('{','\"id\":',id,',\"orderid\":',orderid,',\"productid\":',productid,',\"qty\":',qty,',\"unitprice\":',unitprice,',\"totalprice\":',totalprice,'}'),']') from orderitems i where i.orderid=o.id) as items
        from orders o where o.id=  $orderid
        ";
        $stmt = $this->conn->prepare($sql);
        $stmt->execute();
        $result = $stmt->get_result();
        while ($r = $result->fetch_assoc()) {
            $r["items"]= json_decode($r["items"]);
            array_push($this->res, $r);
        }
        break;
}
```
This operation beside the name 'get_one_order` it has another parameter that takes the order id. Like so:

```JSON
{
  "method":"get_one_order",
  "orderid": "1"
}
```
When you run this body in your http POST request. The API returns the folloing result:

```JSON
[
    {
        "id": 1,
        "customerid": 4,
        "date": "2019-01-01 10:48:48",
        "amount": "262.00",
        "items": [
            {
                "id": 72,
                "orderid": 1,
                "productid": 1,
                "qty": 5,
                "unitprice": 21,
                "totalprice": 105
            },
            {
                "id": 132,
                "orderid": 1,
                "productid": 1,
                "qty": 2,
                "unitprice": 31,
                "totalprice": 62
            },
            {
                "id": 249,
                "orderid": 1,
                "productid": 2,
                "qty": 5,
                "unitprice": 19,
                "totalprice": 95
            }
        ]
    }
]
```

### Filters

Filters provide search functionality, on where part in your request body. You need to specify the column
name, a comma, the match type, another commma and the value you want to filter on. These are supported match types:

  - "^": CTR+6 is used in the `where` attribute and it means logical AND
  - "~": Tilda is used in the `where` attribute and it means logical OR
  - "cs": contain string (string contains value)
  - "isnull": where the mentioned field is null example: `where=amount,isnull`;
  - "eq": equal (string or number date matches exactly)
  - "neq": Not equal (string or number date NOT matches exactly)
  - "gt": greater than (string or number date is higher than value)
  - "lt": lower than (string or number date is lower than value)
  - "gte": greater or equal (string or number date is higher than or equal to value)
  - "lte": lower or equal (string or number date is lower than or equal to value)
  - "bt": between (string or number date is between two comma separated values)
  - "in": in (string or number date is in comma separated list of values)
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
When using ```{"method":"get"}``` you can use extra data such as ```{"method":"get", "fields":"comma separated fields names"}``` to get only these fields or skip using the `fields' attribute to get all columns.

```JSON 
{
  "method":"get",
  "table": "orderitems",
  "fields":"id,qty as QT,unitprice as UPRICE,totalprice, totalprice * 2 as MULTTOT"
}

```
The above request will return columns with different names, and columns manipulated as well. Like total price will be returned two times one with the same amount as totalprice and the other with a new name MULTOT as doubled amount.
```JSON
[
    {
        "id": 1,
        "QT": 5,
        "UPRICE": "23.00",
        "totalprice": "115.00",
        "MULTTOT": "230.00"
    },
    {
        "id": 2,
        "QT": 4,
        "UPRICE": "13.00",
        "totalprice": "52.00",
        "MULTTOT": "104.00"
    }
    ...etc
```

### Ordering

When using the GET method or the POST method with attribute `method=get`, you can use attribute `order` to include ordering by columns like this: `order=fld1 asc, fld2 desc, fld3 asc...etc`;

### Limit size
Stay tuned...

### Pagination
Stay tuned...

### Transaction Operations
Stay tuned...

### Spatial support
Stay tuned...

### Authentication
Supports Authentication. Just use `auth=>true` in your configuraiton and the api will not support any operation before sending the `login` method'.

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
  "1d":"user id",
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

### License

MIT License

Copyright (c) 2019 Maurits van der Schee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.