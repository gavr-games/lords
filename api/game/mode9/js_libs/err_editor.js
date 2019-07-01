var errListSlider;
var toolboxSlider;
var debugSlider;
var evalSlider;
var current_err_id = 0;
function initialization() {
	errListSlider = new Fx.Reveal($('error_files_list'),{});
	toolboxSlider = new Fx.Reveal($('toolbox'),{});
	debugSlider = new Fx.Reveal($('debug'),{});
        evalSlider = new Fx.Reveal($('eval_li'),{});
        evalSlider.toggle();
}
function setActiveErr(id){
	if (current_err_id!=0)
	$('err_'+current_err_id).removeClass('act');
	$('err_'+id).addClass('act');
	current_err_id = id;
}
function killErrWinds(){
	if ($('i_frame').contentWindow)	{
		$('i_frame').contentWindow.$$('.error_window').destroy();
	}
}
function hideAll()	{
	errListSlider.dissolve();
	toolboxSlider.dissolve();
	debugSlider.dissolve();
}
function loadDebug()	{
	$('debug_cont').set('html','');
        var debugArr = new Array('board_units','board_buildings','vwGrave','player_deck','chat_users','players_by_num');
        var newH;
        var newC;
        var newE;
        var tempArr;
        var first = true;
        var arr_keys;
        var arr_values;
        var temp_str = '';
        var i = 0;
        var k = 0;
        debugArr.each(function(item,index){
            //create headers and content
            newH = new Element('h2',{'html':item});
            eval("tempArr = $('i_frame').contentWindow."+item);
            newC = new Element('div',{'class':'content'});
            first = true;
            temp_str = '';
            //parse array
            k = 0;
            tempArr.each(function(item,index)	{
                if (item){
                    arr_keys = Object.keys(item);
                    arr_values = Object.values(item);
                    //show table header
                    /*if (first){
                        temp_str += '<tr>';
                        arr_keys.each(function(kitem)	{
                            temp_str += '<th>'+kitem+'</th>';
                        });
                        first = false;
                        temp_str += '</tr>';
                    }*/
                    //populate table with data
                    temp_str += '<div class="debug_item">';
                    i = 0;
                    arr_values.each(function(vitem)	{
                       temp_str += ' <p><b>'+arr_keys[i]+'</b>:'+arr_values[i]+'</p>';
                       i++;
                    });
                    temp_str += '</div>';
                    k++;
                    if (k%6==0) temp_str += '<br clear="all" />';
                }
            });
            temp_str += '';
            newC.set('html',temp_str);
            $('debug_cont').grab(newH);
            $('debug_cont').grab(newC);
        });
        //board
        newH = new Element('h2',{'html':'board'});
        newC = new Element('div',{'class':'content','id':'board_cont'});
        temp_str = '';
        var t_class;
        var t_text;
        var x; var y;
        for(y=0;y<20;y++){
            for(x=0;x<20;x++){
                t_class = '';
                t_text  = '';
                if ($chk($('i_frame').contentWindow.board[x]) && $chk($('i_frame').contentWindow.board[x][y])){
                    t_class = $('i_frame').contentWindow.board[x][y]['type'];
                    t_text  = $('i_frame').contentWindow.board[x][y]['ref'];
                }
                temp_str+= '<div class="board_cell '+t_class+'" title="'+x+'/'+y+'">'+t_text+'</div>';
            }
            temp_str+='<br />';
        }
        newC.set('html',temp_str);
        $('debug_cont').grab(newH);
        $('debug_cont').grab(newC);
        new Fx.Accordion($('debug_cont'), '#debug_cont h2', '#debug_cont .content');
}
function reloadIframe() {
    $('i_frame').contentWindow.location.reload();
}
function turnOffSound() {
    $('i_frame').contentWindow.noSound = 1;
}
function evalInWindow() {
    $('i_frame').contentWindow.eval($('eval_area').get('value'));
}
function enableBacklight(){
    $('i_frame').contentWindow.no_backlight = false;
}