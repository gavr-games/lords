<?php
include_once('init.php');
session_start();

$_SESSION['lang'] = $_GET['lang'];
header('location:' . $_SERVER['HTTP_REFERER']);