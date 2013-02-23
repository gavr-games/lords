/*
---
name: ElementSwap.js
description: Slide show interface to swap between any group of elements.
authors: Shaun Freeman
requires:
    core/1.2.4:
    - Class
    - Class.Extras
    - Element
    - Element.Event
    - Selectors
provides: [ElementSwap]
license: MIT-style license
version: 1.0.1
...
*/

var ElementSwap = new Class({
	
	Implements: [Options, Events, Chain],
	
	slides: [],
	
	isLooping: false,
	
 	options: {
		selectedClass: 'active',
		elementSwapDelay: 3,
		panelWrap: 'elementSwapWrap',
		panelWrapClass: 'elementSwap',
		events: true,
		activateOnLoad: 0,
		autoPlay: false,
		onActive: $empty,
		onClickView: $empty,
		onNext: $empty,
		onPrevious: $empty
	},
 
 	initialize: function(elements, options) {
		this.setOptions(options);
		
		this.slides = $$(elements);
		
		this.wrap = new Element('div', {
			'id': this.options.panelWrap,
			'class': this.options.panelWrapClass
		}).inject(this.slides[0], 'before').adopt(this.slides);
		
		this.activate(this.options.activateOnLoad);
		
		if (this.options.autoPlay) this.start();
	},
	
	attach: function(elements) {
		$$(elements).each(function(el) {
			var enter = el.retrieve('elementSwap:enter', this.elementEnter.bindWithEvent(this, el));
			var leave = el.retrieve('elementSwap:leave', this.elementLeave.bindWithEvent(this, el));
			var mouseclick = el.retrieve('elementSwap:click', this.elementClick.bindWithEvent(this, el));
			el.addEvents({
				mouseenter: enter,
				mouseleave: leave,
				click: mouseclick
			});
		}, this);
		return this;
	},
	
	detach: function(elements) {
		$$(elements).each(function(el) {
			el.removeEvent('mouseenter', el.retrieve('elementSwap:enter') || $empty);
			el.removeEvent('mouseleave', el.retrieve('elementSwap:leave') || $empty);
		});
	},
	
	activate: function(index) {
		if ($type(index) == 'string') index = this.slides.indexOf(this.slides.filter('[id='+index+']')[0]);
		if ($type(index) != 'number') return;
		this.show(index);
	},
	
 	show: function(index) {
		if ($type(index) != 'number') return;
		this.now = index;
		this.slides.removeClass(this.options.selectedClass);
		this.slides[this.now].addClass(this.options.selectedClass);
		this.fireEvent('onActive', [this.now, this.slides[this.now]]);
		//return this.now;
	},
	
	start: function() {
		if (this.options.events) this.attach(this.slides);
		this.isLooping = true;
		this.slideShow = this.next.periodical(this.options.elementSwapDelay * 1000, this);
	},
	
	stop: function(notPause) {
		this.clearChain();
		$clear(this.slideShow);
		this.isLooping = false;
		if (notPause) this.detach(this.slides);
	},
	
	next: function() {
		var el = this.slides[this.now].getNext();
		if (!el) el = this.slides[0];
		this.activate(this.slides.indexOf(el));
		this.fireEvent('onNext');
		return this;
	},
	
	previous: function() {
		var el = this.slides[this.now].getPrevious();
		if (!el) el = this.slides[this.slides.length - 1];
		this.activate(this.slides.indexOf(el));
		this.fireEvent('onPrevious');
		return this;
	},

	elementClick: function(e, el) {
		this.fireEvent('onClickView', [this.now, el]);
	},
	
	elementEnter: function(e, el) {
		this.stop();
	},
 
	elementLeave: function(e, el) {
		this.start();
	}
});
