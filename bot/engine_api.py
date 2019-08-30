import json
import urllib.request


ENGINE_URL = 'http://127.0.0.1:3000'


def get_response_json(url):
    response = urllib.request.urlopen(url)
    content = response.read()
    response.close()
    return json.loads(content)


def create_game():
    url = ENGINE_URL + '/newgame'
    return get_response_json(url)


def get_game_info(g_id):
    url = ENGINE_URL + '/game/' + g_id
    return get_response_json(url)


def act(g_id, p_num, action, params, what_if=False):
    call = 'whatif' if what_if else 'act'
    url = '{}/game/{}/{}/{}?action={}&{}'.format(ENGINE_URL, g_id, p_num, call, action, params)
    return get_response_json(url)


def move(g_id, p_num, obj_id, new_position, what_if=False):
    params = 'obj-id={}&new-position={}&new-position={}'.format(obj_id, new_position[0], new_position[1])
    return act(g_id, p_num, 'move', params, what_if)


def attack(g_id, p_num, obj_id, target_id, what_if=False):
    params = 'obj-id={}&target-id={}'.format(obj_id, target_id)
    return act(g_id, p_num, 'attack', params, what_if)


def end_turn(g_id, p_num, what_if=False):
    return act(g_id, p_num, 'end-turn', '', what_if)
