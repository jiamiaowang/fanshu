<?php
require '../connect.php';
session_start();
$user_id=$_SESSION['user_id'];

$option_id=$_GET['option_id'];
$vote_id=$_GET['vote_id'];
$sql="update voteOptions set poll=poll+1 where id={$option_id}";
$result = mysqli_query($conn, $sql);
$voterSql="insert into Voter(user_id,vote_id) values('{$user_id}','{$vote_id}')";
$voterResult=mysqli_query($conn,$voterSql);
if(!$result & !$voterResult)
{
    die('无法读取数据: ' . mysqli_error($conn));
    exit();
}
$sucessArray=array('sucess'=>1);
$sucess_json=json_encode($sucessArray);
print_r($sucess_json);
mysqli_close($conn);
?>