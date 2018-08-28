<?php
require '../connect.php';
session_start();
$user_id=$_SESSION['user_id'];
$voteTitle=$_POST['voteTitle'];
$voteOption=$_POST['voteOption'];
// $voteImg=$_FILES['uploadImg'];

$titleSql="insert into vote(title,user_id,isHaveImg) values('{$voteTitle}','{$user_id}','1')";
$titleResult=mysqli_query($conn,$titleSql);
if( ! $titleResult ){
	$success=array('upload'=>'fails');
}
else{
	$getVoteID=mysqli_insert_id($conn);
	$imgSrc=$_FILES['uploadImg']['tmp_name'];
	$imgName=$_FILES['uploadImg']['name'];

	foreach ($imgName as $key => $value) {
		$ext=array_pop(explode('.', $value));
		$dst[$key]='../image/'.time().mt_rand().'.'.$ext;
		if(file_exists($dst[$key]))
		  {
			$success=array('upload'=>'failexists');
		  }
		//如果上传成功
		else if(move_uploaded_file($imgSrc[$key],$dst[$key])){
			$img=basename($dst[$key]);
			$name=$voteOption[$key]['name'];
			$optionSql="insert into voteOptions(vote_id,name,imageStr) values('{$getVoteID}','{$name}','{$img}')";
			$optionResult=mysqli_query($conn,$optionSql);
			if( ! $optionResult){
				$success=array('upload'=>'fail');
				break;

			}
		}
		else{
			$success=array('upload'=>'failss');
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