function validateForm(button, pass_mismatch, fields_blank) {
    var noError = true;
    $('game_error').hide();

    if ($('game_title').get('value') == '') {
        noError = false;
        $('game_error').set('text', fields_blank);
        $('game_error').show();
        if ($('game_title').get('value') == '') $('game_title').highlight('#A11D15');
    } else
    if ($('pass_i').get('value') != $('pass2_i').get('value') && $('pass_i').get('value') != '') {
        noError = false;
        $('game_error').set('text', pass_mismatch);
        $('game_error').show();
        $('pass_i').highlight('#A11D15');
        $('pass2_i').highlight('#A11D15');
    }
    if (noError) {
        button.addClass('loading');
        var passwd = '"' + $('pass_i').get('value').replace(new RegExp('"', 'g'), '\\"') + '"';
        if (passwd == '""') passwd = 'null';
        parent.parent.WSClient.sendLoggedProtocolCmd({
            action: 'arena_game_create',
            params: {
                title: '"' + parent.convertChars($('game_title').get('value')) + '"',
                pass: passwd,
                time_restriction: $('time_restriction').get('value'),
                mode: $('mode').get('value')
            }
        });
    }
}