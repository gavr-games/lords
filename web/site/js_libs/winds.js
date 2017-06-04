var screen_size;
var current_window;
var old_window;
var panorFx;
var window_loading = false;

window.addEvent('resize', function() {
    screen_size = window.getSize();
    $('wind').setStyle('min-height',screen_size.y);
    $('wind').setStyle('width',screen_size.x);
    $('panor').setStyle('height',screen_size.y);
    $('rel').setStyle('min-height',screen_size.y);
    if (current_window){
        current_window.setStyle('width',screen_size.x);
        current_window.setStyle('height',screen_size.y);
    }
});
window.addEvent('domready', function() {
  var dt = new Date();
  var seasons = new Array('winter','spring','summer','autumn');
  var season = seasons[Math.floor((dt.getMonth()+1) / 3) % 4];
  var hr = dt.getHours();
  var daytime = '';
  if ((hr>=22 && hr<=23) || (hr>=0 && hr<=5)) daytime = 'Night';
  else if (hr>=6 && hr<=9) daytime = 'Sunrise';
  else if (hr>=10 && hr<=17) daytime = 'Day';
  else if (hr>=18 && hr<=21) daytime = 'Sunset';
  var scr_size = 1200;
  screen_size = window.getSize();
  if (screen_size.y>0 && screen_size.y<=768) scr_size = 768;
  else if (screen_size.y>768 && screen_size.y<=1024) scr_size = 1024;
		//console.log(season,daytime,scr_size,screen_size.y);
	$('wind').setStyle('min-height',screen_size.y);
	$('wind').setStyle('width',screen_size.x);
	$('panor').setStyle('height',screen_size.y);
	$('panor').setStyle('background-image','url("'+site_domen+'design/images/pregame/panorama/'+season+'/'+daytime+'_'+scr_size+'_Q8.jpg")');
        $('panor').setStyle('background-position',Number.random(0, 10000)+"px 0px");
	$('rel').setStyle('min-height',screen_size.y);
	current_window = new Element('iframe', {
			'src':load_frame,
			'class':'window',
			'styles':{
				'width':screen_size.x,
				'height':screen_size.y,
				'left':15000,
                                'z-index':1000,
				'opacity':0
			},
                        'allowtransparency':'true'
	});
	$('rel').grab(current_window);
});
function load_window(src,dir)	{
    window_loading = true;
    var x_offset = 0;
	if (dir=='right')
		x_offset = current_window.getStyle('left').toInt()+screen_size.x;
	else
		x_offset = current_window.getStyle('left').toInt()-screen_size.x;
	var right_window = new Element('iframe', {
			'src':src,
			'class':'window',
			'onload':'//current_window.contentWindow.document.body.style.overflow = "hidden";',
			'styles':{
				'width':screen_size.x,
				'height':screen_size.y,
				'left':x_offset
			},
                        'allowtransparency':'true'
	});
	old_window = current_window;
	current_window = right_window;
        //current_window.fade(0.3);
	$('rel').grab(current_window);
	setTimeout("move_window('"+dir+"');",1000);
}
function move_window(dir) {
  var pan_x = Math.ceil(screen_size.x/5);

  jQuery(current_window).animate({left: ((dir=='right')?("-=" + screen_size.x + 'px'):("+=" + screen_size.x + "px"))}, 0, "linear");
  jQuery(old_window).animate({left: ((dir=='right')?("-=" + screen_size.x + 'px'):("+=" + screen_size.x + "px"))}, 0, "linear");

  setTimeout(function() {
    old_window.destroy();
    window_loading = false;
  }, 3000);

  jQuery("#panor").animate({
    "background-position-x": ((dir=='right')?("-=" + pan_x + 'px'):("+=" + pan_x + "px")),
    'background-position-y': '0px'
  }, 0, "linear");
}

function finishedMovement(){
  old_window.destroy();
  window_loading = false;
}
