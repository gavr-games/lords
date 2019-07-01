export default function (context, payload) {
  if (parseInt(payload.game_type_id) == 0) { //stay on top site
    // #63 Temporarily login everyone to arena by default
    context.$WSClient.sendLoggedProtocolCmd({
        action: 'arena_enter',
        params: {}
    });
  } else { //go to arena, etc.
    if (payload.player_num && payload.player_num != '') { //go to started game
      context.$router.push('game')
    } else if (payload.game_id && payload.game_id != '') { //go to not started game
      context.$router.push('arena')
    } else if (parseInt(payload.game_type_id) == 1) { //go to arena
      context.$router.push('arena')
    } else if (payload.game_type_id != '') { //go to general location
      context.$router.push('/')
    }
  }
}