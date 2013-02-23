function makeScrollbar(content,horizontal,ignoreMouse){
        content.getParent().setStyle('position','relative');
        content.setStyle('overflow-'+(horizontal?'x':'y'),'hidden');
        var id = content.get('id');
        var scroll_cont = Element('div',{
            'id':'scroll_'+id,
            'class':'scroll_'+(horizontal?'hor':'vert'),
            'styles':{
                'height':content.getSize().y
            }
        });
        var scroll_arr1 = Element('div',{
            'class':'scroll_arr1'
        });
        var scroll_arr2 = Element('div',{
            'class':'scroll_arr2'
        });
        var scroll_bar = Element('div',{
            'class':'scroll_bar',
            'styles':{
                'height':content.getSize().y-26
            }
        });
        var scroll_handle = Element('div',{
            'class':'scroll_handle'
        });
        scroll_cont.grab(scroll_arr1);
        scroll_cont.grab(scroll_bar);
        scroll_bar.grab(scroll_handle);
        scroll_cont.grab(scroll_arr2);
        content.getParent().grab(scroll_cont,'top');
        if (horizontal){}else{
            scroll_cont.position({
                relativeTo: content,
                position: 'upperRight',
                edge: 'upperRight'
            });
        }
        var scrollbar = scroll_bar;
        var handle    = scroll_handle;
	var steps = (horizontal?(content.getScrollSize().x - content.getSize().x):(content.getScrollSize().y - content.getSize().y));
        if (Browser.ie && steps==0) steps=-2;
        scrolls[id] = new Slider(scrollbar, handle, {	
					'steps': steps,
					mode: (horizontal?'horizontal':'vertical'),
					onChange: function(step){
						// Scrolls the content element in x or y direction.
						var x = (horizontal?step:0);
						var y = (horizontal?0:step);
						content.scrollTo(x,y);
					}
	}).set(0);
	if( !(ignoreMouse) ){
					// Scroll the content element when the mousewheel is used within the 
					// content or the scrollbar element.
					$$(content, scrollbar).addEvent('mousewheel', function(e){	
						e = new Event(e).stop();
						var step = scrolls[id].step - e.wheel * 30;	
						scrolls[id].set(step);					
					});
	}
        scroll_arr1.addEvent('click', function(e){	
		e = new Event(e).stop();
		var step = scrolls[id].step - 10;	
		scrolls[id].set(step);					
	});
        scroll_arr2.addEvent('click', function(e){	
						e = new Event(e).stop();
						var step = scrolls[id].step + 10;	
						scrolls[id].set(step);					
	});
	// Stops the handle dragging process when the mouse leaves the document body.
	$(document.body).addEvent('mouseleave',function(){if (scrolls[id]) scrolls[id].drag.stop()});
}
function modifyScrollBar(content,horizontal){
    content = $(content);
    var steps = (horizontal?(content.getScrollSize().x - content.getSize().x):(content.getScrollSize().y - content.getSize().y));
    if (Browser.ie && steps==0) steps=-2;
    var id = content.get('id');
    delete scrolls[id];
    var scrollbar = $('scroll_'+id).getChildren()[1];
    var handle = scrollbar.getChildren()[0];
    scrolls[id] = new Slider(scrollbar, handle, {	
					steps: steps,
					mode: (horizontal?'horizontal':'vertical'),
					onChange: function(step){
						// Scrolls the content element in x or y direction.
						var x = (horizontal?step:0);
						var y = (horizontal?0:step);
						content.scrollTo(x,y);
					}
    }).set((steps>0?steps:0));
}
function movedownScrollBar(content){
    content = $(content);
    var id = content.get('id');
    scrolls[id].set(scrolls[id].steps);
    //console.log(scrolls[id].steps);
}
function setposScrollBar(content,horizontal){
    content = $(content);
    var id = content.get('id');
    if (horizontal){}else{
            $('scroll_'+id).position({
                relativeTo: content,
                position: 'upperRight',
                edge: 'upperRight'
            });
    }
}