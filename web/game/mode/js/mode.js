"use strict"

import {Unit} from "./unit.js";
import {Building} from "./building.js";
import {BoardObject} from "./board_object.js";
import {Cell} from "./cell.js";

class GameMode {
  constructor() {
    this.Unit = Unit
    this.Building = Building
    this.BoardObject = BoardObject
    this.Cell = Cell
  }
}

window.GameMode = new GameMode();