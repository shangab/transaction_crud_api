<?php
switch ($operation['method']) {
    case 'Op_Name':
        $where = $this->getWhere($operation); // If you need the where part of the operation
		$otherdata= $operation["otherdata"]; // If you have other data in the request Object
        $this->extraopquery = "
        SELECT field1,field2...etc
        $where
        ";
        break;
}
