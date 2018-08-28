<?php
require '../connect.php';

$vote_id=$_GET['vote_id'];

$sql="select * from voteOptions where vote_id={$vote_id}";
$result = mysqli_query($conn, $sql );
if(! $result )
{
    die('无法读取数据: ' . mysqli_error($conn));
    exit();
}
$j=0;
// $vote=[];
while($row = mysqli_fetch_array($result, MYSQL_ASSOC))
{
    $optionsList[$j]=$row;
    $optionsList[$j]['imageStr']="http://127.0.0.1/fanshu/image/".$row['imageStr'];
    
    $j++;
    
}
$optionsArray=array('options'=>$optionsList);
// $vo=array_merge($vote,$a);

$options_json=json_encode($optionsArray);
print_r($options_json);


mysqli_close($conn);
?>