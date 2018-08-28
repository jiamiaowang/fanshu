<?php
require '../connect.php';
session_start();
$user_id=$_SESSION['user_id'];
$vote_id=$_GET['vote_id'];
$voterSql="select id from Voter where vote_id={$vote_id} and user_id={$user_id}";
$voterResult = mysqli_query($conn, $voterSql);

if(! $voterResult )
{
    die('无法读取数据: ' . mysqli_error($conn));
    exit();
}

if($voterResult->num_rows>0){

    $voterArray=array('isvoted'=>"1");
}
else{
	$voterArray=array('isvoted'=>"0");
}


$voter_json=json_encode($voterArray);
print_r($voter_json);


mysqli_close($conn);

?>