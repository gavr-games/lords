var last_executed_api = '';
var last_executed_procedure = '';
var commandsRequest;
var chatCommandsRequest;
var last_command_id = 0;
var chat_last_command_id = 0;
var DEBUG_MODE = 1;
var noNewCommandsRequest = false;

var active_chat = 0;
var my_user_id  = 0;

var ticksScroll;
var ticks_pos = 0;