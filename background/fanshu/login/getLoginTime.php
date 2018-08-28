<?php
header("Content-type: application/json; charset=utf-8");
date_default_timezone_set('Asia/Shanghai');
$now=time();
$nowStr = date('Y-m-d H:i', $now);
$timeArray=array("time"=>$nowStr);
$time_json=json_encode($timeArray);
print_r($time_json);
?>