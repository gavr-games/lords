const sortPlayers = (players) => {
  return players.sort(function (a, b) {
    if (parseInt(b.status_id) != parseInt(a.status_id)) {
      return parseInt(b.status_id) - parseInt(a.status_id)
    }
    return b.nick > a.nick ? 1 : -1
  }).reverse()
}

// initial state
const state = {
  all: []
}

// getters
const getters = {
  getPlayer: (state) => (id) => {
    return state.all.find(p => parseInt(p.user_id) === parseInt(id))
  }
}

// actions
const actions = {
  setPlayers ({ commit }, players) {
    commit('setPlayers', players)
  },

  addPlayer ({ commit }, player) {
    commit('addPlayer', player)
  },

  removePlayer ({ commit }, player) {
    commit('removePlayer', player)
  },

  updatePlayer ({ commit }, player) {
    commit('updatePlayer', player)
  }
}

// mutations
const mutations = {
  setPlayers (state, players) {
    state.all = sortPlayers(players)
  },

  addPlayer (state, player) {
    state.all.push(player)
    state.all = sortPlayers(state.all)
  },

  removePlayer (state, id) {
    for(let i = 0; i < state.all.length; i++) { 
      if (parseInt(state.all[i].user_id) == parseInt(id)) {
        state.all.splice(i, 1)
      }
    }
    state.all = sortPlayers(state.all)
  },

  updatePlayer (state, player) {
    for(let i = 0; i < state.all.length; i++) { 
      if (parseInt(state.all[i].user_id) == parseInt(player.user_id)) {
        state.all[i] = { ...state.all[i], ...player }
      }
    }
    state.all = sortPlayers(state.all)
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}