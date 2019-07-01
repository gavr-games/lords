export default function (context) {
  let authenticated = window.localStorage.getItem('authenticated')
  if (authenticated) {
    context.$WSClient.sendLoggedProtocolCmd({
      action: 'get_my_location',
      params: {}
    });
  }
}