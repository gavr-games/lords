<?php
include_once('init.php');
include_once('../general_classes/base_protocol.class.php');
session_start();

$_SESSION['lang'] = $_GET['lang'];

if ($_SESSION['user_id'] != '') {
    BaseProtocol::execCmd("user_language_change", [$_SESSION['user_id'], '"'.$_SESSION['lang'].'"']); // not checking for errors
}

header('location:' . $_SERVER['HTTP_REFERER']);