#!/bin/bash

#WEB PART
WEB_DIR=/var/www
WEB_SVN=https://subversion.assembla.com/svn/the-lords/trunk/web/
#save_errors
mkdir mode1
mkdir mode8
cp $WEB_DIR/game/mode1/error*.* mode1/
cp $WEB_DIR/game/mode8/error*.* mode8/
#save avatars
mkdir profiles
cp $WEB_DIR/design/images/profile/*.* profiles
#svn
rm -r $WEB_DIR
mkdir $WEB_DIR
#checkout web part from svn
svn co $WEB_SVN $WEB_DIR --username lords_checkouter --password c2h5oh
#get svn revision
REVISION=$(svnversion $WEB_DIR)
#set svn revision as config value for not caching
CONFIG_CMD="sed -i '' -e 's/revision_[^\"]*/revision_$REVISION/' $WEB_DIR/general_config/config.php"
eval $CONFIG_CMD
#copy errors back
cp mode1/error*.* $WEB_DIR/game/mode1/
cp mode8/error*.* $WEB_DIR/game/mode8/
rm -r mode1
rm -r mode8
#restore avatars
chmod 777 $WEB_DIR/design/images/profile/
cp profiles/*.* $WEB_DIR/design/images/profile/
#minimize size of js files
yui-compressor -o '.js$:.js' $WEB_DIR/arena/api/*.js
yui-compressor -o '.js$:.js' $WEB_DIR/arena/js_libs/*.js
yui-compressor -o '.js$:.js' $WEB_DIR/site/js_libs/*.js
yui-compressor -o '.js$:.js' $WEB_DIR/game/mode1/js_libs/*.js
yui-compressor -o '.js$:.js' $WEB_DIR/game/mode8/js_libs/*.js
#minimize size of css files
yui-compressor -o '.css$:.css' $WEB_DIR/design/css/*.css
yui-compressor -o '.css$:.css' $WEB_DIR/design/css/pregame/*.css
#chmod for static libs and errors
chmod 777 $WEB_DIR/game/mode1/js_libs/static_libs.js
chmod 777 $WEB_DIR/game/mode8/js_libs/static_libs.js
chmod 777 $WEB_DIR/site/js_libs/static_libs.js
chmod 777 $WEB_DIR/game/mode1/
chmod 777 $WEB_DIR/game/mode8/
cd $WEB_DIR/cron/
php generate_static_js_libs.php
php generate_static_js_libs_site.php

echo "DONE WEB PART"

#APE PART
APE_SVN=https://subversion.assembla.com/svn/the-lords/trunk/ape_scripts/scripts/lords/
killall aped
cd /home/skoba/web/
rm -r ape/scripts/lords
mkdir ape/scripts/lords
svn co $APE_SVN ape/scripts/lords --username lords_checkouter --password c2h5oh
#chmod +x /usr/local/www/apache22/ape/bin/aped
cd ape/bin/
#clear log
echo -n > ape.log
./aped
echo "APE PART DONE"