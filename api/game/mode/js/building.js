"use strict"

export class Building {
  constructor(id) {
    this.boardBuildingId = id
  }

  getPlayerNum() {
    return board_buildings[this.boardBuildingId]['player_num'];
  }

  getTeam() {
    if (players_by_num[this.getPlayerNum()] === undefined) { // no real for obstacles
      return -1;
    }
    return players_by_num[this.getPlayerNum()]['team'];
  }
}