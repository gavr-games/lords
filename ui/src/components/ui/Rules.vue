<template>
  <div v-bind:class="['overlay', showRules ? 'active' : '']">
    <div class="landscape-page">
      <div class="rules-container">
        <a href="#" class="close-rules" @click="hideRulesWindow"> </a>
        <div class="rules" v-html="rulesText">
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { EventBus } from '../../lib/event_bus'
import axios from "axios"
import I18n from "../../lib/utils/i18n"

export default {
  data() {
    return {
      showRules: false,
      rulesText: ""
    }
  },
  created() {
    EventBus.$on('show-rules', this.showRulesWindow)
  },
  beforeDestroy () {
    EventBus.$off('show-rules', this.showRulesWindow)
  },
  methods: {
    showRulesWindow() {
      let docsUrl = "https://docs.google.com/document/d/e/2PACX-1vQmjG15nRuqi7G6bYktDioWmMiZ83RhrUUTsQQNtOlM_--Z1yGfTJWiyccqAbi1jY00ojdU7yKhDcML/pub?embedded=true"
      if (I18n.getUserLanguage() == 2) {
        docsUrl = "https://docs.google.com/document/d/e/2PACX-1vRDj3PmzPog5luXJ0YT1QQsFLdalN1oPLtSMaOJXimwN4FNLaiu-6elYdkoxozsrLk__XsMBq1k-b4F/pub?embedded=true"
      }
      axios.get(docsUrl)
        .then(response => this.rulesText = response.data)
        .catch(err => {
          console.log(err) 
        })
      this.showRules = true
    },
    hideRulesWindow() {
      this.showRules = false
    }
  }
}
</script>

<style lang="scss">
  .overlay {
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    background: rgba(0, 0, 0, 0.7);
    transition: opacity 500ms;
    visibility: hidden;
    opacity: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    &.active {
      visibility: visible;
      opacity: 1;
    }
    .landscape-page {
      height: 0;
      width: 80%;
      padding-top: 60.55%;
      background: url('../../assets/landscape_page.png') no-repeat;
      position: relative;
      transition: all 1s ease-in-out;
      background-size: contain;
      .rules-container {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        .rules {
          margin: 10%;
          overflow-y: scroll;
          height: 70%;
        }
        .close-rules {
          opacity: 0.5;
          display: block;
          position: absolute;
          background: url('../../assets/close_button.png') no-repeat;
          width: 29px;
          height: 28px;
          right: 7%;
          top: 7%;
          &:hover {
            opacity: 1;
          }
        }
      }
    }
  }
</style>