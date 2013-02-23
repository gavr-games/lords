/*
---
name: Tabs.js
description: Handles the scripting for a common UI layout; the tabbed box. 
authors: Shaun Freeman
requires:
    elementswap/1.0.1:
    - ElementSwap
provides: [Tabs]
license: MIT-style license
version: 1.0
...
*/

var Tabs = new Class({
	Implements: [Options, Events],
 
	options: {
		tabs: '.tabs_title li',
		panels: '.tabs_panel',
		selectedClass: 'active',
		elementSwapOptions: {
			selectedClass: 'active',
			panelWrap: 'tabsPanelWrap',
			panelWrapClass: 'tabs_panelwrap',
			activateOnLoad: 0,
			events: true,
			autoPlay: false
		},
		mouseOverClass: 'over',
		onActive: $empty,
		onBackground: $empty
	},
		
	initialize: function(options) {
		this.setOptions(options);
		
		this.tabs = $$(this.options.tabs);
		
		this.getSwap();
		
		this.attach(this.tabs);
		
		if($type(this.options.elementSwapOptions.activateOnLoad) == 'number') {
			this.activateTab(this.options.elementSwapOptions.activateOnLoad);
		}
	},
	
	getSwap: function(){
		this.elSwap = new ElementSwap(this.options.panels, this.options.elementSwapOptions).addEvent('onActive', this.showTab.bindWithEvent(this));
	},
	
	attach: function(elements) {
		$$(elements).each(function(element) {
			var enter = element.retrieve('tab:enter', this.elementEnter.bindWithEvent(this, element));
			var leave = element.retrieve('tab:leave', this.elementLeave.bindWithEvent(this, element));
			var mouseclick = element.retrieve('tab:click', this.elementClick.bindWithEvent(this, element));
			element.addEvents({
				mouseenter: enter,
				mouseleave: leave,
				click: mouseclick
			});
		}, this);
		return this;
	},
	
	activateTab: function(index) {
		this.showTab(index);
		this.elSwap.activate(index);
	},
	
	showTab: function(index) {
		this.now = index;
		this.tabs.removeClass(this.options.selectedClass);
		this.tabs[this.elSwap.now].addClass(this.options.selectedClass);
		this.fireEvent('onActive', [index, this.tabs[this.now]]);
		return this;
	},
	
	elementEnter: function(event, element) {
		if(element != this.tabs[this.now]) {
			element.addClass(this.options.mouseOverClass);
		}
	},
 
	elementLeave: function(event, element) {
		if(element != this.tabs[this.now]) {
			element.removeClass(this.options.mouseOverClass);
		}
	},
	
	elementClick: function(event, element) {
		event.stop();
		if(element != this.tabs[this.now]) {
			if (this.elSwap.isLooping) this.elSwap.stop(true);
			this.fireEvent('onBackground', [this.tabs[this.now]]);
			this.activateTab(this.tabs.indexOf(element));
		}
	}
});
