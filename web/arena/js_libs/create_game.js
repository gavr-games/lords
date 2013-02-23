function validateForm(button) {
	var noError = true;
	$('game_error').hide();
	
	if ($('game_title').get('value')=='')	{
		noError = false;
		$('game_error').set('text','Не все поля заполнены.');
	    $('game_error').show();
	    if ($('game_title').get('value')=='') $('game_title').highlight('#A11D15');
	}else 
	if ($('pass_i').get('value')!=$('pass2_i').get('value') && $('pass_i').get('value')!='')	{
		noError = false;
		$('game_error').set('text','Пароли не совпадают');
	    $('game_error').show();
	    $('pass_i').highlight('#A11D15');
	    $('pass2_i').highlight('#A11D15');
	}
	if (noError) {
	  button.addClass('loading');
	  var passwd = '"'+$('pass_i').get('value').replace(new RegExp('"','g'),'\\"')+'"';
	  if (passwd=='""') passwd = 'null';
	  parent.parent.sendLoggedProtocolCmd({action:'arena_game_create',params:{
		title: '"'+parent.convertChars($('game_title').get('value'))+'"',
                pass:  passwd,
		time_restriction: $('time_restriction').get('value'),
		mode: $('mode').get('value')
	    }});
	}
}