export default function (context, payload) {
  context.$WSClient.disconnect()
  let localStorage = window.localStorage
  localStorage.setItem('userId', payload.user_id)
  localStorage.setItem('authenticated', 1)
}