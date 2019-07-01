var EventBus = {
  subscribe: function(event, fn) {
    jQuery(this).bind(event, fn);
  },
  publish: function(event, extraParams) {
    extraParams = extraParams || [];
    jQuery(this).trigger(event, extraParams);
  }
};
