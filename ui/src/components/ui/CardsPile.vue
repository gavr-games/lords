<template>
  <div class="cards-pile">
    <slot></slot>
  </div>
</template>

<style lang="scss">
  .cards-pile {
    width: 100%;
    min-height: 100%;
    background: url('../../assets/cards_pile_background.png') center;
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>