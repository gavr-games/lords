<?php
class Logger {
    const PATH_TO_LOGFILE = '/var/log/apache2';

    public static function info($msg) {
        $log = '['.date('j-m-y h:i:s').'] INFO: '.$msg.PHP_EOL;
        file_put_contents(self::PATH_TO_LOGFILE.'/web.log', $log, FILE_APPEND);
    }
}