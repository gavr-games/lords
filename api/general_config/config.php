<?php

include_once(dirname(__FILE__) . '/../vendor/autoload.php');
include_once(dirname(__FILE__) . '/../general_classes/logger.class.php');
include_once(dirname(__FILE__) . '/../general_classes/lang_utils.class.php');
error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
// DB
$DB_conf['user']   = 'lords_client';
$DB_conf['pass']   = $_ENV['MYSQL_CLIENT_PASSWORD'];
$DB_conf['name']   = 'lords';
$DB_conf['site']   = 'lords_site';
$DB_conf['server'] = 'db';

// Site
$SITE_conf['domen'] = $_ENV['LORDS_DOMAIN'].'/';
$SITE_conf['mantis'] = 'http://mantis.kissdesign.com.ua';
$SITE_conf['ai_service'] = 'http://ai:5600/ai?wsdl';
$SITE_conf['revision'] = $_ENV['REVISION'];
$SITE_conf['feedback_url'] = 'https://docs.google.com/forms/d/e/1FAIpQLSfC2DZGpMZLakg2M4ykfZvLBt6rsXdSp2nZRigoxXKUXb-Vwg/viewform';

// Lang
$i18n = new i18n();
$i18n->setFallbackLang('en');
$i18n->setFilePath(dirname(__FILE__) . '/../lang/lang_{LANGUAGE}.ini');
$i18n->setCachePath(dirname(__FILE__) . '/../lang/cache');
$i18n->init();

