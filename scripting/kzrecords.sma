/* Plugin generated by AMXX-Studio */

/* Ty everest, gladius, Krolik, PomanoB */

#include <amxmodx>
#include <sockets>
#include <cstrike>
#include <hamsandwich>
#include <fakemeta>
#include <engine>
#include <colorchat>
#include <sorting>


#define PLUGIN "KZ Records"
#define VERSION "0.3"
#define AUTHOR "Jeronimo."

#pragma semicolon 1

/******************************************* VARS *************************************************/

new Buffer[25001];

new g_szMapName[32];
new bool:g_bShowRecordEnd = true;

new g_szDir[128];
new const g_szDirFile[] = "kzrecords";
new const g_szCommFile[] = "community.ini";
new const g_szCfgFile[] = "kzrecords.cfg";

new g_szCommDef[][][] =  {
	{ "xj", "Xtreme-Jumps", "http://xtreme-jumps.eu/demos.txt"},
	{ "cc", "Cosy-Climbing", "https://cosy-climbing.net/demos.txt"}
};

enum _:COMM {
	ID,
	NAME,
	URL,
	UPDATED,
	INFO,
	DEMOS
};
new g_szComm[32][COMM][256];

enum _:CVAR {
	BOTS,
	END,
	PREFIX,
	TEAM
};
new g_cvar[CVAR];

enum _:REC {
	MAPP,
	TIME,
	JUMPER,
	COUNTRY,
	MAP,
	EXT
};

/******************************************* BODY *************************************************/

// Init
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	// Client cmd
	register_clcmd("say", "CmdSayCheck");
	register_clcmd("say_team", "CmdSayCheck");
	register_clcmd("kzr_update", "UpdateRecords", ADMIN_RCON);
	
	// Finish button
	RegisterHam(Ham_Use, "func_button", "hamUse");
	
	// Cvars
	g_cvar[PREFIX] 	= register_cvar("kzr_prefix", "[kzr]", ADMIN_RCON);
	g_cvar[END] 	= register_cvar("kzr_end", "1", ADMIN_RCON);
	
	g_cvar[BOTS]	= register_cvar("kzr_bots", "wr", ADMIN_RCON);
	// 0 = CS_TEAM_UNASSIGNED, 1 = CS_TEAM_T, 2 = CS_TEAM_CT, 3 = CS_TEAM_SPECTATOR
	g_cvar[TEAM] 	= register_cvar("kzr_bot_team", "1", ADMIN_RCON);
	
	// Mapname
	get_mapname(g_szMapName, 31);
	strtolower(g_szMapName);
	
	// Read data comm from File;
	ReadCommunity();
	
	// Demos Files
	for(new i; i < sizeof(g_szComm[]); i++) {
		format(g_szComm[i][DEMOS], charsmax(g_szComm[][]),"%s/demos_%s.txt", g_szDir, g_szComm[i][ID]);
		format(g_szComm[i][INFO], charsmax(g_szComm[][]),"%s/info_%s.txt", g_szDir, g_szComm[i][ID]);
	}
	
	// BOTS
	CreateBots();		
}

public plugin_cfg() {
	new szCfgPath[96];
	get_localinfo("amxx_configsdir", szCfgPath, charsmax(szCfgPath));
	format(szCfgPath, charsmax(szCfgPath), "%s/%s", szCfgPath, g_szCfgFile);

	if(file_exists(szCfgPath)) {
		server_cmd("exec %s", szCfgPath);
		server_exec();
	}
}
/********************************************* COMM ***********************************************/

// Read data comm from File;
public ReadCommunity() {
	get_localinfo("amxx_datadir", g_szDir, charsmax(g_szDir));
	format(g_szDir, charsmax(g_szDir),"%s/%s", g_szDir, g_szDirFile);
	
	if(!dir_exists(g_szDir))
		mkdir(g_szDir);
		
	new szFile[128];
	format(szFile, charsmax(szFile) , "%s/%s", g_szDir, g_szCommFile);
	
	if(!file_exists(szFile))  {
		new hFile = fopen(szFile, "wt");
		fputs(hFile, "; Format: Id (say command), Name, Demos URL^n^n");
		
		for( new i; i < charsmax(g_szCommDef[]); i++ ) {
			new text[128];
			format(text,127,"%s, %s, %s^n", g_szCommDef[i][0], g_szCommDef[i][1], g_szCommDef[i][2]);
			fputs(hFile, text);
		}
		fclose(hFile);	
	}
	
	new hFile = fopen(szFile, "r");
	new szData[512];
	new num = 0;
	while(!feof(hFile))  {
		fgets(hFile, szData, charsmax(szData));
		trim(szData);
				
		if(!szData[0] || szData[0] == '^n' || szData[0] == ';')
			continue;

		ExplodeString(g_szComm[num], sizeof(g_szComm), charsmax(g_szComm[][]), szData, ',');
		num++;
	}
	fclose(hFile);
}

// Get Num By ID (say command)
stock GetCommNum(CommId[]) {	
	for( new i; i < sizeof(g_szComm[]); i++ ) {
		if(equal(g_szComm[i][ID], CommId) && g_szComm[i][ID][0]) {
			return i;
		}
	}
	return -1;
}

/********************************************* SAYS ***********************************************/

// Check say cmds
public CmdSayCheck() {
	new szInMsg[64];
	read_args(szInMsg, charsmax(szInMsg));
	strtolower(szInMsg);
	remove_quotes(szInMsg);
	trim(szInMsg);
	
	if(szInMsg[0] != '/')
		return PLUGIN_HANDLED;
		
	if(szInMsg[0])
		CmdSay(0, szInMsg);
		
	return PLUGIN_HANDLED;
}

// function Say
public CmdSay(id, szInMsg[64]) {
	new CommId[5], WhatMap[32], CommName[256];
	
	replace(szInMsg, charsmax(szInMsg), "/", "");
	parse(szInMsg, CommId, charsmax(CommId), WhatMap, charsmax(WhatMap));
	
	if(!CommId[0])
		return PLUGIN_CONTINUE;
		
	if(equal(CommId, "wr")) {
		CommId = "xj";
		CommName = "World";
	}
		
	new num = GetCommNum(CommId);
	
	if(num < 0)
		return PLUGIN_CONTINUE;
		
	if(!equal(CommName, "World"))
		copy(CommName, charsmax(CommName), g_szComm[num][NAME]);
			
	if(!WhatMap[0])
		WhatMap = g_szMapName;
	
	new szOutMsg[192];
	new iFound = ReadDemos(num, WhatMap, szOutMsg);
	if(equal(CommId, "xj") && !iFound) {
		ReadDemos(GetCommNum("cc"), WhatMap, szOutMsg);
	}
		
	new prefix[16];
	get_pcvar_string(g_cvar[PREFIX], prefix, charsmax(prefix));
	
	new text[256];
	format(text, charsmax(text), "^x04%s ^x01%s^x03 record on ^x04%s^x03: %s", prefix, CommName, WhatMap[0], szOutMsg);
	ColorChat(id, GREY,"^x03%s", text);
	
	return PLUGIN_CONTINUE;
}

/********************************************* DEMOS **********************************************/

// Create message
stock ReadDemos(num, WhatMap[32], szOutMsg[192], bool:color = true, bool:one = false) {
	if(num < 0)
		return 0;
	
	new DataRec[6][REC][64];
	new iFound = GetRecordData(WhatMap, DataRec, g_szComm[num][DEMOS]);
		
	format(szOutMsg, charsmax(szOutMsg), "No record");
	for(new i; i < iFound; i++) {
		if(!DataRec[i][JUMPER][0])
			break;
		
		if(DataRec[i][TIME][2] != ':')
				ClimbtimeToString(str_to_float(DataRec[i][TIME]), DataRec[i][TIME], 8);
				
		if(DataRec[i][EXT][0] && !one) {
			new szOutAdd[32];
			
			if(DataRec[i][TIME][0] == '*')
				format(szOutAdd, charsmax(szOutAdd), " ^x04[%s] ^x03 No record;", DataRec[i][EXT]);
			else
				format(szOutAdd, charsmax(szOutAdd), " ^x04[%s] %s^x01 by^x04 %s %s;", 
				DataRec[i][EXT], DataRec[i][TIME], DataRec[i][JUMPER], DataRec[i][COUNTRY]);
				
			add(szOutMsg, charsmax(szOutMsg), szOutAdd);
		}
		else {
			if(DataRec[i][TIME][0] == '*')
				format(szOutMsg, charsmax(szOutMsg), "No record");
				
			else
				format(szOutMsg, charsmax(szOutMsg), "^x01%s^x03 by^x04 %s %s", 
				DataRec[i][TIME], DataRec[i][JUMPER], DataRec[i][COUNTRY]);
		}	
	}
	
	if(!color) {
		replace_all(szOutMsg, charsmax(szOutMsg), "^x01", "");
		replace_all(szOutMsg, charsmax(szOutMsg), "^x03", "");
		replace_all(szOutMsg, charsmax(szOutMsg), "^x04", "");
	}
	
	return iFound;
}

// Get data from file
stock GetRecordData(const Map[32], DataRec[6][REC][64], RecFile[256]) {
	new szDataRec[REC][64];
	new i = 0, szData[64], iMapLen = strlen(Map);
	
	new iFile = fopen(RecFile, "rt");
	
	if(!iFile)
		return 0;
		
	while(!feof(iFile)) {
		fgets(iFile, szData, charsmax(szData));
		trim(szData);
		
		if(!szData[0] || !equali(szData, Map, iMapLen))
			continue;
		
		ExplodeString(szDataRec, sizeof(szDataRec), charsmax(szDataRec[]), szData, ' ');
		
		szDataRec[MAP] = szDataRec[MAPP];
		if(equal(szDataRec[MAPP][iMapLen], "[")) {
			strtok(szDataRec[MAPP], szDataRec[MAP], charsmax(szDataRec[]), szDataRec[EXT], charsmax(szDataRec[]), '[');
			copyc(szDataRec[EXT], 8, szDataRec[EXT], ']');
		}
		
		console_print(0, "%s %s %s", szDataRec[MAPP], szDataRec[MAP], szDataRec[EXT]);
			
		if(!equal(szDataRec[MAP], Map))
			continue;
			
		DataRec[i] = szDataRec;
		i++;
	}
	
	fclose(iFile);
	
	return i;
}

/********************************************* UPDATE *********************************************/

// Update cmds
public UpdateRecords() {
	new szInMsg[8];
	read_args(szInMsg, charsmax(szInMsg));
	strtolower(szInMsg);
	remove_quotes(szInMsg);
	trim(szInMsg);
	
	if(szInMsg[0])
		UpdateRecord(GetCommNum(szInMsg));
}

// Update function
public UpdateRecord(num) {
	new Host[96], Url[96], Socket[512], iSocket, Error;
	
	copy(Host, charsmax(Host),  g_szComm[num][URL] );
	replace(Host, charsmax(Host), "http://", "");
	
	new iPos = contain(Host, "/");
	if(iPos != -1) {
		copy(Url, 95, Host[iPos + 1]);
		Host[iPos] = 0;
	}
	
	iSocket = socket_open(Host, 80, SOCKET_TCP, Error);
	if(Error==0) {
		if (file_exists(g_szComm[num][DEMOS]))
			delete_file(g_szComm[num][DEMOS]);
		
		formatex(Socket, charsmax(Socket), "GET /%s HTTP/1.1^nHost: %s^r^n^r^n", Url, Host);
		
		socket_send(iSocket, Socket, charsmax(Socket));
		
		new iFile = fopen(g_szComm[num][DEMOS], "at");
		while(socket_recv(iSocket, Buffer, charsmax(Buffer))) {
			if(!Buffer[0])
				break;
			
			if( equali(Buffer, "HTTP", 4)) {
				new pos  = contain(Buffer, "^r^n^r^n") + 4;
				pos += contain(Buffer[pos], "^n") + 1;
				
				formatex(Buffer, charsmax(Buffer), Buffer[pos]);
			}
		
			fputs(iFile, Buffer);
		}
		fclose( iFile );
		
		socket_close(iSocket);
		
		console_print(0, "Update: OK");
	}
	else
		console_print(0, "Update: Error (%d)", Error);
}

/********************************************* FINISH *********************************************/

// Use func (bind key +use)
public hamUse(ent, id) {
	if(!get_pcvar_num(g_cvar[END]))
		return HAM_IGNORED;
	
	if(!(1 <= id <= get_maxplayers()))
		return HAM_IGNORED;
	
	new szTarget[32];
	pev(ent, pev_target, szTarget, 31);
	
	if((equal(szTarget, "counter_off") || 
	equal(szTarget, "clockstopbutton") || 
	equal(szTarget, "clockstop") || 	
	equal(szTarget, "stop_counter") || 
	equal(szTarget, "multi_stop"))) {
		if (g_bShowRecordEnd) {
			CmdSay(id, "/wr");
			g_bShowRecordEnd = false;
			set_task(10.0, "enablrecord", 500);
		}
	}
	
	return HAM_IGNORED;
}

// Time task
public enablrecord() {
	g_bShowRecordEnd = true;
}

/********************************************* BOTS ***********************************************/

// BOTS
public CreateBots() {
	new cvar[32];
	get_pcvar_string(g_cvar[BOTS], cvar, charsmax(cvar));
	if(cvar[0]) {
		new CommId[4][5];
		new count = ExplodeString(CommId, 4, 5, cvar, ' ');
		
		for(new i; i <= count; i++) {
			new botname[128], szOutMsg[192];
			
			if(equal(CommId[i], "wr"))
				CommId[i] = "xj";
			
			new iFound = ReadDemos(GetCommNum(CommId[i]), g_szMapName, szOutMsg, false, true);
			if(equal(CommId[i], "xj") && !iFound) {
				CommId[i] = "cc";
				iFound = ReadDemos(GetCommNum(CommId[i]), g_szMapName, szOutMsg, false, true);
			}
			
			
			if(iFound) {
				format(botname, charsmax(botname), "[%s] %s", CommId[i], szOutMsg);
				CreateBot(botname);
			}
		}
	}	
}

// Create FakeBot
public CreateBot(botname[]) {
	new id = engfunc(EngFunc_CreateFakeClient, botname);
	
	if(pev_valid(id)) {	
		//Supposed to prevent crashes?
		dllfunc(MetaFunc_CallGameEntity, "player", id);
		set_pev(id, pev_flags, FL_FAKECLIENT);

		//Make Sure they have no model
		set_pev(id, pev_model, "");
		set_pev(id, pev_viewmodel2, "");
		set_pev(id, pev_modelindex, 0);

		//Make them invisible for good measure
		set_pev(id, pev_renderfx, kRenderFxNone);
		set_pev(id, pev_rendermode, kRenderTransAlpha);
		set_pev(id, pev_renderamt, 0.0);
		
		new team = get_pcvar_num(g_cvar[TEAM]);
		if(0 <= team <= 3) cs_set_user_team(id, team);
	}
}

/********************************************* FUNC ***********************************************/

// Explode
stock ExplodeString( szOutput[][], nMax, nSize, szInput[], szDelimiter ) {
	new i = 0, nLen = 0, l = strlen(szInput);
	do {
		trim(szInput[nLen]);
		nLen += (1 + copyc( szOutput[i], nSize, szInput[nLen], szDelimiter ));
	} while ((nLen < l) && (++i <= nMax));
	return i;
}

// Convert Time
stock ClimbtimeToString(const Float:flClimbTime, szOutPut[], const iLen) {
	if(!flClimbTime) {
		copy(szOutPut, iLen, "**:**.**");
		return;
	}
	
	new iMinutes = floatround(flClimbTime / 60.0, floatround_floor);
	new iSeconds = floatround(flClimbTime - iMinutes * 60, floatround_floor);
	new iMiliSeconds = floatround((flClimbTime - (iMinutes * 60 + iSeconds) ) * 100, floatround_floor);
	
	formatex(szOutPut, iLen, "%02i:%02i.%02i", iMinutes, iSeconds, iMiliSeconds);
}

/********************************************* END ************************************************/