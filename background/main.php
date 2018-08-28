<?php
require 'connect.php';

$hotSql='select headerImg from article where isHot=1';
$hotResult=mysqli_query($conn,$hotSql);

$voteSql='select id,title,isHaveImg from vote LIMIT 3';
$voteResult = mysqli_query($conn, $voteSql);

$articleSql='select id,title,headerImg from article LIMIT 3';
$articleResult = mysqli_query($conn, $articleSql);


if(! $voteResult || !$articleResult )
{
    die('无法读取数据: ' . mysqli_error($conn));
    exit();
}
$i=0;
while ($hotRow=mysqli_fetch_array($hotResult,MYSQL_ASSOC)) {
	// $hotList[$i]=$hotRow;
	$hotList[$i]['headerImg']="http://127.0.0.1/fanshu/image/".$hotRow['headerImg'];
	$i++;
}
$hotArray=array('hot'=>$hotList);

$j=0;
while($voteRow = mysqli_fetch_array($voteResult, MYSQL_ASSOC))
{
    $voteList[$j]=$voteRow;
    $j++;
    
}
$voteArray=array('vote'=>$voteList);

$k=0;
while($articleRow = mysqli_fetch_array($articleResult, MYSQL_ASSOC))
{
    $articleList[$k]=$articleRow;
    $articleList[$k]['headerImg']="http://127.0.0.1/fanshu/image/".$articleRow['headerImg'];
    $k++;
    
}
$articleArray=array('article'=>$articleList);

$voteAndArticle=array_merge($hotArray,$voteArray,$articleArray);

$vote_json=json_encode($voteAndArticle);
print_r($vote_json);


mysqli_close($conn);

?>