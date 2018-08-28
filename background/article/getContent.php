<?php
require '../connect.php';
$article_id=$_GET['articleID'];
$articleSql="select contentStr from article where article.id={$article_id} ";
$articleResult = mysqli_query($conn, $articleSql);

if(! $articleResult )
{
    die('无法读取数据: ' . mysqli_error($conn));
    exit();
}

$articleContent = mysqli_fetch_array($articleResult, MYSQL_ASSOC);
// $articleArray=array('contentStr'=>$articleContent);

$imageSql="select imgSrc from articleImg where article_id={$article_id}";
$imageReslut=mysqli_query($conn, $imageSql);
if($imageReslut->num_rows>0){
   $j=0;
   while($row = mysqli_fetch_array($imageReslut, MYSQL_ASSOC))
	{
	    // $contentImg[$j]=$row;
	    $contentImg[$j]="<img src=\"http://127.0.0.1/fanshu/image/".$row['imgSrc']."\"";
	    $imgInfo=getimagesize('../image/'.$row['imgSrc']);
		$contentImg[$j].=$imgInfo[3].">";
	    $j++;
	    
	}
}

$contentImgArr=array('imgArr'=>$contentImg);
$contentArray=array_merge($articleContent,$contentImgArr);


$article_json=json_encode($contentArray);
print_r($article_json);


mysqli_close($conn);

?>