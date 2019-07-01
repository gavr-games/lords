"use strict"

import {Unit} from "./unit.js";
import {Building} from "./building.js";

export class BoardObject {
  constructor(x, y) {
    this.boardObjectId = board[x][y]['ref']
    switch(board[x][y]['type']){
      case 'unit':
        this.object = new Unit(this.boardObjectId)
      break;
      default:
        this.object = new Building(this.boardObjectId)
      break;
    }
  }

  getPlayerNum() {
    return this.object.getPlayerNum();
  }

  getTeam() {
    return this.object.getTeam();
  }
}