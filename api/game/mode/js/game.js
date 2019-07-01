"use strict"

export class Game {
  constructor(gameData, myPlayerNum) {
    this.creation_date = gameData['creation_date']
    this.game_id = gameData['game_id']
    this.mode_id = gameData['mode_id']
    this.owner_id = gameData['owner_id']
    this.status_id = gameData['status_id']
    this.time_restriction = gameData['time_restriction']
    this.title = gameData['title']
    this.type_id = gameData['type_id']

    this.PlayersController = new window.GameMode.PlayersController(myPlayerNum)
    this.CardsController = new window.GameMode.CardsController()
    this.TurnController = new window.GameMode.TurnController()
  }
}