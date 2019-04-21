<?php
interface DbInterface
{
    public function connect();  // First
    public function auth();     // Second
    public function run();      // Third
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
    private $auth = false;
    public function __construct($hostname, $username, $password, $database, $charset, $auth)
    {
        $this->conn = mysqli_init();
        $this->hostname = $hostname;
        $this->username = $username;
        $this->password = $password;
        $this->database = $database;
        $this->charset = $charset;
        $this->auth = $auth;
        $this->res = array();
    }
    public function auth()
    {
        //AUTH is not enabled, have fun with the Database. ;-)
        if (!$this->auth) {
            return true;
        }
        //AUTH enabled start session.
        session_start();

        //Finding the intention of the programmer now.
        $login = null;
        $logout = null;
        $operations = json_decode(file_get_contents('php://input'), true);
        foreach ($operations as $operation) {
            if ($operation["method"] == "login") {
                $login = $operation;
            }
            if ($operation["method"] == "logout") {
                $logout = $operation;
            }
        }
        //impossible to NOT send login or logout request while no sesstion is there
        //programmer is joking.
        if ($login == null && $logout == null) {
            if (isset($_SESSION['loggedin']) && $_SESSION['loggedin'] === 'true') {
                return true;
            } else {
                return false;
            }
        }

        //impossible to send login and logout request at the same time
        //programmer is joking.
        if ($login !== null && $logout !== null) {
            return false;
        }
        // From here we have eithe login or logout request ONLY. Cool!
        if ($login !== null) {
            //AUTH is enabled and login required
            $sql = "SELECT * from `" . $login["table"] ."`". $this->getWhere($login);
            $stmt = $this->conn->prepare($sql);
            $stmt->execute();
            $result = $stmt->get_result();
            $row = $result->fetch_assoc();
            if ($row) {
                $_SESSION['loggedin'] = 'true';
                $_SESSION['user'] = json_encode($row);
                echo $_SESSION['user'];
                return true;
            } else {
                echo json_encode('{"id":0, "message":"No such user."}');
                return false;
            }
            $conn->close();
        }
        
        
        if ($logout !== null) {
            //AUTH is enabled and logout required
            session_unset();
            session_destroy();
            return false;
        }

        //If you are here then you are a hacker, have a good time with this big FALSE.
        return false;
    }
    private function getWhere($operation)
    {
        $where = "";
        $satisfy = $operation["satisfy"] == "all" ? " AND " : " OR ";
        $where_array = explode(";", $operation['where']);
        foreach ($where_array as $item) {
            if (!$item) {
                break;
            }
            if (strlen($where) > 0) {
                $where .= $satisfy . $this->getOperand($item);
            } else {
                $where = " WHERE " . $this->getOperand($item);
            }
        }
        return $where;
    }
    private function getOperand($item)
    {
        $field = explode(",", $item);
        switch ($field[1]) {
            case 'eq':
                return "`".$field[0]."`" . " = '" . $field[2] . "' ";
                break;
            case 'neq':
                return "`".$field[0]."`" . " != '" . $field[2] . "' ";
                break;
            case 'gt':
                return "`".$field[0]."`" . " > " . $field[2];
                break;
            case 'lt':
                return "`".$field[0]."`" . " < " . $field[2];
                break;
            case 'gte':
                return "`".$field[0]."`" . " >= " . $field[2];
                break;
            case 'lte':
                return "`".$field[0]."`" . " <= " . $field[2];
                break;
            case 'cs':
                return " INSTR (" . "`".$field[0]."`" . ",'" . $field[2] . "') ";
                break;
            case 'bt':
                return "`".$field[0]."`" . " BETWEEN " . $field[2] . " AND " . $field[3];
                break;
            case 'in':
                $result = "`".$field[0]."`" . " in (";
                for ($i = 2; $i < sizeof($field); $i++) {
                    $result .= "'".$field[$i] . "',";
                }
                $result = substr($result, 0, strlen($result) - 1) . ") ";
                return $result;
                break;
            default:
                return null;
                break;
        }
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
        if (!$this->auth()) {
            return;
        }
        $operations = json_decode(file_get_contents('php://input'), true);
        if (sizeof($operations) >1) {
            foreach ($operations as $operation) {
                $this->doOperation($operation);
            }
        } else {
            if (sizeof($operations)==1) {
                $this->doOperation($operations[0]);
            }
        }
        
        $this->conn->close();
        echo json_encode($this->res);
    }
    
    public function doOperation($operation)
    {
        switch ($operation['method']) {
            case 'get':
                $sql = "SELECT * from `" . $operation['table']."`";
                $where = $this->getWhere($operation);
                $sql = $sql . $where;
                #echo ($sql);
                $stmt = $this->conn->prepare($sql);
                $stmt->execute();
                $result = $stmt->get_result();
                while ($r = $result->fetch_assoc()) {
                    array_push($this->res, $r);
                }
                break;
            case 'fieldsnames':
                $sql = "SELECT  `COLUMN_NAME` as col FROM `INFORMATION_SCHEMA`.`COLUMNS` WHERE `TABLE_SCHEMA`='". $this->database."'   AND `TABLE_NAME`='" . $operation['table']."'";
                $stmt = $this->conn->prepare($sql);
                $stmt->execute();
                $result = $stmt->get_result();
                while ($r = $result->fetch_assoc()) {
                    array_push($this->res, $r['col']);
                }
                break;
           
            case 'post':
                $sql = "INSERT INTO `" . $operation['table']."`";
                $keys = "";
                $values = "";
                foreach ($operation['body'] as $key => $value) {
                    if ($value!=null) {
                        $keys = $keys. "`" . $key . "`,";
                        $values = $values . "'" . $this->getDeferedValue($value) . "',";
                    }
                }
                $keys = substr($keys, 0, strlen($keys) - 1);
                $values = substr($values, 0, strlen($values) - 1);
                $sql = $sql . ' (' . $keys . ') VALUES (' . $values . ')';
                #echo ($sql);
                if ($this->conn->query($sql) === true) {
                    $postres = $this->conn->insert_id;
                } else {
                    $postres = 0;
                }

                array_push($this->res, array("index" => $operation["index"], "result" => $postres));
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
                array_push($this->res, array("index" => $operation["index"], "result" => $putres));
                break;
            case 'delete':
                $sql = "DELETE from `" . $operation['table']."`";
                $satisfy = $operation["satisfy"] == "all" ? " AND " : " OR ";
                $where = $this->getWhere($operation);
                $sql = $sql . $where;
                if ($this->conn->query($sql) === true) {
                    $delres = mysqli_affected_rows($this->conn);
                } else {
                    $delres = 0;
                }
                array_push($this->res, array("index" => $operation["index"], "result" => $delres));
                break;
            default:
                break;
        }
    }
}

class DbFactory
{
    private $config;

    public function __construct($config)
    {
        header('Access-Control-Allow-Origin: *');
        header('Access-Control-Allow-Methods: POST');
        header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');
        header('Content-Type: application/json;charset=utf-8');
        $this->config = $config;
    }
    public function execute()
    {
        extract($this->config);
        switch ($dbengine) {
            case 'MySQL':
                $mysql = new MySQL($hostname, $username, $password, $database, $charset, $auth);
                if ($mysql->connect()) {
                    $mysql->run();
                } else {
                    echo("Connection to $hostname database $database failed. Invsales Web serivice");
                }
                break;
            default:
                break;
        }
    }
}
        
if (stripos($_SERVER['REQUEST_URI'], 'localhost')!=="false") {
    $api = new DbFactory(array(
        'dbengine'=>'MySQL',
        'hostname'=>'localhost',
        'username'=>'root',
        'password'=>'',
        'database'=>'salesdove',
        'charset'=>'utf8mb4',
        'auth' =>false,
    ));
    $api->execute();
} else {
    $api = new DbFactory(array(
        'dbengine'=>'MySQL',
        'hostname'=>'79.170.40.244',
        'username'=>'cl23-invsales',
        'password'=>'krWqg3-ff',
        'database'=>'cl23-invsales',
        'charset'=>'utf8mb4',
        'auth' =>false,
    ));
    $api->execute();
}
