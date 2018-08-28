<?php
require '../connect.php';
session_start();
$user_id=$_SESSION['user_id'];

$articleTitle=$_POST['articleTitle'];
$contentStr=$_POST['contentStr'];



$headerImgSrc=$_FILES['headerImg']['tmp_name'];
$headerImgName=$_FILES['headerImg']['name'];

$headerImgExt=array_pop(explode('.', $headerImgName));
$headerImgDst='../image/'.time().mt_rand().'.'.$headerImgExt;
if(file_exists($headerImgDst))
 {
	$success=array('upload'=>'failexists');
 }
//如果上传成功
else if(move_uploaded_file($headerImgSrc,$headerImgDst)){
	$img=basename($headerImgDst);
	$articleSql="insert into article(title,user_id,headerImg,contentStr) values('{$articleTitle}','{$user_id}','{$img}','{$contentStr}')";
	$articleResult=mysqli_query($conn,$articleSql);
	if( ! $articleResult){
		$success=array('upload'=>'fail');
	}
}

if(!$success){
	if(isset($_FILES['uploadImg'])){
		$contentImg=$_FILES['uploadImg'];
	}
	if($contentImg){
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
				$image=basename($dst[$key]);
				$articleImgSql="insert into articleImg(article_id,imgSrc) values('{$getVoteID}','{$image}')";
				$articleImgResult=mysqli_query($conn,$articleImgSql);
				if( !$articleImgResult){
					$success=array('upload'=>'fails');
					break;

				}
			}
		}
		if(!$success){
			$success=array('upload'=>'success');
		}
	}
	else{
		$success=array('upload'=>'success');
	}
	
}

$article_json=json_encode($success);
print_r($article_json);


mysqli_close($conn);

?>