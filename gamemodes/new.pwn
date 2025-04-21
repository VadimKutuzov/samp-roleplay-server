#include <a_samp>
#include <a_mysql>

#include <colors>

#pragma warning disable 239
#pragma warning disable 217

#define MYSQL_HOST "localhost"
#define MYSQL_USER "root"
#define MYSQL_PASS ""
#define MYSQL_BASE "krakozyabrik"

#define STR_COLOR_WHITE "{ffffff}"
#define STR_COLOR_RED "{ff0000}"
#define STR_COLOR_GREEN "{00d100}"


/**

	===================================	[ ПЕРЕМЕННЫЕ ] =============================================

*/

/**

	-- Переменные для подключения к MySQL

*/

enum player_information {

	pID,
	pName[MAX_PLAYER_NAME],
	pPassword[32],

}
new player_info[MAX_PLAYERS][player_information];
new MySQL:dbHandle;


enum dialogs {

	DLG_NONE,
	DLG_REG_PASS,

}


main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText("project-rp");
	ConnectingToMySQL();
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{

	GetPlayerName(
		playerid,
		player_info[playerid][pName],
		MAX_PLAYER_NAME
	);

	static const fmt_query[] =
		"SELECT * FROM `users` WHERE `name` = '%s'";
	new query[
		sizeof(fmt_query)+
		(-2+MAX_PLAYER_NAME)
	];
	format(query, 
		sizeof(query),
		fmt_query, player_info[playerid][pName]);
	mysql_tquery(
		dbHandle,
		query,
		"CheckRegistration",
		"i",
		playerid
	);

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) {

	SetPlayerPos(
		playerid,
		fX,
		fY,
		fZ
	);

	SetCameraBehindPlayer(playerid);

	return 1;
}

/**
	====================================================== [ Кастомные паблики ] =========================================================
*/

/**
	-- Подключение к MySQL
*/

stock ConnectingToMySQL() {

	dbHandle = 
		mysql_connect(
			MYSQL_HOST,
			MYSQL_USER,
			MYSQL_PASS,
			MYSQL_BASE
		);

	//dbHandle = mysql_connect_file("mysql.ini");

	switch(mysql_errno()) {

		case 0: print(
				"[MYSQL]: Подключение к базе  данных успешно установлено."
			);

		default: print(
				"[MYSQL]: Подключение к базе данных не было установлено!!!"
			);

	}

	mysql_log(
		ERROR | WARNING
	);
	mysql_set_charset("cp1251");

	return 1;
}

forward CheckRegistration(playerid);
public CheckRegistration(playerid) {

	new rows;
	cache_get_row_count(rows);

	if(rows) {

		Dialog_Login(playerid);

	} else {

		Dialog_Reg(playerid);

	}

	return 1;
}

stock Dialog_Login(playerid) {

	SendClientMessage(
		playerid,
		COLOR_GREEN,
		"Вы зарегистрированы."
	);

	return 1;
}

stock Dialog_Reg(playerid) {

	new str[306+MAX_PLAYER_NAME];

	format(
    str,
    sizeof(str),
    STR_COLOR_WHITE"Добро пожаловать на "STR_COLOR_GREEN"Project RolePlay"STR_COLOR_WHITE". Аккаунт "STR_COLOR_GREEN"%s[%d] "STR_COLOR_RED"не зарегистрирован.\n\
    "STR_COLOR_WHITE"Для игры на сервере введите ваш будущий пароль.\n\n\
    "STR_COLOR_RED"- Пароль должен быть от 6-ти до 32-ух символов.\n\
    - Пароль может состоять только из цифр и букв латинского алфавита.\n",
    player_info[playerid][pName],
    playerid
);

	ShowPlayerDialog(
		playerid,
		DLG_REG_PASS,
		DIALOG_STYLE_INPUT,
		"{00d100}Регистрация - Пароль",
		str,
		"Далее", 
		"Отмена"
	);

}