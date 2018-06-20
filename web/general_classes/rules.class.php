<?php
class Rules {
    const RULES_DOCS = [
        "en" => "https://docs.google.com/document/d/e/2PACX-1vQmjG15nRuqi7G6bYktDioWmMiZ83RhrUUTsQQNtOlM_--Z1yGfTJWiyccqAbi1jY00ojdU7yKhDcML/pub?embedded=true",
        "ru" => "https://docs.google.com/document/d/e/2PACX-1vRDj3PmzPog5luXJ0YT1QQsFLdalN1oPLtSMaOJXimwN4FNLaiu-6elYdkoxozsrLk__XsMBq1k-b4F/pub?embedded=true"
    ];

    public static function getHtml($lang) {
        return '<iframe width="1020" height="544" scrolling="yes" style="overflow-y:scroll;" src="' . self::RULES_DOCS[$lang] . '"></iframe>';
    }

    public static function getEmbedUrl($lang) {
        return self::RULES_DOCS[$lang];
    }
}