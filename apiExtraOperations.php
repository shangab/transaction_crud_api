<?php
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
