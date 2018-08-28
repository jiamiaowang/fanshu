<?php

$dbhost = '127.0.0.1';  // mysql服务器主机地址
$dbuser = 'root';            // mysql用户名
$dbpass = 'jmwang';          // mysql用户名密码
$dbname="fanshu";
$conn = mysqli_connect($dbhost, $dbuser, $dbpass,$dbname);
if(! $conn )
{
    die('Could not connect: ' . mysqli_error());
}
header("Content-type: application/json; charset=utf-8");

// 设置编码，防止中文乱码
mysqli_query($conn , "set names utf8");
?>