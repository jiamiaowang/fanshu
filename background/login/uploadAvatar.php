<?php
require '../connect.php';
session_start();
$user_id=$_SESSION['user_id'];

$src=$_FILES['avatarImg']['tmp_name'];
$name=$_FILES['avatarImg']['name'];

$ext=array_pop(explode('.', $name));
$dst='../image/'.time().mt_rand().'.'.$ext;
if(file_exists($dst))
 {
	$success=array('upload'=>'failexists');
 }
//如果上传成功
else if(move_uploaded_file($src,$dst)){
	$img=basename($dst);
	$sql="update user set avatar='{$img}' where id='{$user_id}' ";
	$result=mysqli_query($conn,$sql);
	if( ! $result){
		$success=array('upload'=>'fail');
	}
}
if(!$success){
	$success=array('upload'=>'success');
}
$success_json=json_encode($success);
print_r($success_json);
mysqli_close($conn);
?>