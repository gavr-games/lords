//ЕСЛИ ТЫ ЗЛОСТНЫЙ ХАКЕР И ЗАЛЕЗ СЮДА, ЧТОБЫ ПРОЧЕСТЬ ВСЕ ФРАЗЫ, ТО ВОТ ОНИ - ОБЛОМАЙСЯ И ПОТЕРЯЙ ВЕСЬ ФАН ОТ ЗАГРУЗКИ ИГРЫ =)
var phrases = new Array(
	new Array('Не забудь воскресить конного!','Первая заповедь Лорда'),
	new Array('Хорошо везет тому, кому везет последнему (:','Лорд Morchug'),
	new Array('Главное манёвры!','Лорд And'),
	new Array('Чит? Чииииииит!','Лорд Morchug'),
	new Array('May the force be with you','Лорд Han Solo'),
	new Array('Не знаешь, что делать? Пой патриотические песни!','Отважный копейщик'),
	new Array('Три магии, три веселых спелла, Экипаж спеллбука моего','Лорд Helmut'),
	new Array('Принимаются жертвоприношения...','Богиня Рендома'),
	new Array('Всегда держи в казне 40 монет!','Вторая заповедь Лорда'),
	new Array('Нет денег? Ограбь тролля!','Народная мудрость')
);

var checkLoadInterval;
var changePhraseInterval;

function showRandomPhrase()	{
	var phrase = phrases.getRandom();
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
			setLoadingText('Загрузка скриптов и стилей');
			addLoadingItem('Подключение к серверу','ape_script');
			myApeInit();
			addLoadingItem('Скрипт инициализации','init_script');
			Asset.javascript('js_libs/initialization.js?'+revision, {onLoad: function(){removeLoadingItem('init_script');}});
			addLoadingItem('Скрипт ElementSwap','swap_script');
			Asset.javascript('../../general_js/ElementSwap.js?'+revision, {onLoad: function(){removeLoadingItem('swap_script');}});
			addLoadingItem('Скрипт закладок','tabs_script');
			Asset.javascript('../../general_js/Tabs.js?'+revision, {onLoad: function(){removeLoadingItem('tabs_script');}});
			addLoadingItem('Скрипт карусели','car_script');
			Asset.javascript('../../general_js/Carousel.js?'+revision, {onLoad: function(){removeLoadingItem('car_script');}});
			addLoadingItem('Статические библиотеки','slibs_script');
			Asset.javascript('js_libs/static_libs.js?'+revision, {onLoad: function(){removeLoadingItem('slibs_script');}});
			addLoadingItem('Поддержка интернационализации','i18n_text_getters');
			Asset.javascript('js_libs/i18n_text_getters.js?'+revision, {onLoad: function(){removeLoadingItem('i18n_text_getters');}});
			addLoadingItem('Скрипт Execute','exec_script');
			Asset.javascript('js_libs/execute.js?'+revision, {onLoad: function(){removeLoadingItem('exec_script');}});
			addLoadingItem('API функции клиента','api_script');
			Asset.javascript('js_libs/api.js?'+revision, {onLoad: function(){removeLoadingItem('api_script');}});
			
			addLoadingItem('Основные стили игры','game_styles');
			Asset.css('../../design/css/stylesgame.css?'+revision).addEvent('onload',removeLoadingItem('game_styles'));
			addLoadingItem('Стили доски','board_styles');
			Asset.css('../../design/css/stylesboard.css?'+revision).addEvent('onload',removeLoadingItem('board_styles'));
			addLoadingItem('Индексы','zi_styles');
			Asset.css('../../design/css/styleszi.css?'+revision).addEvent('onload',removeLoadingItem('zi_styles'));
			addLoadingItem('Стили хинта','tip_styles');
			Asset.css('../../design/css/stylestip.css?'+revision).addEvent('onload',removeLoadingItem('tip_styles'));
			addLoadingItem('Стили карт','cards_styles');
			Asset.css('../../design/css/stylescards.css?'+revision).addEvent('onload',removeLoadingItem('cards_styles'));
			addLoadingItem('Стили видео','video_styles');
			Asset.css('../../design/css/stylesvideo.css?'+revision).addEvent('onload',removeLoadingItem('video_styles'));
			addLoadingItem('Стили статистики','stats_styles');
			Asset.css('../../design/css/stylesstats.css?'+revision).addEvent('onload',removeLoadingItem('stats_styles'));
			addLoadingItem('Стили окон','window_styles');
			Asset.css('../../design/css/styleswindow.css?'+revision).addEvent('onload',removeLoadingItem('window_styles'));
			addLoadingItem('Стили сообщений','mes_styles');
			Asset.css('../../design/css/stylesunitmes.css?'+revision).addEvent('onload',removeLoadingItem('mes_styles'));
			
			addLoadingItem('Графическое содержимое','field_img');
			Asset.image('../../design/images/gamefield.jpg', {onLoad: function(){removeLoadingItem('field_img');}});
			checkLoadInterval = setInterval("checkLoadList();",500);
			changePhraseInterval = setInterval("showRandomPhrase();",20000);
		}
		function checkLoadList()	{
			if($('load_list').getChildren().length==0) {
				clearInterval(checkLoadInterval);
				apeGetGameInfo();
			}
		}
