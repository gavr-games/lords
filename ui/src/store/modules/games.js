// initial state
const state = {
  all: []
}

// getters
const getters = {
  getGame: (state) => (id) => {
    return state.all.find(p => parseInt(p.game_id) === parseInt(id))
  }
}

// actions
const actions = {
  setGames ({ commit }, games) {
    commit('setGames', games)
  },

  addGame ({ commit }, game) {
    commit('addGame', game)
  },

  removeGame ({ commit }, game) {
    commit('removeGame', game)
  },

  updateGame ({ commit }, game) {
    commit('updateGame', game)
  }
}

// mutations
const mutations = {
  setGames (state, games) {
    state.all = games
  },

  addGame (state, game) {
    state.all.push(game)
  },

  removeGame (state, id) {
    for(let i = 0; i < state.all.length; i++) { 
      if (parseInt(state.all[i].game_id) == parseInt(id)) {
        state.all.splice(i, 1)
      }
    }
  },

  updateGame (state, game) {
    for(let i = 0; i < state.all.length; i++) { 
      if (parseInt(state.all[i].user_id) == parseInt(game.game_id)) {
        state.all[i] = { ...state.all[i], ...game }
      }
    }
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}