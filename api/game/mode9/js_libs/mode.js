/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	
	var _game = __webpack_require__(1);
	
	var _player = __webpack_require__(2);
	
	var _players_controller = __webpack_require__(3);
	
	var _cards_controller = __webpack_require__(4);
	
	var _turn_controller = __webpack_require__(5);
	
	var _unit = __webpack_require__(6);
	
	var _building = __webpack_require__(7);
	
	var _board_object = __webpack_require__(8);
	
	var _cell = __webpack_require__(9);
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var GameMode = function GameMode() {
	  _classCallCheck(this, GameMode);
	
	  this.Unit = _unit.Unit;
	  this.Building = _building.Building;
	  this.BoardObject = _board_object.BoardObject;
	  this.Cell = _cell.Cell;
	  this.Game = _game.Game;
	  this.Player = _player.Player;
	  this.PlayersController = _players_controller.PlayersController;
	  this.CardsController = _cards_controller.CardsController;
	  this.TurnController = _turn_controller.TurnController;
	};
	
	window.GameMode = new GameMode();

/***/ }),
/* 1 */
/***/ (function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var Game = exports.Game = function Game(gameData, myPlayerNum) {
	  _classCallCheck(this, Game);
	
	  this.creation_date = gameData['creation_date'];
	  this.game_id = gameData['game_id'];
	  this.mode_id = gameData['mode_id'];
	  this.owner_id = gameData['owner_id'];
	  this.status_id = gameData['status_id'];
	  this.time_restriction = gameData['time_restriction'];
	  this.title = gameData['title'];
	  this.type_id = gameData['type_id'];
	
	  this.PlayersController = new window.GameMode.PlayersController(myPlayerNum);
	  this.CardsController = new window.GameMode.CardsController();
	  this.TurnController = new window.GameMode.TurnController();
	};

/***/ }),
/* 2 */
/***/ (function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var Player = exports.Player = function () {
	  function Player(data) {
	    _classCallCheck(this, Player);
	
	    this.player_num = data['player_num'].toInt();
	    this.name = data['name'];
	    this.gold = data['gold'].toInt();
	    this.owner = data['owner'].toInt();
	    this.team = data['team'].toInt();
	  }
	
	  _createClass(Player, [{
	    key: 'setGold',
	    value: function setGold(gold) {
	      this.gold = gold.toInt();
	    }
	  }]);

	  return Player;
	}();

/***/ }),
/* 3 */
/***/ (function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var PlayersController = exports.PlayersController = function () {
	  function PlayersController(myPlayerNum) {
	    _classCallCheck(this, PlayersController);
	
	    this.players = [];
	    this.myPlayerNum = myPlayerNum.toInt();
	  }
	
	  _createClass(PlayersController, [{
	    key: "addPlayer",
	    value: function addPlayer(playerData) {
	      player = new window.GameMode.Player(playerData);
	      this.players.push(player);
	    }
	  }, {
	    key: "removePlayer",
	    value: function removePlayer(playerNum) {
	      this.players = this.players.filter(function (player, _index, _arr) {
	        return player.num != playerNum;
	      });
	    }
	  }, {
	    key: "getMyPlayer",
	    value: function getMyPlayer() {
	      return this.getPlayerByNum(this.myPlayerNum);
	    }
	  }, {
	    key: "isMyPlayer",
	    value: function isMyPlayer(playerNum) {
	      return playerNum.toInt() == this.myPlayerNum;
	    }
	  }, {
	    key: "getPlayerByNum",
	    value: function getPlayerByNum(playerNum) {
	      return this.players.find(function (player) {
	        return player.player_num == playerNum;
	      });
	    }
	  }]);

	  return PlayersController;
	}();

/***/ }),
/* 4 */
/***/ (function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var CardsController = exports.CardsController = function () {
	  function CardsController() {
	    _classCallCheck(this, CardsController);
	
	    this.cards = [];
	    this.cardActionDoneInThisTurn = false;
	  }
	
	  _createClass(CardsController, [{
	    key: "setCardActionDoneInThisTurn",
	    value: function setCardActionDoneInThisTurn(cardActionDoneInThisTurn) {
	      this.cardActionDoneInThisTurn = cardActionDoneInThisTurn;
	    }
	  }, {
	    key: "canMakeAction",
	    value: function canMakeAction() {
	      var game = window.Game;
	      return game.TurnController.myTurn && !game.CardsController.cardActionDoneInThisTurn;
	    }
	  }, {
	    key: "canBuy",
	    value: function canBuy() {
	      return window.Game.PlayersController.getMyPlayer()['gold'].toInt() >= mode_config["card cost"] && (realtime_cards || this.canMakeAction());
	    }
	  }]);

	  return CardsController;
	}();

/***/ }),
/* 5 */
/***/ (function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var TurnController = exports.TurnController = function () {
	  function TurnController() {
	    _classCallCheck(this, TurnController);
	
	    this.myTurn = false;
	  }
	
	  _createClass(TurnController, [{
	    key: "setMyTurn",
	    value: function setMyTurn(myTurn) {
	      this.myTurn = myTurn;
	    }
	  }]);

	  return TurnController;
	}();

/***/ }),
/* 6 */
/***/ (function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var Unit = exports.Unit = function () {
	  function Unit(id) {
	    _classCallCheck(this, Unit);
	
	    this.boardUnitId = id;
	  }
	
	  _createClass(Unit, [{
	    key: "getSize",
	    value: function getSize() {
	      return units[board_units[this.boardUnitId]["unit_id"]]['size'].toInt();
	    }
	  }, {
	    key: "getMovesLeft",
	    value: function getMovesLeft() {
	      return board_units[this.boardUnitId]["moves_left"].toInt();
	    }
	  }, {
	    key: "getPlayerNum",
	    value: function getPlayerNum() {
	      return board_units[this.boardUnitId]['player_num'];
	    }
	  }, {
	    key: "getTeam",
	    value: function getTeam() {
	      return players_by_num[this.getPlayerNum()]['team'];
	    }
	  }, {
	    key: "getKnight",
	    value: function getKnight() {
	      var id = this.boardUnitId;
	      return board_units[id]["knight"] == 1;
	    }
	  }, {
	    key: "getLeftUpCoord",
	    value: function getLeftUpCoord() {
	      var id = this.boardUnitId;
	      var ux = 9999999;
	      var uy = 9999999;
	      board.each(function (items, index) {
	        if (items) items.each(function (item, index) {
	          if (item) if (item["ref"] == id && item["type"] == "unit") {
	            if (item["x"].toInt() < ux) ux = item["x"].toInt();
	            if (item["y"].toInt() < uy) uy = item["y"].toInt();
	          }
	        });
	      });
	      return { x: ux, y: uy };
	    }
	  }, {
	    key: "canMove",
	    value: function canMove() {
	      var id = this.boardUnitId;
	      return board_units[id]["moves_left"].toInt() > 0 && !$chk(board_units[id]['paralich']);
	    }
	  }, {
	    key: "isNear",
	    value: function isNear(x, y) {
	      var id = this.boardUnitId;
	      var nearSelectedUnit = false;
	      var cx;
	      var cy;
	      for (cx = x - 1; cx < x + 2; cx++) {
	        for (cy = y - 1; cy < y + 2; cy++) {
	          if (board[cx]) if (board[cx][cy]) if (board[cx][cy]["ref"] == id && board[cx][cy]["type"] == 'unit') {
	            nearSelectedUnit = true;
	          }
	        }
	      }return nearSelectedUnit;
	    }
	  }, {
	    key: "canTeleport",
	    value: function canTeleport(x, y) {
	      var id = this.boardUnitId;
	      var size = this.getSize();
	      var distance = 999999;
	      var teleport = 0;
	      var tx = 0;
	      var ty = 0;
	      var tid;
	      board_buildings.each(function (item, index) {
	        if (item) if ($chk(players_by_num[item['player_num']])) //player num 9 for trees,moat ... doesnt exists
	          if (board_units[id]['magic_immunity'] != 1 && buildings[item["building_id"]]['ui_code'] == 'teleport' && (item['player_num'] == my_player_num || players_by_num[item['player_num']]['team'] == players_by_num[my_player_num]['team'])) {
	            //this is my Teleport or my ally and unit is not golem(magic_immunity==1)
	            tid = item["id"];
	            teleport = 1;
	            //get coords
	            board.each(function (items, index) {
	              if (items) items.each(function (item, index) {
	                if (item) if (item["ref"] == tid && item["type"] == "building") {
	                  var a = x - item["x"].toInt();
	                  var b = y - item["y"].toInt();
	                  var dist = Math.sqrt(a * a + b * b);
	                  if (dist < distance) {
	                    // in case of 2 teleports
	                    distance = dist;
	                    tx = item["x"].toInt();
	                    ty = item["y"].toInt();
	                  }
	                }
	              });
	            });
	          }
	      });
	      return x >= tx - size && x <= tx + 1 && y >= ty - size && y <= ty + 1 && teleport == 1;
	    }
	  }, {
	    key: "fitsCoord",
	    value: function fitsCoord(x, y) {
	      var mx = void 0,
	          my = void 0;
	      var id = this.boardUnitId;
	      var size = this.getSize();
	      for (mx = x; mx < x + size; mx++) {
	        for (my = y; my < y + size; my++) {
	          if (board[mx]) if (board[mx][my]) if (board[mx][my]["ref"]) if (board[mx][my]['type'] != 'unit' || board[mx][my]['ref'] != id) return false;
	          if (mx < 0 || mx > 19 || my < 0 || my > 19) return false;
	        }
	      }return true;
	    }
	  }, {
	    key: "distToCoord",
	    value: function distToCoord(x, y) {
	      var unitCoord = this.getLeftUpCoord();
	      var movesLeft = this.getMovesLeft();
	      return Math.max(Math.abs(unitCoord.x - x), Math.abs(unitCoord.y - y));
	    }
	  }, {
	    key: "canFlyToCoord",
	    value: function canFlyToCoord(x, y) {
	      if (!this.fitsCoord(x, y)) {
	        return false;
	      }
	      if (this.getKnight()) {
	        return false;
	      }
	      if (board_units[this.boardUnitId].flying != 1) {
	        return false;
	      }
	
	      // Check flight distance
	      var movesLeft = this.getMovesLeft();
	      if (this.distToCoord(x, y) > movesLeft) {
	        return false;
	      }
	
	      return true;
	    }
	  }, {
	    key: "directStepsToCoord",
	    value: function directStepsToCoord(x, y) {
	      var distToCoord = this.distToCoord(x, y);
	      if (this.getKnight()) {
	        return distToCoord / 2;
	      }
	      return distToCoord;
	    }
	  }, {
	    key: "getMoveCmds",
	    value: function getMoveCmds(x, y) {
	      // Check Unit can move
	      if (!this.canMove()) {
	        return [];
	      }
	
	      // Teleport Unit
	      if (this.canTeleport(x, y) && this.fitsCoord(x, y)) {
	        return [{
	          'x': x,
	          'y': y,
	          'action': 'm'
	        }];
	      }
	
	      var targetX = x;
	      var targetY = y;
	      //Adjust move coords for big units
	      var ux = this.getLeftUpCoord().x;
	      var uy = this.getLeftUpCoord().y;
	      if (this.isNear(x, y) && this.getSize() > 1 && !this.getKnight()) {
	        if (x < ux) {
	          targetX = x;
	        } else if (x > ux + this.getSize() - 1) {
	          targetX = x - this.getSize() + 1;
	        } else {
	          targetX = ux;
	        }
	        if (y < uy) {
	          targetY = y;
	        } else if (y > uy + this.getSize() - 1) {
	          targetY = y - this.getSize() + 1;
	        } else {
	          targetY = uy;
	        }
	      }
	
	      //Move unit according to path
	      var path = this.getPath(targetX, targetY).slice(0, this.getMovesLeft());
	
	      //Fly if cannot move to coords or it takes less moves to fly
	      if ((path.length == 0 || path.length >= this.directStepsToCoord(targetX, targetY)) && this.canFlyToCoord(targetX, targetY)) {
	        return [{
	          'x': targetX,
	          'y': targetY,
	          'action': 'm'
	        }];
	      }
	
	      //If out of range
	      var movesLeft = this.getMovesLeft();
	      if (this.directStepsToCoord(targetX, targetY) > movesLeft) {
	        return [];
	      }
	
	      //Check "knight moves" unit can go to targetX and targetY
	      var found = path.find(function (p) {
	        return p['x'] == targetX && p['y'] == targetY;
	      });
	      if (!found) {
	        return [];
	      }
	
	      return path;
	    }
	  }, {
	    key: "getPath",
	    value: function getPath(x, y) {
	      var renderObjects = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : true;
	
	      var path = [];
	      var not_reached = true;
	      var path_board = new Array();
	      var i = 0;
	      var k = 0;
	      var l = 0;
	      var m = 0;
	      var symbols = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'c', 'd', 'e', 'f', 'g', 'h', 'k', 'l', 'm');
	      var id = this.boardUnitId;
	      var size = units[board_units[id]["unit_id"]]['size'].toInt();
	      var knight = board_units[id]["knight"];
	      //init path board
	      for (i = 0; i < 20; i++) {
	        path_board[i] = new Array();
	        for (k = 0; k < 20; k++) {
	          path_board[i][k] = '-';
	        }
	      }
	      //fill path board
	      if (renderObjects) {
	        board.each(function (items, index) {
	          if (items) items.each(function (item, index) {
	            if (item) {
	              if (item['type'] == 'unit' && item['ref'].toInt() == id) ; //this unit 
	              else if (item['type'] == 'obstacle') //cant attack obstacle
	                  path_board[item['x'].toInt()][item['y'].toInt()] = 'x';else if (item['type'] == 'unit') {
	                  //attack unit
	                  //fixing bug if we suddenly get not killed unit with not existing player (which already delted)
	                  if (!$chk(players_by_num[board_units[item['ref']]['player_num']])) {
	                    delete board[item['x'].toInt()][item['y'].toInt()];
	                    if ($chk(board_units[item['ref']])) delete board_units[item['ref']];
	                  } else if (board_units[id]['player_num'] == board_units[item['ref']]['player_num'] || players_by_num[board_units[id]['player_num']]['team'] == players_by_num[board_units[item['ref']]['player_num']]['team']) path_board[item['x'].toInt()][item['y'].toInt()] = 'x';else path_board[item['x'].toInt()][item['y'].toInt()] = 'u';
	                } else {
	                  //buildings, castle
	                  if ($chk(players_by_num[board_buildings[item['ref']]['player_num']])) {
	                    //player num 9 for trees,moat ... doesnt exists
	                    if (board_units[id]['player_num'] == board_buildings[item['ref']]['player_num'] || players_by_num[board_units[id]['player_num']]['team'] == players_by_num[board_buildings[item['ref']]['player_num']]['team']) path_board[item['x'].toInt()][item['y'].toInt()] = 'x';else path_board[item['x'].toInt()][item['y'].toInt()] = 'b';
	                  } else if (board_buildings[item['ref']]['health'] > 0) //can kill bridge
	                    path_board[item['x'].toInt()][item['y'].toInt()] = 'b';else path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
	                }
	            }
	          });
	        });
	      }
	
	      var target_coord = path_board[x][y];
	      if (path_board[x][y] != 't') path_board[x][y] = 't';
	      var leftUpCoord = this.getLeftUpCoord();
	      var ux = leftUpCoord.x;
	      var uy = leftUpCoord.y;
	      path_board[ux][uy] = 'z';
	
	      var cnear = false;
	      var tnear = true;
	      var step = 0;
	      var cango = true;
	      var t_in = false;
	      var x_in = false;
	      //start generating all avaible paths
	      while (not_reached && tnear) {
	        tnear = false;
	        for (i = 0; i < 20; i++) {
	          for (k = 0; k < 20; k++) {
	            cnear = false;
	            if (path_board[i][k] == '-' || path_board[i][k] == 't') {
	              if (knight) {
	                for (l = i - 2; l < i + 3; l++) {
	                  for (m = k - 2; m < k + 3; m++) {
	                    if (l >= 0 && l <= 19 && m >= 0 && m <= 19) if (Math.abs(i - l) == 1 && Math.abs(k - m) == 2 || Math.abs(i - l) == 2 && Math.abs(k - m) == 1) if (step == 0 && path_board[l][m] == 'z' || step != 0 && path_board[l][m] == symbols[step - 1]) if (size > 1) {
	                      //large unlts
	                      if (step == 0 && path_board[l][m] == 'z') {
	                        if (l == ux && m == uy) cnear = 1;
	                      } else cnear = 1;
	                    } else cnear = 1;
	                  }
	                }
	              } else {
	                //usual moves
	                for (l = i - 1; l < i + 2; l++) {
	                  for (m = k - 1; m < k + 2; m++) {
	                    if (l >= 0 && l <= 19 && m >= 0 && m <= 19) if (step == 0 && path_board[l][m] == 'z' || step != 0 && path_board[l][m] == symbols[step - 1]) cnear = 1;
	                  }
	                }
	              }
	              if (cnear) {
	                if (path_board[i][k] == 't') {
	                  //found target unit(s)
	                  not_reached = false;
	                } else {
	                  cango = true;
	                  if (size > 1) {
	                    //large units
	                    t_in = false;
	                    x_in = false;
	                    for (l = i; l < i + size; l++) {
	                      for (m = k; m < k + size; m++) {
	                        if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
	                          if (path_board[l][m] == 'x') x_in = true;
	                          if (path_board[l][m] == 't') t_in = true;
	                          if (path_board[l][m] == 'x' || path_board[l][m] == 'u' || path_board[l][m] == 'b') cango = false;
	                        } else cango = false;
	                      }
	                    } //if can hit target unit by hitting also another b or u - and target not free cell
	                    if (cango == false) {
	                      if ($chk(board[x]) && $chk(board[x][y]) && $chk(board[x][y]['ref'])) if (t_in && !x_in) {
	                        cango = true;
	                      }
	                    }
	                  }
	                  if (cango) {
	                    path_board[i][k] = symbols[step];
	                    tnear = true;
	                  }
	                }
	              }
	            } // =='-'
	          }
	        }step++;
	      }
	      //show board
	      //if (x==15 && y==1) for (i=0;i<20;i++)	{
	      //  console.log(path_board[0][i],path_board[1][i],path_board[2][i],path_board[3][i],path_board[4][i],path_board[5][i],path_board[6][i],path_board[7][i],path_board[8][i],path_board[9][i],path_board[10][i],path_board[11][i],path_board[12][i],path_board[13][i],path_board[14][i],path_board[15][i],path_board[16][i],path_board[17][i],path_board[18][i],path_board[19][i]);
	      //}
	      //generate 1 path
	      step--;
	      path_moves = step + 1;
	      var x_path = [];
	      var y_path = [];
	      var path_actions = [];
	      var u_x = [];
	      var u_y = [];
	      for (i = 0; i < 40; i++) {
	        x_path[i] = -1;
	      }for (i = 0; i < 40; i++) {
	        y_path[i] = -1;
	      }if (target_coord == 'x') return []; //no allias hit
	      for (i = 0; i < 40; i++) {
	        path_actions[i] = 'm';
	      }var cur_x = x;
	      var cur_y = y;
	      x_path[step] = cur_x;
	      y_path[step] = cur_y;
	      cango = true;
	      var doattack = false;
	      if (size > 1 && target_coord == '-') {
	        //large units
	        for (l = x_path[step]; l < x_path[step] + size; l++) {
	          for (m = y_path[step]; m < y_path[step] + size; m++) {
	            if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
	              if (path_board[l][m] == 'u' || path_board[l][m] == 'b') doattack = true;
	              if (path_board[l][m] == 'x') cango = false;
	            } else cango = false;
	          }
	        }
	      } else if (target_coord == 'b' || target_coord == 'u') {
	        doattack = true;
	      }
	      if (!cango && !doattack) {
	        x_path[0] = -1;
	        y_path[0] = -1;
	        return [];
	      }
	      if (doattack) path_actions[step] = 'a';
	      cnear = 0;
	      var ufound = 0;
	      var stop = 0;
	      //generate random path to unit
	      do {
	        u_x = new Array();
	        u_y = new Array();
	        ufound = 0;
	        var delta = 100;
	        if (knight == 1) {
	          //knight moves
	          for (i = cur_x - 2; i < cur_x + 3; i++) {
	            for (j = cur_y - 2; j < cur_y + 3; j++) {
	              if (i >= 0 && i <= 19 && j >= 0 && j <= 19) if (Math.abs(cur_x - i) == 1 && Math.abs(cur_y - j) == 2 || Math.abs(cur_x - i) == 2 && Math.abs(cur_y - j) == 1) if (step == 0 && path_board[i][j] == 'z' || step != 0 && path_board[i][j] == symbols[step - 1]) {
	                u_x[ufound] = i;
	                u_y[ufound] = j;
	                ufound++;
	              }
	            }
	          }
	        } else //usual moves
	          for (i = cur_x - 1; i < cur_x + 2; i++) {
	            for (j = cur_y - 1; j < cur_y + 2; j++) {
	              if (i >= 0 && i <= 19 && j >= 0 && j <= 19) if (step == 0 && path_board[i][j] == 'z' || step != 0 && path_board[i][j] == symbols[step - 1]) {
	                u_x[ufound] = i;
	                u_y[ufound] = j;
	                ufound++;
	              }
	            }
	          } //pick random way
	        /*if (ufound!=1)	{
	        ufound = Math.floor(Math.random() * ufound);
	        } else ufound--;*/
	
	        //angle path choice
	        l = Math.sqrt(Math.pow(cur_x - ux, 2) + Math.pow(cur_y - uy, 2));
	        var sina = Math.abs(cur_x - ux) / l;
	
	        var angl = 0; // general direction
	        if (ux > cur_x && uy > cur_y) angl = Math.PI / 2 - Math.asin(sina);else if (cur_x == ux && uy > cur_y) angl = Math.PI / 2;else if (ux < cur_x && uy > cur_y) angl = Math.PI / 2 + Math.asin(sina);else if (cur_y == uy && ux < cur_x) angl = Math.PI;else if (ux < cur_x && uy < cur_y) angl = Math.PI + Math.PI / 2 - Math.asin(sina);else if (cur_x == ux && uy < cur_y) angl = Math.PI + Math.PI / 2;else if (ux > cur_x && uy < cur_y) angl = Math.PI * 1.5 + Math.asin(sina);
	        u_x.each(function (item, index) {
	          if ($chk(item)) {
	            l = Math.sqrt(Math.pow(u_x[index] - cur_x, 2) + Math.pow(u_y[index] - cur_y, 2));
	            sina = Math.abs(u_x[index] - cur_x) / l;
	
	            var angl2 = 0; //possible direction
	            if (u_x[index] > cur_x && u_y[index] > cur_y) angl2 = Math.PI / 2 - Math.asin(sina);else if (cur_x == u_x[index] && u_y[index] > cur_y) angl2 = Math.PI / 2;else if (u_x[index] < cur_x && u_y[index] > cur_y) angl2 = Math.PI / 2 + Math.asin(sina);else if (cur_y == u_y[index] && u_x[index] < cur_x) angl2 = Math.PI;else if (u_x[index] < cur_x && u_y[index] < cur_y) angl2 = Math.PI + Math.PI / 2 - Math.asin(sina);else if (cur_x == u_x[index] && u_y[index] < cur_y) angl2 = Math.PI + Math.PI / 2;else if (u_x[index] > cur_x && u_y[index] < cur_y) angl2 = Math.PI * 1.5 + Math.asin(sina);
	            if (Math.abs(angl - angl2) < delta) {
	              delta = Math.abs(angl - angl2);
	              ufound = index;
	            }
	            if (angl2 == 0) {
	              angl2 = Math.PI * 2;
	              if (Math.abs(angl - angl2) < delta) {
	                delta = Math.abs(angl - angl2);
	                ufound = index;
	              }
	            }
	          }
	        });
	
	        x_path[step - 1] = u_x[ufound];
	        y_path[step - 1] = u_y[ufound];
	        cur_x = u_x[ufound];
	        cur_y = u_y[ufound];
	        step--;
	        if (step < 0) stop = 1;
	      } while (stop == 0);
	      if (size > 1 && (target_coord == 'b' || target_coord == 'u') && x_path[0] != -1 && y_path[0] != -1) {
	        i = 0;
	        var can_hit_earlier = false;
	        while (x_path[i] != -1 && y_path[i] != -1 && !can_hit_earlier) {
	          for (l = x_path[i]; l < x_path[i] + size; l++) {
	            for (m = y_path[i]; m < y_path[i] + size; m++) {
	              if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
	                if (path_board[l][m] == 't') can_hit_earlier = true;
	              }
	            }
	          }i++;
	        }
	        if (can_hit_earlier) {
	          path_actions[i - 1] = 'a';
	          x_path[i] = -1;
	          y_path[i] = -1;
	        }
	      }
	
	      // Compile to array of path objects
	      i = 0;
	      while (x_path[i] != -1 && y_path[i] != -1 && x_path[i] !== undefined) {
	        path.push({
	          'x': x_path[i],
	          'y': y_path[i],
	          'action': path_actions[i]
	        });
	        i++;
	      }
	      return path;
	    }
	  }]);

	  return Unit;
	}();

/***/ }),
/* 7 */
/***/ (function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var Building = exports.Building = function () {
	  function Building(id) {
	    _classCallCheck(this, Building);
	
	    this.boardBuildingId = id;
	  }
	
	  _createClass(Building, [{
	    key: 'getPlayerNum',
	    value: function getPlayerNum() {
	      return board_buildings[this.boardBuildingId]['player_num'];
	    }
	  }, {
	    key: 'getTeam',
	    value: function getTeam() {
	      if (players_by_num[this.getPlayerNum()] === undefined) {
	        // no real for obstacles
	        return -1;
	      }
	      return players_by_num[this.getPlayerNum()]['team'];
	    }
	  }]);

	  return Building;
	}();

/***/ }),
/* 8 */
/***/ (function(module, exports, __webpack_require__) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	exports.BoardObject = undefined;
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	var _unit = __webpack_require__(6);
	
	var _building = __webpack_require__(7);
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var BoardObject = exports.BoardObject = function () {
	  function BoardObject(x, y) {
	    _classCallCheck(this, BoardObject);
	
	    this.boardObjectId = board[x][y]['ref'];
	    switch (board[x][y]['type']) {
	      case 'unit':
	        this.object = new _unit.Unit(this.boardObjectId);
	        break;
	      default:
	        this.object = new _building.Building(this.boardObjectId);
	        break;
	    }
	  }
	
	  _createClass(BoardObject, [{
	    key: "getPlayerNum",
	    value: function getPlayerNum() {
	      return this.object.getPlayerNum();
	    }
	  }, {
	    key: "getTeam",
	    value: function getTeam() {
	      return this.object.getTeam();
	    }
	  }]);

	  return BoardObject;
	}();

/***/ }),
/* 9 */
/***/ (function(module, exports) {

	"use strict";
	
	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	
	var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();
	
	function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
	
	var Cell = exports.Cell = function () {
	  function Cell() {
	    _classCallCheck(this, Cell);
	  }
	
	  _createClass(Cell, [{
	    key: "validCoords",
	    value: function validCoords(x, y) {
	      if (x < 0) return false;
	      if (y < 0) return false;
	      if (x > 19) return false;
	      if (y > 19) return false;
	      return true;
	    }
	  }]);

	  return Cell;
	}();

/***/ })
/******/ ]);
//# sourceMappingURL=mode.js.map