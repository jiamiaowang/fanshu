<?php
require '../connect.php';

$articleSql='select id,title,headerImg from article ';
$articleResult = mysqli_query($conn, $articleSql);

if(! $articleResult )
{
    die('无法读取数据: ' . mysqli_error($conn));
    exit();
}

$j=0;
while($articleRow = mysqli_fetch_array($articleResult, MYSQL_ASSOC))
{
    $articleList[$j]=$articleRow;
    $articleList[$j]['headerImg']="http://127.0.0.1/fanshu/image/".$articleRow['headerImg'];
    $j++;
    
}

$articleArray=array('article'=>$articleList);

$article_json=json_encode($articleArray);
print_r($article_json);


mysqli_close($conn);

?>