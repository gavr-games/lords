"use strict"

import {Game} from "./game.js"
import {Player} from "./player.js"
import {PlayersController} from "./players_controller.js"
import {CardsController} from "./cards_controller.js"
import {TurnController} from "./turn_controller.js"
import {Unit} from "./unit.js"
import {Building} from "./building.js"
import {BoardObject} from "./board_object.js"
import {Cell} from "./cell.js"

class GameMode {
  constructor() {
    this.Unit = Unit
    this.Building = Building
    this.BoardObject = BoardObject
    this.Cell = Cell
    this.Game = Game
    this.Player = Player
    this.PlayersController = PlayersController
    this.CardsController = CardsController
    this.TurnController = TurnController
  }
}

window.GameMode = new GameMode()