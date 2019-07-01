import {error_dictionary_messages} from '@/lib/static_js/static_libs_portal'
import I18n from './i18n'

export default class Errors {
  static getMsg(code, params) {
    params = decodeURIComponent(params);
    if (error_dictionary_messages[I18n.getUserLanguage()][code] !== undefined) {
      var msg = I18n.error_message(code);
      var p_arr = params.split(',');
      if (p_arr.length>0)
      for(var i=0;i<p_arr.length;i++){
          msg = msg.replace('{'+i+'}',p_arr[i]);
      }
      return msg;
    } else {
      return params;
    }
  }
}