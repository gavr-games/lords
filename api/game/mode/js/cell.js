"use strict"

export class Cell {
  validCoords(x, y) {
    if (x < 0) return false;
    if (y < 0) return false;
    if (x > 19) return false;
    if (y > 19) return false;
    return true;
  }
}