<?php

class GoogleAnalytics {
    public static function globalSiteTag() {
        if (isset($_ENV['WEB_ENV']) && $_ENV['WEB_ENV'] == 'prod') {
            return <<<EOD
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-120597438-1"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-120597438-1');
</script>
EOD;
        } else {
            return '';
        }
    }
}