import Vue from 'vue'
import Vuex from 'vuex'
import players from './modules/players'
import games from './modules/games'
import createLogger from 'vuex/dist/logger'

Vue.use(Vuex)

const debug = process.env.NODE_ENV !== 'production'

export default new Vuex.Store({
  modules: {
    players,
    games
  },
  strict: debug,
  plugins: debug ? [createLogger()] : []
})