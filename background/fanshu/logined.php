<?php 
require 'connect.php';
//判断是否登录过
session_start();
$account=$_POST['account'];
$sql="select id from user where account={$account}";
$result = mysqli_query($conn, $sql );
if( !$result){
	$successArray=array('success'=>"fail");
}
else{
	$resultArray = mysqli_fetch_array($result, MYSQL_ASSOC);
	$_SESSION['user_id']=$resultArray['id'];
	$successArray=array('success'=>"success");

}

$loginJson=json_encode($successArray);
print_r($loginJson);
mysqli_close($conn);
?>