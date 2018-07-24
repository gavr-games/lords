var Tutorial = {
  // All events to subscribe to
  tutorialEvents: function() {
    return [
      'game_loading_finished',
      'execute_building_card',
      'add_to_grave',
      'put_building',
      'execute_unit_with_many_actions',
      'show_levelup_star'
    ];
  },

  // Returns basic introJs object
  baseIntro: function() {
    var intro = introJs();
    intro.setOptions({
      showProgress: true,
      tooltipPosition: 'auto',
      exitOnOverlayClick: false,
      nextLabel: i18n[USER_LANGUAGE]["tutorial"]["next"],
      prevLabel: i18n[USER_LANGUAGE]["tutorial"]["prev"],
      skipLabel: i18n[USER_LANGUAGE]["tutorial"]["skip"],
      doneLabel: i18n[USER_LANGUAGE]["tutorial"]["done"]
    });
    return intro;
  },

  // Sets local storage key for tutorial with introKey
  markAsDone: function(introKey) {
    localStorage.setItem('tutorial_' + introKey, '1');
  },

  // Checks tutorial with introKey is completed
  isDone: function(introKey) {
    return localStorage.getItem('tutorial_' + introKey) == '1';
  },

  // Checks tutorial is disabled in settings
  isDisabled: function() {
    return localStorage.getItem('tutorial_dissabled') == '1';
  },

  // Subscribe to global game events
  subscribe: function() {
    var tutorial = this;
    jQuery.each(this.tutorialEvents(), function( index, eventName ) {
      EventBus.subscribe(eventName, eval('tutorial.on_' + eventName));
    });
  },

  // Resets all completed tutorials
  reset: function() {
    jQuery.each(this.tutorialEvents(), function( index, eventName ) {
      localStorage.removeItem('tutorial_' + eventName);
    });
  },

  setDisabled: function(val) {
    localStorage.setItem('tutorial_disabled', val);
  },

  // Returns event name for on_ methods
  callerName: function() {
    return Tutorial.callerName.caller.name.replace('on_', '');
  },

  // Create and show intro
  startIntro: function(eventName, options, delay) {
    delay = delay || 0;
    if (Tutorial.isDisabled() || Tutorial.isDone(eventName)) {
      return;
    }
    var intro = Tutorial.baseIntro();
    intro.setOptions(options);
    intro.onexit(function() {
      Tutorial.markAsDone(eventName);
    });
    setTimeout(function() { intro.start() }, delay);
  },

  on_game_loading_finished: function() {
    Tutorial.startIntro(Tutorial.callerName(), {
      steps: [
        {
          element: document.querySelector('.pl' + (my_player_num.toInt() + 1) + ' .building_castle'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["your_castle"]
        },
        {
          element: document.querySelector('.btn_buycard'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["buy_card"]
        },
        {
          element: document.querySelector('#cardsLink'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["cards_tab"]
        },
        {
          element: document.querySelector('.my-brd-unit'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["my_units"]
        }
      ]
    }, 1000);
  },

  on_add_to_grave: function() {
    Tutorial.startIntro(Tutorial.callerName(), {
      steps: [
        {
          element: document.querySelector('#graveLink'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["grave"]
        }
      ]
    }, 1000);
  },

  on_execute_building_card: function() {
    Tutorial.startIntro(Tutorial.callerName(), {
      steps: [
        {
          element: document.querySelector('#actions'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["building_actions"]
        },
        {
          element: document.querySelector('.hint'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["building_hint"]
        }
      ]
    });
  },

  on_put_building: function(e, id, p_num, x, y, nrotation, nflip, card_id, income) {
    if (income.toInt() > 0) {
      Tutorial.startIntro(Tutorial.callerName(), {
        steps: [
          {
            element: document.querySelector('#board_' + x + '_' + y),
            intro: i18n[USER_LANGUAGE]["tutorial"]["building_income"] + income
          }
        ]
      }, 1000);
    }
  },

  on_execute_unit_with_many_actions: function() {
    Tutorial.startIntro(Tutorial.callerName(), {
      steps: [
        {
          element: document.querySelector('#actions'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["unit_with_many_actions"]
        }
      ]
    });
  },

  on_show_levelup_star: function(e, x, y, exps) {
    Tutorial.startIntro(Tutorial.callerName(), {
      steps: [
        {
          element: document.querySelector('#board_' + x + '_' + y),
          intro: i18n[USER_LANGUAGE]["tutorial"]["unit_levelup"]
        }
      ]
    }, 1000);
  }
}

setTimeout(function(){ Tutorial.subscribe() }, 500);