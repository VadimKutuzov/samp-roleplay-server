#include <a_samp>
#include <a_mysql>
#include <colors>

// ==================== [ МАКРОСЫ ] ============================================
#define MYSQL_HOST "localhost" // либо 127.0.0.1
#define MYSQL_USER "root"
#define MYSQL_PASS ""
#define MYSQL_BASE "project_db_youtube" // название базы данных

#define SCM SendClientMessage
#define SPD ShowPlayerDialog




// ==================== [ ПЕРЕМЕННЫЕ ] =========================================
enum player_info
{
	pID,
	pName[MAX_PLAYER_NAME],
	pPassword[32],
	pGender,
	pSkin,
	pLevel,
	pMoney,
}
new pInfo[MAX_PLAYERS][player_info];
new MySQL:dbHandle;
new query[256];

enum 
{
	DLG_NONE, // 0
	DLG_SYS_REG_PASS,
	DLG_SYS_REG_GENDER,
}


main()
{
	print("\n----------------------------------");
	print(" MY PROJECT STARTED");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	SetGameModeText("project v1.0");
	dbHandle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_BASE);
	if(mysql_errno() != 0)
	{
		print("[MySQL]: Не удалось подключиться к базе данных сервера!");
	}
	else
	{
		print("[MySQL]: Подключение к базе данных сервера успешно установлено.");
	}
	return 1;
}

public OnGameModeExit()
{
	mysql_close(dbHandle);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	GetPlayerName(playerid, pInfo[playerid][pName], MAX_PLAYER_NAME);
	SetTimerEx("GetAccountFromMySQL", 1000, false, "i", playerid);
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
	switch(dialogid)
	{
		case DLG_SYS_REG_PASS:
		{
			if(!response) return Kick(playerid);
			if(response)
			{
				if(strlen(inputtext) < 8 || strlen(inputtext) > 32)
				{
					SCM(playerid, COLOR_RED, "Пароль должен быть от 8-ми до 32-ух символов!");
					return ShowRegistration(playerid);
				}
				for(new i = 0; i < strlen(inputtext); i++)
				{
					switch(inputtext[i])
					{
						case 'a'..'z', 'A'..'Z', '0'..'9': continue;
						default:
						{
							SCM(playerid, COLOR_RED, "Пароль должен состоять только из цифр и букв латинского алфавита.");
							return ShowRegistration(playerid);
						}
					}
				}
			}
			strins(pInfo[playerid][pPassword], inputtext, 0);
			SPD(playerid, DLG_SYS_REG_GENDER, DIALOG_STYLE_MSGBOX, "{ffffff}Регистрация - Выбор пола", "{ffffff}Выберите пол вашего персонажа", "Мужской", "Женский");
		}
		
		case DLG_SYS_REG_GENDER:
		{
			if(response)
			{
				pInfo[playerid][pGender] = 1;
				pInfo[playerid][pSkin] = 78;
			}
			else
			{
                pInfo[playerid][pGender] = 2;
				pInfo[playerid][pSkin] = 77;
			}
			format(query, sizeof(query), "INSERT INTO `users` (`name`, `password`, `gender`, `skin`) VALUES ('%s', '%s', '%d', '%d')", pInfo[playerid][pName], pInfo[playerid][pPassword], pInfo[playerid][pGender], pInfo[playerid][pSkin]);
			mysql_tquery(dbHandle, query);
		}
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

//========================== [ Кастомные функции ] =============================
forward GetAccountFromMySQL(playerid);
public GetAccountFromMySQL(playerid)
{
	format(query, sizeof(query), "SELECT * FROM `users` WHERE `name` = '%s'", pInfo[playerid][pName]);
	mysql_tquery(dbHandle, query, "CheckAccountInMySQL", "i", playerid);
	return 1;
}

forward CheckAccountInMySQL(playerid);
public CheckAccountInMySQL(playerid)
{
	if(cache_num_rows() == 0)
	{
        ShowRegistration(playerid);
	}
	else
	{
		SCM(playerid, COLOR_GREEN, "Вы зарегистрированы!");
	}
	return 1;
}

stock ShowRegistration(playerid)
{
	new str_1[320];
 	format(str_1, sizeof(str_1),
	 	"{ffffff}Добро пожаловать на {00c900}Project RolePlay{ffffff}, ваш никнейм {ffaa00}%s[%d] {ff0000}не зарегистрирован.\n\
		 {ffffff}Для регистрации на сервере придумайте пароль.\n\
		 \t- Пароль должен содержать от 8-ми до 32-ух символов.\n\
 		 \t- Пароль должен состоять только из цифр и букв латинского алфавита.",
	 pInfo[playerid][pName], playerid);
	SPD(playerid, DLG_SYS_REG_PASS, DIALOG_STYLE_INPUT, "Ввод пароля", str_1, "Далее", "Выход");
	return 1;
}



















