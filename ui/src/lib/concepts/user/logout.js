export default function (context) {
  context.$WSClient.disconnect()
  let localStorage = window.localStorage
  localStorage.removeItem('userId')
  localStorage.removeItem('authenticated')
}