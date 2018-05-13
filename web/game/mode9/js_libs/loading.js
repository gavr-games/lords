//ЕСЛИ ТЫ ЗЛОСТНЫЙ ХАКЕР И ЗАЛЕЗ СЮДА, ЧТОБЫ ПРОЧЕСТЬ ВСЕ ФРАЗЫ, ТО ВОТ ОНИ - ОБЛОМАЙСЯ И ПОТЕРЯЙ ВЕСЬ ФАН ОТ ЗАГРУЗКИ ИГРЫ =)
var phrases = new Array();
phrases[1] = new Array(
	new Array('May the force be with you','Lord Han Solo'),
	new Array('Cheat? Cheaaaaaaaat!','Lord Morchug'),
	new Array('Sacrifices accepted...',' Goddess of Random'),
	new Array('Do not know what to do? Sing the patriotic songs!','The brave spearman'),
	new Array('No money? Rob the troll!','Proverb')
);
phrases[2] = new Array(
	new Array('Не забудь воскресить конного!','Первая заповедь Лорда'),
	new Array('Хорошо везет тому, кому везет последнему (:','Лорд Morchug'),
	new Array('Главное манёвры!','Лорд And'),
	new Array('Чит? Чииииииит!','Лорд Morchug'),
	new Array('Не знаешь, что делать? Пой патриотические песни!','Отважный копейщик'),
	new Array('Три магии, три веселых спелла, Экипаж спеллбука моего','Лорд Helmut'),
	new Array('Принимаются жертвоприношения...','Богиня Рендома'),
	new Array('Всегда держи в казне 40 монет!','Вторая заповедь Лорда'),
	new Array('Нет денег? Ограбь тролля!','Народная мудрость')
);

var checkLoadInterval;
var changePhraseInterval;

function showRandomPhrase()	{
	var phrase = phrases[USER_LANGUAGE].getRandom();
	$('phrase').set('text',phrase[0]);
	$('phrase_a').set('text',phrase[1]);
	$('phrase_a').position({
	    relativeTo: $('phrase'),
	    position: 'bottomRight',
	    edge: 'centerTop'
	});
}
		function setLoadingText(ntext)	{
			$('load_text').set('text',ntext);
		}
		function addLoadingItem(ntext,id)	{
			var loadingP = new Element('p', {
				'html': ntext,
				'id': id,
				styles: {
					'visibility': 'hidden',
					'opacity': 0
				}
			});
			$('load_list').grab(loadingP);
			loadingP.fade('in');
		}
		function removeLoadingItem(id)	{
			$(id).set('tween', {
			    onComplete: function () {$(id).destroy();}
			});
			$(id).fade('out');
		}
		function onPageLoad(revision) {
			showRandomPhrase();
			setLoadingText(i18n[USER_LANGUAGE]["loading"]["scripts_and_styles"]);
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["init_script"],'init_script');
			Asset.javascript('js_libs/initialization.js?'+revision, {onLoad: function(){removeLoadingItem('init_script');}});
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["script"] + ' ElementSwap','swap_script');
			Asset.javascript('../../general_js/ElementSwap.js?'+revision, {onLoad: function(){removeLoadingItem('swap_script');}});
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["tabs_script"],'tabs_script');
			Asset.javascript('../../general_js/Tabs.js?'+revision, {onLoad: function(){removeLoadingItem('tabs_script');}});
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["car_script"],'car_script');
			Asset.javascript('../../general_js/Carousel.js?'+revision, {onLoad: function(){removeLoadingItem('car_script');}});
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["i18n_text_getters"],'i18n_text_getters');
			Asset.javascript('js_libs/i18n_text_getters.js?'+revision, {onLoad: function(){removeLoadingItem('i18n_text_getters');}});
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["script"] + ' Execute','exec_script');
			Asset.javascript('js_libs/execute.js?'+revision, {onLoad: function(){removeLoadingItem('exec_script');}});
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["api_script"],'api_script');
			Asset.javascript('js_libs/api.js?'+revision, {onLoad: function(){removeLoadingItem('api_script');}});
			
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["game_styles"],'game_styles');
			Asset.css('../../design/css/stylesgame.css?'+revision).addEvent('onload',removeLoadingItem('game_styles'));
			Asset.css('../../design/css/mobile.css?'+revision);
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["board_styles"],'board_styles');
			Asset.css('../../design/css/stylesboard.css?'+revision).addEvent('onload',removeLoadingItem('board_styles'));
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["zi_styles"],'zi_styles');
			Asset.css('../../design/css/styleszi.css?'+revision).addEvent('onload',removeLoadingItem('zi_styles'));
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["tip_styles"],'tip_styles');
			Asset.css('../../design/css/stylestip.css?'+revision).addEvent('onload',removeLoadingItem('tip_styles'));
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["cards_styles"],'cards_styles');
			Asset.css('../../design/css/stylescards.css?'+revision).addEvent('onload',removeLoadingItem('cards_styles'));
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["video_styles"],'video_styles');
			Asset.css('../../design/css/stylesvideo.css?'+revision).addEvent('onload',removeLoadingItem('video_styles'));
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["stats_styles"],'stats_styles');
			Asset.css('../../design/css/stylesstats.css?'+revision).addEvent('onload',removeLoadingItem('stats_styles'));
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["window_styles"],'window_styles');
			Asset.css('../../design/css/styleswindow.css?'+revision).addEvent('onload',removeLoadingItem('window_styles'));
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["mes_styles"],'mes_styles');
			Asset.css('../../design/css/stylesunitmes.css?'+revision).addEvent('onload',removeLoadingItem('mes_styles'));
			
			addLoadingItem(i18n[USER_LANGUAGE]["loading"]["field_img"],'field_img');
			Asset.image('../../design/images/gamefield.jpg', {onLoad: function(){removeLoadingItem('field_img');}});
			checkLoadInterval = setInterval("checkLoadList();",500);
			changePhraseInterval = setInterval("showRandomPhrase();",20000);
		}
		function checkLoadList()	{
			if($('load_list').getChildren().length==0) {
				clearInterval(checkLoadInterval);
				parent.WSClient.getGameInfo();
			}
		}
