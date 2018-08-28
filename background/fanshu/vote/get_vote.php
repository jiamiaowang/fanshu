<?php
require '../connect.php';

$voteSql='select id,title,isHaveImg from vote';

$voteResult = mysqli_query($conn, $voteSql);

if(! $voteResult )
{
    die('无法读取数据: ' . mysqli_error($conn));
    exit();
}

$j=0;
while($voteRow = mysqli_fetch_array($voteResult, MYSQL_ASSOC))
{
    $voteList[$j]=$voteRow;
    $j++;
    
}

$voteArray=array('vote'=>$voteList);

$vote_json=json_encode($voteArray);
print_r($vote_json);


mysqli_close($conn);

?>