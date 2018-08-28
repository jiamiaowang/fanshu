<?php
require '../connect.php';
session_start();
$user_id=$_SESSION['user_id'];
$sql="select avatar,username from user where id='{$user_id}'";
$result = mysqli_query($conn, $sql );
if( !$result){
	$successArray=array('success'=>"fail");
}
else{
	$resultArray = mysqli_fetch_array($result, MYSQL_ASSOC);
	if($resultArray['avatar']){
		$resultArray['avatar']="http://127.0.0.1/fanshu/image/".$resultArray['avatar'];
	}
	
	
}
$success_json=json_encode($resultArray);
print_r($success_json);
mysqli_close($conn);
?>