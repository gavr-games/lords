<?php

if ($_GET['phpsessid'] != "") session_id($_GET['phpsessid']); //this is passed from real-time server
session_start();

echo json_encode($_SESSION);
?>