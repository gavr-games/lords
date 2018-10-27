"use strict"

export class Unit {
  constructor(id) {
    this.boardUnitId = id
  }

  getSize() {
    return units[board_units[this.boardUnitId]["unit_id"]]['size'].toInt();
  }

  getMovesLeft() {
    return board_units[this.boardUnitId]["moves_left"].toInt();
  }

  getPlayerNum() {
    return board_units[this.boardUnitId]['player_num'];
  }

  getTeam() {
    return players_by_num[this.getPlayerNum()]['team'];
  }

  getLeftUpCoord() {
    let id = this.boardUnitId;
    let ux = 9999999;
    let uy = 9999999;
    board.each(function(items, index) {
      if (items) items.each(function(item, index) {
        if (item)
          if (item["ref"] == id && item["type"] == "unit") {
            if (item["x"].toInt() < ux) ux = item["x"].toInt();
            if (item["y"].toInt() < uy) uy = item["y"].toInt();
          }
      });
    });
    return {x: ux, y: uy}
  }

  canMove() {
    let id = this.boardUnitId;
    return board_units[id]["moves_left"].toInt() > 0 && !$chk(board_units[id]['paralich'])
  }

  isNear(x, y) {
    let id = this.boardUnitId;
    var nearSelectedUnit = false;
    var cx;
    var cy;
    for (cx = x - 1; cx < x + 2; cx++)
      for (cy = y - 1; cy < y + 2; cy++) {
        if (board[cx])
          if (board[cx][cy])
            if (board[cx][cy]["ref"] == id && board[cx][cy]["type"] == 'unit') {
              nearSelectedUnit = true;
            }
      }
    return nearSelectedUnit;
  }

  canTeleport(x, y) {
    let id = this.boardUnitId;
    let size = this.getSize();
    var distance = 999999;
    var teleport = 0;
    var tx = 0;
    var ty = 0;
    var tid;
    board_buildings.each(function(item, index) {
      if (item)
        if ($chk(players_by_num[item['player_num']])) //player num 9 for trees,moat ... doesnt exists
          if (board_units[id]['magic_immunity'] != 1 && buildings[item["building_id"]]['ui_code'] == 'teleport' && (item['player_num'] == my_player_num || players_by_num[item['player_num']]['team'] == players_by_num[my_player_num]['team'])) { //this is my Teleport or my ally and unit is not golem(magic_immunity==1)
            tid = item["id"];
            teleport = 1;
            //get coords
            board.each(function(items, index) {
              if (items) items.each(function(item, index) {
                if (item)
                  if (item["ref"] == tid && item["type"] == "building") {
                    var a = x - item["x"].toInt();
                    var b = y - item["y"].toInt();
                    var dist = Math.sqrt(a*a + b*b);
                    if (dist < distance) { // in case of 2 teleports
                      distance = dist;
                      tx = item["x"].toInt();
                      ty = item["y"].toInt();
                    }
                  }
              });
            });
          }
    });
    return (x >= tx - size && x <= tx + 1) && (y >= ty - size && y <= ty + 1) && teleport == 1;
  }

  fitsCoord(x, y) {
    let mx, my;
    let id = this.boardUnitId;
    let size = this.getSize();
    for (mx = x; mx < x + size; mx++)
      for (my = y; my < y + size; my++) {
        if (board[mx])
          if (board[mx][my])
            if (board[mx][my]["ref"])
              if (board[mx][my]['type'] != 'unit' || board[mx][my]['ref'] != id) return false;
        if (mx < 0 || mx > 19 || my < 0 || my > 19) return false;
      }
    return true;
  }

  distToCoord(x, y) {
    let unitCoord = this.getLeftUpCoord();
    let movesLeft = this.getMovesLeft();
    return Math.max(Math.abs(unitCoord.x - x), Math.abs(unitCoord.y - y));
  }

  canFlyToCoord(x, y) {
    if (!this.fitsCoord(x, y)) {
      return false;
    }
    if (board_units[this.boardUnitId].flying != 1) {
      return false;
    }

    // Check flight distance
    let unitCoord = this.getLeftUpCoord();
    let movesLeft = this.getMovesLeft();
    if (this.distToCoord(x, y) > movesLeft) {
      return false;
    }

    return true;
  }

  getMoveCmds(x, y) {
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

    let targetX = x;
    let targetY = y;
    //Adjust move coords for big units
    let ux = this.getLeftUpCoord().x;
    let uy = this.getLeftUpCoord().y;
    if (this.isNear(x, y) && this.getSize() > 1) {
      if (x < ux) {
        targetX = x;
      } else if (x > (ux + this.getSize() - 1)) {
        targetX = x - this.getSize() + 1;
      } else {
        targetX = ux;
      }
      if (y < uy) {
        targetY = y;
      } else if (y > (uy + this.getSize() - 1)) {
        targetY = y - this.getSize() + 1;
      } else {
        targetY = uy;
      }
    }

    //Move unit according to path
    let path = this.getPath(targetX, targetY).slice(0, this.getMovesLeft());

    //Fly if cannot move to coords or it takes less moves to fly
    if ((path.length == 0 || path.length >= this.distToCoord(targetX, targetY)) && this.canFlyToCoord(targetX, targetY)) {
      return [{
        'x': targetX,
        'y': targetY,
        'action': 'm'
      }];
    }

    return path;
  }

  getPath(x, y) {
    var path = []
    var not_reached = true;
    var path_board = new Array();
    var i = 0;
    var k = 0;
    var l = 0;
    var m = 0;
    var symbols = new Array('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'c', 'd', 'e', 'f', 'g', 'h', 'k', 'l', 'm');
    var id = this.boardUnitId
    var size = units[board_units[id]["unit_id"]]['size'].toInt()
    var knight = board_units[id]["knight"]
    //init path board
    for (i = 0; i < 20; i++) {
        path_board[i] = new Array();
        for (k = 0; k < 20; k++) {
            path_board[i][k] = '-';
        }
    }
    //fill path board
    board.each(function(items, index) {
        if (items) items.each(function(item, index) {
            if (item) {
                if (item['type'] == 'unit' && item['ref'].toInt() == id); //this unit 
                else if (item['type'] == 'obstacle') //cant attack obstacle
                    path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
                else if (item['type'] == 'unit') { //attack unit
                    //fixing bug if we suddenly get not killed unit with not existing player (which already delted)
                    if (!$chk(players_by_num[board_units[item['ref']]['player_num']])) {
                        delete board[item['x'].toInt()][item['y'].toInt()];
                        if ($chk(board_units[item['ref']])) delete board_units[item['ref']];
                    } else if (board_units[id]['player_num'] == board_units[item['ref']]['player_num'] || players_by_num[board_units[id]['player_num']]['team'] == players_by_num[board_units[item['ref']]['player_num']]['team']) path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
                    else path_board[item['x'].toInt()][item['y'].toInt()] = 'u';
                } else { //buildings, castle
                    if ($chk(players_by_num[board_buildings[item['ref']]['player_num']])) { //player num 9 for trees,moat ... doesnt exists
                        if (board_units[id]['player_num'] == board_buildings[item['ref']]['player_num'] || players_by_num[board_units[id]['player_num']]['team'] == players_by_num[board_buildings[item['ref']]['player_num']]['team']) path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
                        else path_board[item['x'].toInt()][item['y'].toInt()] = 'b';
                    } else
                    if (board_buildings[item['ref']]['health'] > 0) //can kill bridge
                        path_board[item['x'].toInt()][item['y'].toInt()] = 'b';
                    else
                        path_board[item['x'].toInt()][item['y'].toInt()] = 'x';
                }
            }
        });
    });
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
        for (i = 0; i < 20; i++)
            for (k = 0; k < 20; k++) {
                cnear = false;
                if (path_board[i][k] == '-' || path_board[i][k] == 't') {
                    if (knight) {
                        for (l = i - 2; l < i + 3; l++)
                            for (m = k - 2; m < k + 3; m++) {
                                if (l >= 0 && l <= 19 && m >= 0 && m <= 19)
                                    if ((Math.abs(i - l) == 1 && Math.abs(k - m) == 2) || (Math.abs(i - l) == 2 && Math.abs(k - m) == 1))
                                        if ((step == 0 && path_board[l][m] == 'z') || (step != 0 && path_board[l][m] == symbols[step - 1]))
                                            if (size > 1) { //large unlts
                                                if (step == 0 && path_board[l][m] == 'z') {
                                                    if (l == ux && m == uy) cnear = 1;
                                                } else cnear = 1;
                                            } else cnear = 1;
                            }
                    } else { //usual moves
                        for (l = i - 1; l < i + 2; l++)
                            for (m = k - 1; m < k + 2; m++)
                                if (l >= 0 && l <= 19 && m >= 0 && m <= 19)
                                    if ((step == 0 && path_board[l][m] == 'z') || (step != 0 && path_board[l][m] == symbols[step - 1])) cnear = 1;
                    }
                    if (cnear) {
                        if (path_board[i][k] == 't') { //found target unit(s)
                            not_reached = false;
                        } else {
                            cango = true;
                            if (size > 1) { //large units
                                t_in = false;
                                x_in = false;
                                for (l = i; l < i + size; l++)
                                    for (m = k; m < k + size; m++) {
                                        if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
                                            if (path_board[l][m] == 'x') x_in = true;
                                            if (path_board[l][m] == 't') t_in = true;
                                            if (path_board[l][m] == 'x' || path_board[l][m] == 'u' || path_board[l][m] == 'b') cango = false;
                                        } else cango = false;
                                    }
                                //if can hit target unit by hitting also another b or u - and target not free cell
                                if (cango == false) {
                                    if ($chk(board[x]) && $chk(board[x][y]) && $chk(board[x][y]['ref']))
                                        if (t_in && !x_in) {
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
        step++;
    }
    //show board
    // if (x==18 && y==17) for (i=0;i<20;i++)	{
    //	console.log(path_board[0][i],path_board[1][i],path_board[2][i],path_board[3][i],path_board[4][i],path_board[5][i],path_board[6][i],path_board[7][i],path_board[8][i],path_board[9][i],path_board[10][i],path_board[11][i],path_board[12][i],path_board[13][i],path_board[14][i],path_board[15][i],path_board[16][i],path_board[17][i],path_board[18][i],path_board[19][i]);
    //}
    //generate 1 path
    step--;
    path_moves = step + 1;
    var x_path = []
    var y_path = []
    var path_actions = []
    var u_x = []
    var u_y = []
    for (i = 0; i < 40; i++) x_path[i] = -1;
    for (i = 0; i < 40; i++) y_path[i] = -1;
    if (target_coord == 'x') return []; //no allias hit
    for (i = 0; i < 40; i++) path_actions[i] = 'm';
    var cur_x = x;
    var cur_y = y;
    x_path[step] = cur_x;
    y_path[step] = cur_y;
    cango = true;
    var doattack = false;
    if (size > 1 && target_coord == '-') { //large units
        for (l = x_path[step]; l < x_path[step] + size; l++)
            for (m = y_path[step]; m < y_path[step] + size; m++)
                if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
                    if (path_board[l][m] == 'u' || path_board[l][m] == 'b') doattack = true;
                    if (path_board[l][m] == 'x') cango = false;
                } else cango = false;
    } else if (target_coord == 'b' || target_coord == 'u') {
        doattack = true;
    }
    if ((!cango && !doattack)) {
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
        if (knight == 1) { //knight moves
            for (i = cur_x - 2; i < cur_x + 3; i++)
                for (j = cur_y - 2; j < cur_y + 3; j++) {
                    if (i >= 0 && i <= 19 && j >= 0 && j <= 19)
                        if ((Math.abs(cur_x - i) == 1 && Math.abs(cur_y - j) == 2) || (Math.abs(cur_x - i) == 2 && Math.abs(cur_y - j) == 1))
                            if ((step == 0 && path_board[i][j] == 'z') || (step != 0 && path_board[i][j] == symbols[step - 1])) {
                                u_x[ufound] = i;
                                u_y[ufound] = j;
                                ufound++;
                            }
                }
        } else //usual moves
            for (i = cur_x - 1; i < cur_x + 2; i++)
                for (j = cur_y - 1; j < cur_y + 2; j++) {
                    if (i >= 0 && i <= 19 && j >= 0 && j <= 19)
                        if ((step == 0 && path_board[i][j] == 'z') || (step != 0 && path_board[i][j] == symbols[step - 1])) {
                            u_x[ufound] = i;
                            u_y[ufound] = j;
                            ufound++;
                        }
                }
        //pick random way
        /*if (ufound!=1)	{
			ufound = Math.floor(Math.random() * ufound);
		} else ufound--;*/

        //angle path choice
        l = Math.sqrt(Math.pow((cur_x - ux), 2) + Math.pow((cur_y - uy), 2));
        var sina = Math.abs(cur_x - ux) / l;

        var angl = 0; // general direction
        if (ux > cur_x && uy > cur_y) angl = Math.PI / 2 - Math.asin(sina);
        else if (cur_x == ux && uy > cur_y) angl = Math.PI / 2;
        else if (ux < cur_x && uy > cur_y) angl = Math.PI / 2 + Math.asin(sina);
        else if (cur_y == uy && ux < cur_x) angl = Math.PI;
        else if (ux < cur_x && uy < cur_y) angl = Math.PI + Math.PI / 2 - Math.asin(sina);
        else if (cur_x == ux && uy < cur_y) angl = Math.PI + Math.PI / 2;
        else if (ux > cur_x && uy < cur_y) angl = Math.PI * 1.5 + Math.asin(sina);
        u_x.each(function(item, index) {
            if ($chk(item)) {
                l = Math.sqrt(Math.pow((u_x[index] - cur_x), 2) + Math.pow((u_y[index] - cur_y), 2));
                sina = Math.abs(u_x[index] - cur_x) / l;

                var angl2 = 0; //possible direction
                if (u_x[index] > cur_x && u_y[index] > cur_y) angl2 = Math.PI / 2 - Math.asin(sina);
                else if (cur_x == u_x[index] && u_y[index] > cur_y) angl2 = Math.PI / 2;
                else if (u_x[index] < cur_x && u_y[index] > cur_y) angl2 = Math.PI / 2 + Math.asin(sina);
                else if (cur_y == u_y[index] && u_x[index] < cur_x) angl2 = Math.PI;
                else if (u_x[index] < cur_x && u_y[index] < cur_y) angl2 = Math.PI + Math.PI / 2 - Math.asin(sina);
                else if (cur_x == u_x[index] && u_y[index] < cur_y) angl2 = Math.PI + Math.PI / 2;
                else if (u_x[index] > cur_x && u_y[index] < cur_y) angl2 = Math.PI * 1.5 + Math.asin(sina);
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
            for (l = x_path[i]; l < x_path[i] + size; l++)
                for (m = y_path[i]; m < y_path[i] + size; m++)
                    if (l >= 0 && l <= 19 && m >= 0 && m <= 19) {
                        if (path_board[l][m] == 't') can_hit_earlier = true;
                    }
            i++;
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
      })
      i++
    }
    return path
  }
}