var USER_LANGUAGE = 1;

function card_name(card_id) {
	return card_names[USER_LANGUAGE][card_id]["name"];
}

function card_description(card_id) {
	return card_names[USER_LANGUAGE][card_id]["description"];
}

function unit_name(unit_id) {
	return unit_names[USER_LANGUAGE][unit_id]["name"];
}

function unit_description(unit_id) {
	return unit_names[USER_LANGUAGE][unit_id]["description"];
}

function unit_log_name(unit_id, akk = false) {
	if (akk && unit_names[USER_LANGUAGE][unit_id]["log_name_accusative"]) {
		return unit_names[USER_LANGUAGE][unit_id]["log_name_accusative"];
	} else {
		return unit_names[USER_LANGUAGE][unit_id]["log_short_name"] || unit_names[USER_LANGUAGE][unit_id]["name"];
	}
}

function unit_feature_description(feature_id) {
	return unit_feature_names[USER_LANGUAGE][feature_id]["description"];
}

function building_name(building_id) {
	return building_names[USER_LANGUAGE][building_id]["name"];
}

function building_description(building_id) {
	return building_names[USER_LANGUAGE][building_id]["description"];
}

function building_log_name(building_id) {
	return building_names[USER_LANGUAGE][building_id]["log_short_name"] || building_names[USER_LANGUAGE][building_id]["name"];
}

function error_message(error_id) {
	return error_dictionary_messages[USER_LANGUAGE][error_id]["description"];
}

function procedure_param_description(procedure_param_id) {
	return procedures_params_descriptions[USER_LANGUAGE][procedure_param_id]["description"];
}

function log_message_text(message_code) {
	return log_message_texts[USER_LANGUAGE][message_code]["message"];
}

function npc_player_name(player_name) {
	return npc_player_name_with_params(player_name);
}

function npc_player_name_log(player_name, akk = false) {
	return npc_player_name_with_params(player_name, akk, 'log');
}

function npc_player_name_with_params(player_name, akk = false, log_name = false) {
	var placeholders = player_name.match(/\{[^}]+\}/g);
	placeholders.forEach(function(placeholder){
		var unit_id = placeholder.match(/[0-9]+/);
		if (unit_id) {
			var substitution_unit_name = log_name ? unit_log_name(unit_id, akk) : unit_name(unit_id);
			player_name = player_name.replace(placeholder, substitution_unit_name);
		} else {
			var substitution_modificator_text = log_name && npc_player_name_modificators[USER_LANGUAGE][placeholder]["log_text"] ?
					npc_player_name_modificators[USER_LANGUAGE][placeholder]["log_text"]
					: npc_player_name_modificators[USER_LANGUAGE][placeholder]["text"];
			player_name = player_name.replace(placeholder, substitution_modificator_text);
		}
	});
	return player_name;
}

