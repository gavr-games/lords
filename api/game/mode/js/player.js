"use strict"

export class Player {
  constructor(data) {
    this.player_num = data['player_num'].toInt()
    this.name = data['name']
    this.gold = data['gold'].toInt()
    this.owner = data['owner'].toInt()
    this.team = data['team'].toInt()
  }

  setGold(gold) {
    this.gold = gold.toInt()
  }
}