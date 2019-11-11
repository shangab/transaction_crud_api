<?php
interface DbInterface
{
    public function connect();  // First
    public function run();      // Second
    public function doAuth();     // Third
}

class MySQL implements DbInterface
{
    private $conn;
    private $res;
    private $hostname = "";
    private $username = "";
    private $password = "";
    private $database = "";
    private $charset = "";
    private $extraoperations = "";
    private $auth = false;
    public function __construct($hostname, $username, $password, $database, $charset, $extraoperations, $auth)
    {
        $this->conn = mysqli_init();
        $this->hostname = $hostname;
        $this->username = $username;
        $this->password = $password;
        $this->database = $database;
        $this->charset = $charset;
        $this->extraoperations = $extraoperations;
        $this->auth = $auth;
        $this->res = array();
    }

    private function getWhere($operation)
    {
        if (!isset($operation["where"]) || empty($operation["where"])) {
            return "";
        }

        $where = $operation['where'];
        $tokens = $this->multiexplode(array("^", "~", "(", ")"), $where);
        $where = str_replace("^", " AND ", $where);
        $where = str_replace("~", " OR ", $where);
        foreach ($tokens as $item) {
            if (!empty($item)) {
                $where = str_replace($item, $this->getOperand($item), $where);
            }
        }
        return ' WHERE ' . $where;
    }
    private function getOperand($item)
    {
        $field = explode(",", $item);
        switch (trim($field[1])) {
            case 'eq':
                return "`" . trim($field[0]) . "`" . " = '" . trim($field[2]) . "' ";
                break;
            case 'neq':
                return "`" . trim($field[0]) . "`" . " != '" . trim($field[2]) . "' ";
                break;
            case 'isnull':
                return "`" . trim($field[0]) . "` is null ";
                break;
            case 'gt':
                return "`" . trim($field[0]) . "`" . " > " . trim($field[2]);
                break;
            case 'lt':
                return "`" . trim($field[0]) . "`" . " < " . trim($field[2]);
                break;
            case 'gte':
                return "`" . trim($field[0]) . "`" . " >= " . trim($field[2]);
                break;
            case 'lte':
                return "`" . trim($field[0]) . "`" . " <= " . trim($field[2]);
                break;
            case 'cs':
                return " INSTR (" . "`" . trim($field[0]) . "`" . ",'" . trim($field[2]) . "') ";
                break;
            case 'bt':
                return "`" . trim($field[0]) . "`" . " BETWEEN '" . trim($field[2]) . "' AND '" . $field[3] . "' ";
                break;
            case 'in':
                $result = "`" . trim($field[0]) . "`" . " in (";
                for ($i = 2; $i < sizeof($field); $i++) {
                    $result .= "'" . $field[$i] . "',";
                }
                $result = substr($result, 0, strlen($result) - 1) . ") ";
                return $result;
                break;
            default:
                return null;
                break;
        }
    }
    private function multiexplode($delimiters, $string)
    {
        $ready = str_replace($delimiters, $delimiters[0], $string);
        $launch = explode($delimiters[0], $ready);
        return  $launch;
    }
    private function getDeferedValue($value)
    {
        if (substr($value, 0, 4) == '__OP') {
            $index = substr($value, 6);
            foreach ($this->res as $opres) {
                if ($opres['index'] == $index) {
                    return $opres['result'];
                }
            }
        } else {
            return $value;
        }
    }
    public function connect()
    {
        $success = mysqli_real_connect($this->conn, $this->hostname, $this->username, $this->password, $this->database, null, null, MYSQLI_CLIENT_FOUND_ROWS);
        if (!$success || !mysqli_set_charset($this->conn, $this->charset)) {
            return false;
        } else {
            return true;
        }
    }
    public function run()
    {
        $requestmethod = $_SERVER['REQUEST_METHOD'];
        $operationsraw = trim(file_get_contents('php://input'));
        $ops = json_decode($operationsraw, true);


        if ($requestmethod == 'GET' || $requestmethod == 'DELETE') {
            $op = array("table" => "", "method" => "",  "where" => "", "order" => "", "fields" => "");
            $op["table"] = $_GET["table"];
            $op["fields"] =  isset($_GET["fields"]) ? $_GET["fields"] : "*";
            $op["where"] =  isset($_GET["where"]) ? $_GET["where"] : "";
            $op["order"] =  isset($_GET["order"]) ? $_GET["order"] : "";
        }

        switch ($requestmethod) {
            case 'GET':
                $op["method"] = "get";
                $this->doOperation($op, false);
                echo json_encode($this->res);
                break;
            case 'DELETE':
                $op["method"] = "delete";
                $this->doOperation($op, false);
                echo json_encode($this->res[0]);
                break;
            case 'PUT':
                $op["method"] = "put";
                $this->doOperation($op, false);
                echo json_encode($this->res[0]);
                break;
            case 'POST':
                if (substr($operationsraw, 0, 1) === "[") {
                    foreach ($ops as $op) {
                        $this->doOperation($op, true);
                    }
                } else {
                    $this->doOperation($ops, false);
                }
                echo json_encode($this->res);
                break;
        }
        $this->conn->close();
    }
    private function getApiToken()
    {
        foreach (getallheaders() as $key => $value) {
            if ($key == 'APITOKEN') {
                return $value;
            }
        }
        return "";
    }
    public function doAuth()
    {
        if (!$this->auth) {
            return true;
        }
        $apitoken = $this->getApiToken();
        $stmt = $this->conn->prepare("select * from tokens where token ='$apitoken'");
        $stmt->execute();
        $result = $stmt->get_result();
        $row = $result->fetch_assoc();
        if ($row) {
            return true;
        } else {
            $resobj = json_encode(array('status' => false, 'message' => 'Unauthorized Aceess.'), JSON_FORCE_OBJECT);
            array_push($this->res, json_decode($resobj));
            return false;
        }
    }
    public function doOperation($operation, $transop)
    {

        switch ($operation['method']) {
            case 'login':
                $sql = "SELECT * from `" . $operation["table"] . "`" . $this->getWhere($operation);
                $stmt = $this->conn->prepare($sql);
                $stmt->execute();
                $result = $stmt->get_result();
                $row = $result->fetch_assoc();
                if ($row) {
                    if ($this->auth) {
                        $tokenlifetime = date("Y-m-d H:i:s", time() + $operation["tokenlifetime"]);
                        $token = bin2hex(random_bytes(64));
                        $query = "insert into tokens (tokenlifetime, token) values ('$tokenlifetime','$token')";
                        if ($this->conn->query($query) === true) {
                            $row["token"] = $token;
                            $row["tokenlifetime"] = $tokenlifetime;
                        }
                    }
                    array_push($this->res, $row);
                }
                return;
                break;
            case 'logout':
                if ($this->auth) {
                    $apitoken = $this->getApiToken();
                    if ($this->conn->query("delete from tokens where token='$apitoken'") === true) {
                        $resobj = json_encode(array('status' => true, 'message' => 'Successfully logout out'), JSON_FORCE_OBJECT);
                    } else {
                        $resobj = json_encode(array('status' => true, 'message' => 'Can not Successfully log out'), JSON_FORCE_OBJECT);
                    }
                    array_push($this->res, json_decode($resobj));
                    return;
                }
                break;
            default:
                if (!$this->doAuth()) {
                    return;
                }
                break;
        }

        switch ($operation['method']) {
            case 'get':
                $fields = isset($operation["fields"]) && !empty($operation["fields"]) ? $operation["fields"] : "*";
                $order = isset($operation["order"]) && !empty($operation["order"]) ? " ORDER BY " . $operation["order"] : "";
                $sql = "SELECT $fields from `" . $operation['table'] . "`";
                $where = $this->getWhere($operation);
                $sql = $sql . $where . $order;
                $stmt = $this->conn->prepare($sql);
                $stmt->execute();
                $result = $stmt->get_result();
                $getres = array();
                while ($r = $result->fetch_assoc()) {
                    array_push($getres, $r);
                }
                if ($transop) {
                    array_push($this->res, array("index" => $operation["index"], "result" => $getres));
                } else {
                    $this->res = $getres;
                }
                break;
            case 'fieldsnames':
                $sql = "SELECT  `COLUMN_NAME` as col FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA`='" . $this->database . "'   AND `TABLE_NAME`='" . $operation['table'] . "'";
                $stmt = $this->conn->prepare($sql);
                $stmt->execute();
                $result = $stmt->get_result();
                $rescols = array();
                while ($r = $result->fetch_assoc()) {
                    array_push($rescols, $r['col']);
                }
                if ($transop) {
                    array_push($this->res, array("index" => $operation["index"], "result" => $rescols));
                } else {
                    $this->res = $rescols;
                }
                break;
            case 'post':
                $sql = "INSERT INTO `" . $operation['table'] . "`";
                $keys = "";
                $values = "";
                foreach ($operation['body'] as $key => $value) {
                    $keys = $keys . "`" . $key . "`,";
                    $values = $values . "'" . $this->getDeferedValue($value) . "',";
                }
                $keys = substr($keys, 0, strlen($keys) - 1);
                $values = substr($values, 0, strlen($values) - 1);
                $sql = $sql . ' (' . $keys . ') VALUES (' . $values . ')';
                // die ($sql);
                if ($this->conn->query($sql) === true) {
                    $postres = $this->conn->insert_id;
                } else {
                    $postres = 0;
                }
                if ($transop) {
                    array_push($this->res, array("index" => $operation["index"], "result" => $postres));
                } else {
                    array_push($this->res, $postres);
                }
                break;
            case 'put':
                $sql = "UPDATE `" . $operation['table'] . "` SET ";
                foreach ($operation['body'] as $key => $value) {
                    $sql = $sql . $key . " = '" . $this->getDeferedValue($value) . "',";
                }
                $where = $this->getWhere($operation);
                $sql = substr($sql, 0, strlen($sql) - 1) . $where;

                if ($this->conn->query($sql) === true) {
                    $putres = mysqli_affected_rows($this->conn);
                } else {
                    $putres = 0;
                }
                if ($transop) {
                    array_push($this->res, array("index" => $operation["index"], "result" => $putres));
                } else {
                    array_push($this->res, $putres);
                }

                break;
            case 'delete':
                $sql = "DELETE from `" . $operation['table'] . "`";
                $where = $this->getWhere($operation);
                $sql = $sql . $where;
                if ($this->conn->query($sql) === true) {
                    $delres = mysqli_affected_rows($this->conn);
                } else {
                    $delres = 0;
                }
                if ($transop) {
                    array_push($this->res, array("index" => $operation["index"], "result" => $delres));
                } else {
                    array_push($this->res, $delres);
                }
                break;
        }
        if (!empty($this->extraoperations)) {
            include $this->extraoperations;
        }
    }
}

class DbFactory
{
    private $config;

    public function __construct($config)
    {
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: GET, PUT, POST, DELETE');
        header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token, APITOKEN');
        header('Content-Type: application/json;charset=utf-8');
        $this->config = $config;
    }
    public function execute()
    {
        extract($this->config);
        switch ($dbengine) {
            case 'MySQL':
                $mysql = new MySQL($hostname, $username, $password, $database, $charset, $extraoperations, $auth);
                if ($mysql->connect()) {
                    $mysql->run();
                } else {
                    echo ("Connection to $hostname database $database failed. Invsales Web serivice");
                }
                break;
            default:
                break;
        }
    }
}
if ($_SERVER['HTTP_HOST'] === 'localhost') {
    $api = new DbFactory(array(
        'dbengine' => 'MySQL',
        'hostname' => 'localhost',
        'username' => 'root',
        'password' => '',
        'database' => 'mafraza',
        'charset' => 'utf8mb4',
        'extraoperations' => 'apiExtraOperations.php',
        'auth' => true,
    ));
    $api->execute();
} else {
    $api = new DbFactory(array(
        'dbengine' => 'MySQL',
        'hostname' => '<IP Address>',
        'username' => '<username>',
        'password' => '<password>',
        'database' => '<db name>',
        'charset' => 'utf8mb4',
        'extraoperations' => 'apiExtraOperations.php',
        'auth' => true,
    ));
    $api->execute();
}
