var tutorialQueue = []
var wrapFunction = function(fn, context, params) {
  return function() {
      fn.apply(context, params);
  };
}
var playingTutorial = false;

var Tutorial = {
  // All events to subscribe to
  tutorialEvents: function() {
    return [
      'game_loading_finished',
      'execute_building_card',
      'execute_magic_card',
      'add_to_grave',
      'put_building',
      'execute_unit_with_many_actions',
      'show_levelup_star',
      'player_set_gold',
      'add_unit',
      'add_unit_by_id'
    ];
  },

  // EventNames for reset
  customResetEventNames: function() {
    return [
      'building_with_income',
      'building_destroy_reward',
      'building_teleport',
      'building_lake',
      'building_mountain',
      'building_barracks',
      'building_hint',
      'building_actions',
      'subsidy',
      'send_money',
      'magic_hint',
      'magic_actions',
      'unit_vampire',
      'unit_archer',
      'unit_arbalester',
      'unit_catapult',
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
    jQuery.each(this.customResetEventNames(), function( index, eventName ) {
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

  // Create and put intro into the queue
  startIntro: function(events, options, delay) {
    delay = delay || 0;
    var isDone = true;
    jQuery.each(events, function( index, eventName ) {
      if (!Tutorial.isDone(eventName)) {
        isDone = false;
      }
    });
    if (Tutorial.isDisabled() || isDone) {
      return;
    }
    var playFunc = wrapFunction(Tutorial.playInto, this, [events, options, delay]);
    tutorialQueue.push(playFunc);
    Tutorial.playNext();
  },

  // Plays intro
  playInto: function(events, options, delay) {
    var intro = Tutorial.baseIntro();
    intro.setOptions(options);
    intro.onexit(function() {
      jQuery.each(events, function( index, eventName ) {
        Tutorial.markAsDone(eventName);
      });
      playingTutorial = false;
      setTimeout(function() {
        Tutorial.playNext();
      }, 100);
    });
    setTimeout(function() { intro.start() }, delay);
  },

  // Play next intro
  playNext: function() {
    if (tutorialQueue.length > 0 && !playingTutorial) {
      playingTutorial = true;
      (tutorialQueue.shift())();   
    }
  },

  on_game_loading_finished: function() {
    Tutorial.startIntro([Tutorial.callerName()], {
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
        },
        {
          element: document.querySelector('.my-brd-unit'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["kill_units_reward"]
        }
      ]
    }, 1000);
  },

  on_add_to_grave: function() {
    Tutorial.startIntro([Tutorial.callerName()], {
      steps: [
        {
          element: document.querySelector('#graveLink'),
          intro: i18n[USER_LANGUAGE]["tutorial"]["grave"]
        }
      ]
    }, 1000);
  },

  on_execute_building_card: function(e, card_id) {
    var eventNames = [];
    var steps = [];

    // General hint
    if (!Tutorial.isDone('building_hint')) {
      eventNames.push('building_hint');
      steps.push({
        element: document.querySelector('.hint'),
        intro: i18n[USER_LANGUAGE]["tutorial"]["building_hint"]
      });
    }

    // Rotate reflect actions
    if (buildings[cards[card_id]['ref']]['x_len'].toInt() > 1 || buildings[cards[card_id]['ref']]['y_len'].toInt() > 1) {
      eventNames.push('building_actions');
      steps.push({
        element: document.querySelector('#actions'),
        intro: i18n[USER_LANGUAGE]["tutorial"]["building_actions"]
      });
    }

    if (eventNames.length > 0) {
      Tutorial.startIntro(eventNames, { steps: steps });
    }
  },

  on_execute_magic_card: function(e, card_id, procedures) {
    var eventNames = [];
    var steps = [];

    // Card has many actions
    if (procedures.length > 1) {
      eventNames.push('magic_actions');
      steps.push({
        element: document.querySelector('#actions'),
        intro: i18n[USER_LANGUAGE]["tutorial"]["magic_actions"]
      });
    } else
    // General hint
    if (!Tutorial.isDone('magic_hint')) {
      eventNames.push('magic_hint');
      steps.push({
        element: document.querySelector('.hint'),
        intro: i18n[USER_LANGUAGE]["tutorial"]["magic_hint"]
      });
    }

    if (eventNames.length > 0) {
      Tutorial.startIntro(eventNames, { steps: steps });
    }
  },

  on_put_building: function(e, id, p_num, x, y, nrotation, nflip, card_id, income) {
    setTimeout(function(){
      var eventNames = [];
      var steps = [];

      // income
      if (income.toInt() > 0) {
        eventNames.push('building_with_income');
        steps.push({
          element: document.querySelector('#board_' + x + '_' + y),
          intro: i18n[USER_LANGUAGE]["tutorial"]["building_income"] + income
        });
      }

      // destroy reward
      if (card_id != "" && buildings[cards[card_id]["ref"]]['type'] == 'building') {
        eventNames.push('building_destroy_reward');
        steps.push({
          element: document.querySelector('#board_' + x + '_' + y),
          intro: i18n[USER_LANGUAGE]["tutorial"]["building_destroy_reward"]
        });
      }

      // buildings
      var buildingsHints = ['teleport', 'lake', 'mountain', 'barracks'];
      jQuery.each(buildingsHints, function( index, buildingUiCode ) {
        if (card_id != "" && buildings[cards[card_id]["ref"]]['ui_code'] == buildingUiCode) {
          eventNames.push('building_' + buildingUiCode);
          var classSelector;
          jQuery.each(jQuery('.building_' + buildingUiCode), function(index, item) {
            if(jQuery(item).css('background').includes('url')) {
              classSelector = jQuery(item).attr('class');
            }
          });
          steps.push({
            element: document.querySelector('.' + classSelector.replace(/  /g,' ').split(' ').join('.')),
            intro: i18n[USER_LANGUAGE]["tutorial"]['building_' + buildingUiCode]
          });
        }
      });

      if (eventNames.length > 0) {
        Tutorial.startIntro(eventNames, { steps: steps }, 1000);
      }
    }, 500);
  },

  on_execute_unit_with_many_actions: function(e, x, y, board_unit_id) {
    var notDefaultActions = false;
    jQuery.each(units_procedures_1, function( index, item ) {
      if (item) if (item['unit_id'] == board_units[board_unit_id]['unit_id']) {
        var procName = procedures_mode_1[item['procedure_id']]['name'];
        if (procName != 'player_move_unit' && procName != 'attack') {
          notDefaultActions = true;
        }
      }
    });

    if (notDefaultActions) {
      Tutorial.startIntro([Tutorial.callerName()], {
        steps: [
          {
            element: document.querySelector('#actions'),
            intro: i18n[USER_LANGUAGE]["tutorial"]["unit_with_many_actions"]
          }
        ]
      });
    }
  },

  on_show_levelup_star: function(e, x, y, exps) {
    Tutorial.startIntro([Tutorial.callerName()], {
      steps: [
        {
          element: document.querySelector('#board_' + x + '_' + y),
          intro: i18n[USER_LANGUAGE]["tutorial"]["unit_levelup"]
        }
      ]
    }, 1000);
  },

  on_player_set_gold: function(e, p_num, amount) {
    var eventNames = [];
    var steps = [];

    // subsidy
    if (amount.toInt() < 20 && p_num.toInt() == my_player_num.toInt() && !Tutorial.isDone('subsidy')) {
      eventNames.push('subsidy');
      steps.push({
        element: document.querySelector('.btn_subs'),
        intro: i18n[USER_LANGUAGE]["tutorial"]["subsidy"]
      });
    }

    // send money
    if (amount.toInt() < 20 && p_num.toInt() != my_player_num.toInt() && players_by_num[p_num]['team'] == players_by_num[my_player_num]['team'] && p_num.toInt() < 10 && !Tutorial.isDone('send_money')) {
      eventNames.push('send_money');
      steps.push({
        element: document.querySelector('.btn_sendm'),
        intro: i18n[USER_LANGUAGE]["tutorial"]["send_money"]
      });
    }

    if (eventNames.length > 0) {
      Tutorial.startIntro(eventNames, { steps: steps }, 1000);
    }
  },

  on_add_unit: function(e, id, p_num, x, y, card_id) {
    var eventNames = [];
    var steps = [];

    // units
    var unitsHints = ['vampire', 'archer', 'arbalester', 'catapult'];
    jQuery.each(unitsHints, function( index, unitUiCode ) {
        if (card_id != "" && units[cards[card_id]["ref"]]['ui_code'] == unitUiCode) {
          eventNames.push('unit_' + unitUiCode);
          steps.push({
            element: document.querySelector('#board_' + x + '_' + y),
            intro: i18n[USER_LANGUAGE]["tutorial"]['unit_' + unitUiCode]
          });
        }
    });

    if (eventNames.length > 0) {
      Tutorial.startIntro(eventNames, { steps: steps }, 1000);
    }
  },

  on_add_unit_by_id: function(e, id, p_num, x, y, unit_id) {
    var eventNames = [];
    var steps = [];

    // units
    var unitsHints = ['vampire', 'archer', 'arbalester', 'catapult'];
    jQuery.each(unitsHints, function( index, unitUiCode ) {
        if (unit_id != "" && units[unit_id]['ui_code'] == unitUiCode) {
          eventNames.push('unit_' + unitUiCode);
          steps.push({
            element: document.querySelector('#board_' + x + '_' + y),
            intro: i18n[USER_LANGUAGE]["tutorial"]['unit_' + unitUiCode]
          });
        }
    });

    if (eventNames.length > 0) {
      Tutorial.startIntro(eventNames, { steps: steps }, 1000);
    }
  }
}

setTimeout(function(){ Tutorial.subscribe() }, 500);
