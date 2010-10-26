this.getResponseForLogin = function(success, message) {
  xml = '';
  xml += '<?xml version="1.0" encoding="UTF8"?>'
  xml += '<login>'
  xml += '<success>' + success + '</success>'
  xml += '<message>' + message + '</message>'
  xml += '</login>'
  return xml
}
