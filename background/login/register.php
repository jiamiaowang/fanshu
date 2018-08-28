<?php
session_start();
require '../connect.php';
if(isset($_POST['account']) && isset($_POST['password']) &&isset($_POST['username'])){
    $account=$_POST['account'];
    $password=$_POST['password'];
    $username=$_POST['username'];
}
else{
    echo '非法请求';
    return false;
}

$accountSql="select username from user where account='{$account}'";
$accountReslut=mysqli_query($conn,$accountSql);
if($accountReslut->num_rows>0){

    $successArray=array('isSuccess'=>'already');
}
else{
    $sql="insert into user(account,username,password) values('{$account}','{$username}','{$password}')";
    $result=mysqli_query($conn,$sql);
    if(!$result){
        $successArray=array('isSuccess'=>'fail');
    }
    else{
        $successArray=array('isSuccess'=>'success');
        $getID=mysqli_insert_id($conn);
        $_SESSION['user_id']=$getID;
        

    }
}

$success_json=json_encode($successArray);
print_r($success_json);
mysqli_close($conn);
?>
