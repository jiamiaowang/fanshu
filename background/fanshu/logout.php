<?php
header("Content-type: application/json; charset=utf-8");

session_start();
unset($_SESSION['user_id']);
$success=array('success'=>'success');
$success_json=json_encode($success);
print_r($success_json);

?>