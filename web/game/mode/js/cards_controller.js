"use strict"

export class CardsController {
  constructor() {
    this.cards = []
    this.cardActionDoneInThisTurn = false
  }

  setCardActionDoneInThisTurn(cardActionDoneInThisTurn) {
    this.cardActionDoneInThisTurn = cardActionDoneInThisTurn
  }

  canMakeAction() {
    let game = window.Game
    return (game.TurnController.myTurn && !game.CardsController.cardActionDoneInThisTurn)
  }

  canBuy() {
    return window.Game.PlayersController.getMyPlayer()['gold'].toInt() >= mode_config["card cost"]
      && (realtime_cards || this.canMakeAction());
  }
}