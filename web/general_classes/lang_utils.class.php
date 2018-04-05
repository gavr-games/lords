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
}