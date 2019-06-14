"use strict"

export class PlayersController {
  constructor(myPlayerNum) {
    this.players = []
    this.myPlayerNum = myPlayerNum.toInt()
  }

  addPlayer(playerData) {
    player = new window.GameMode.Player(playerData)
    this.players.push(player)
  }

  removePlayer(playerNum) {
    this.players = this.players.filter((player, _index, _arr) => {
      return player.num != playerNum
    })
  }

  getMyPlayer() {
    return this.getPlayerByNum(this.myPlayerNum)
  }

  isMyPlayer(playerNum) {
    return playerNum.toInt() == this.myPlayerNum
  }

  getPlayerByNum(playerNum) {
    return this.players.find((player) => {
      return player.player_num == playerNum
    })
  }
}