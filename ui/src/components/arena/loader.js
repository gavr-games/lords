import Vue from 'vue'
import PlayersList from "./PlayersList"
import Chat from "./Chat"
import MyProfile from "./MyProfile"
import Profile from "./Profile"
import Game from "./Game"
import CreateGame from "./CreateGame"
import GamesList from "./GamesList"

Vue.component('arena-players-list', PlayersList)
Vue.component('arena-chat', Chat)
Vue.component('arena-my-profile', MyProfile)
Vue.component('arena-profile', Profile)
Vue.component('arena-game', Game)
Vue.component('arena-create-game', CreateGame)
Vue.component('arena-games-list', GamesList)