export default class Chars {
  static convertChars(s) {
    var xml_special_to_escaped_one_map = {
      '&': '&amp;',
      '"': '&quot;',
      '<': '&lt;',
      '>': '&gt;',
      '\\': '&#92;',
      '\'': '&apos;',
      '%': '&#37;'
    };
    return s.replace(/([\%\&"<>\\\'])/g, function(str, item) {
      return xml_special_to_escaped_one_map[item];
    });
  }

  static convertFromChars(s) {
    var escaped_one_to_xml_special_map = {
      '&amp;': '&',
      '&quot;': '"',
      '&lt;': '<',
      '&gt;': '>',
      '&#92;': '\\',
      '&apos;': '\'',
      '&#37;': '%'
    };
    return s.replace(/(&quot;|&lt;|&gt;|&amp;|&#92;|&apos;|&#37;)/g,
      function(str, item) {
          return escaped_one_to_xml_special_map[item];
      });
  }
}