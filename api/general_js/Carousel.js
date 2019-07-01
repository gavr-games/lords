var Carousel = this.Carousel = new Class({

		Implements: [Options, Events],
		options: {
			container:'',
			nextb:'',
			prevb:'',
			quantity:0,
			current:0
		},
		initialize: function (options) {
		 	this.container = options.container;
		 	this.quantity  = options.quantity;
		 	this.current   = options.current;
		 	$(options.nextb).addEvent('click', function(){this.move(1)}.bind(this));
		 	$(options.prevb).addEvent('click', function(){this.move(-1)}.bind(this));
		 	this.move(-1);
		},
		toLast: function () {
			elements = $(this.container).getChildren();
			elements_count = elements.length;
			
			this.current = Math.floor(elements_count/this.quantity)*this.quantity - this.quantity;
			this.moveAnyCase(1);
		},
		toFirst: function () {
			this.current = -this.quantity
			this.move(1);
		},
		move: function (direction) {
			elements = $(this.container).getChildren();
			elements_count = elements.length;
			if (elements_count>0)	{
				var container = $(this.container);
				step = elements[0].getSize();
				current = this.current;
				
				//set current
				this.current = this.current +direction*this.quantity;
				if (this.current<0) this.current = 0;
				else
				if (this.current>(elements_count-1)) this.current = this.current - this.quantity;
				if (current!=this.current)	{
					current = this.current;
					
					i = 0;
					var fx = new Fx.Elements(elements, {
						onStart: function(){
					        //container.set('opacity',0.6);
					    },
						onComplete: function(){
					        //container.set('opacity',1);
					    },
						wait: false,
						duration: 600,
						transition: Fx.Transitions.Quint.easeInOut
					});
					var o = {};
					elements.each(function(item)	{
						if (i<current)
							item_offset_x = -step.x*(current-i);
						else
							item_offset_x = step.x*(i-current);
								o[i] = {
									left:item_offset_x
								}
								i++;
					});
					fx.start(o);
				}
			}
		},
		moveAnyCase: function (direction) {
			elements = $(this.container).getChildren();
			elements_count = elements.length;
			if (elements_count>0)	{
				var container = $(this.container);
				step = elements[0].getSize();
				current = this.current;
				
				//set current
				this.current = this.current +direction*this.quantity;
				if (this.current<0) this.current = 0;
				else
				if (this.current>(elements_count-1)) this.current = this.current - this.quantity;
				
					current = this.current;
					
					i = 0;
					var fx = new Fx.Elements(elements, {
						onStart: function(){
					        //container.set('opacity',0.6);
					    },
						onComplete: function(){
					        //container.set('opacity',1);
					    },
						wait: false,
						duration: 600,
						transition: Fx.Transitions.Quint.easeInOut
					});
					var o = {};
					elements.each(function(item)	{
						if (i<current)
							item_offset_x = -step.x*(current-i);
						else
							item_offset_x = step.x*(i-current);
								o[i] = {
									left:item_offset_x
								}
								i++;
					});
					fx.start(o);
				
			}
		}
	});