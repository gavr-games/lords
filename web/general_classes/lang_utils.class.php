<?php
class LangUtils {
    public static function replaceTemplateMarkers($template) {
        $lang_consts = (new ReflectionClass(L))->getConstants();
		$search = [];
		$replace = [];
		foreach($lang_consts as $key => $value) {
			$search[] = "###l_$key###";
			$replace[] = $value;
        }
        return str_replace($search, $replace, $template);
    }

    public static function getCurrentLangNumber($langCode) {
        if (isset($langCode) && is_string($langCode)) {
            return $langCode == 'en' ? 1 : 2; //1 - english, 2 - russian
        } else {
            return 1; //default english
        }
    }

    public static function getAllLangs() {
        return ['en' => 1, 'ru' => 2];
    }
}