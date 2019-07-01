import {
  dic_player_status,
  error_dictionary_messages,
  games_feature_names,
  i18n
} from '@/lib/static_js/static_libs_portal'

export default class I18n {
  static player_status(status_id) {
    return dic_player_status[this.getUserLanguage()][status_id]["description"];
  }

  static error_message(error_id) {
    return error_dictionary_messages[this.getUserLanguage()][error_id]["description"];
  }

  static game_feature_description(feature_id) {
    return games_feature_names[this.getUserLanguage()][feature_id]["description"];
  }
  static getText(category, code = null) {
    let text = i18n[this.getUserLanguage()][category]
    if (code) {
      text = text[code]
    }
    return text
  }

  static getUserLanguage() {
    let localStorage = window.localStorage
    let userLanguage = localStorage.getItem('userLanguage')
    if (userLanguage === null) {
        userLanguage = 1
    }
    return userLanguage
  }

  static setUserLanguage(userLanguage) {
    let localStorage = window.localStorage
    localStorage.setItem('userLanguage', userLanguage)
    return userLanguage
  }
}