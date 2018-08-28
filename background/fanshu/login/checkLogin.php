<?php
require '../connect.php';
session_start();
if(isset($_POST['account']) && isset($_POST['password'])){
	$account=$_POST['account'];
	$password=$_POST['password'];
}
else{
	echo '非法请求';
	return false;
}
$sql="select password,id from user where account='{$account}'";
$result = mysqli_query($conn, $sql );
if( !$result){
	$successArray=array('success'=>"fail");
}
else{
	$resultArray = mysqli_fetch_array($result, MYSQL_ASSOC);
	$pwd=$resultArray['password'];
	// 服务器记录的密码itcast
	$hmacKey=md5('fanshu');
	$hmacKey = strtoupper($hmacKey);
    $recordPwd = hash_hmac('sha256', $pwd, $hmacKey);
    // 取出当前系统时间
    date_default_timezone_set('Asia/Shanghai');
    $now = time();
    $pre = $now - 60;
    $nowStr = date('Y-m-d H:i', $now);
    $preStr = date('Y-m-d H:i', $pre);
    $hmacPwd1 = hash_hmac('sha256', $recordPwd . $nowStr, $hmacKey);
    $hmacPwd2 = hash_hmac('sha256', $recordPwd . $preStr, $hmacKey);
    if($password==$hmacPwd1 || $password==$hmacPwd2){
    	$successArray=array('success'=>'success');

        $_SESSION['user_id']=$resultArray['id'];

    }
    else{
    	$successArray=array('success'=>'fail');
    }

}

$success_json=json_encode($successArray);
print_r($success_json);
mysqli_close($conn);
?>