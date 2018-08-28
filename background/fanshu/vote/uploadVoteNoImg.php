<?php
require '../connect.php';
session_start();
$user_id=$_SESSION['user_id'];
$voteTitle=$_POST['voteTitle'];
$voteOption=$_POST['voteOption'];
// $voteImg=$_FILES['uploadImg'];

$titleSql="insert into vote(title,user_id,isHaveImg) values('{$voteTitle}','{$user_id}','0')";
$titleResult=mysqli_query($conn,$titleSql);
if( ! $titleResult ){
	$success=array('upload'=>'fails');
}
else{
	$getVoteID=mysqli_insert_id($conn);
	
	foreach ($voteOption as $key => $value) {

		$name=$voteOption[$key]['name'];
		$optionSql="insert into voteOptions(vote_id,name) values('{$getVoteID}','{$name}')";
		$optionResult=mysqli_query($conn,$optionSql);
		if( ! $optionResult){
			$success=array('upload'=>'fail');
			break;

		}
		
	}
	if(!$success){
		$success=array('upload'=>'success');

	}

}

$voteUpload_json=json_encode($success);
print_r($voteUpload_json);

mysqli_close($conn);

?>