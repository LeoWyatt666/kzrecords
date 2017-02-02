/* Plugin generated by AMXX-Studio */


/*
#########################
PUBLIC VERSION OF KZ-RECORDS
#########################
*/

#include < amxmodx >
#include < sockets >
#include < hamsandwich >
#include < fakemeta >
#include < engine >
#include < colorchat >

#define PLUGIN "KZ Records PUBLIC"
#define VERSION "0.9"
#define AUTHOR "everest"

new e_LastUpdate[128], e_MapName[32], e_Buffer[25001],e_Records_Cvar[128], e_Records_EE[128],
 e_Records_BLT[128], e_Records_WR[128], e_Records_LV[128], e_Records_LT[128], e_Records_RO[128],
 e_Records_SK[128], e_Records_NO[128], e_Records_SE[128], e_Records_DK[128], e_Records_FI[128],
 e_Records_BG[128], e_Records_RU[128], e_Records_CL[128], e_Records_ARG[128], e_Records_BR[128],
 e_Records_LA[128], e_UpdatedNR = 1, e_CountryText[128]
 
 new bool:ShowRecordEnd = true



public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_clcmd("say", "CmdSayCheck")
	register_clcmd("say_team", "CmdSayCheck")
	register_clcmd("say /kzrecupdate", "UpdateRecords", ADMIN_RCON)
	RegisterHam(Ham_Use, "func_button", "hamUse");
	register_cvar("kz_records_country", "wr", ADMIN_RCON)
	
	get_mapname(e_MapName, 31)
	strtolower(e_MapName)
	
	new e_Temp[128]
	get_localinfo("amxx_datadir", e_Temp, 127)
	
	format(e_Temp, 127,"%s/kz_records", e_Temp)
	
	if ( !dir_exists(e_Temp) )
		mkdir(e_Temp);
		
	format(e_Records_WR,127,"%s/demos_wr.txt", e_Temp)
	format(e_Records_EE,127,"%s/demos_ee.txt", e_Temp)
	format(e_Records_BLT,127,"%s/demos_blt.txt", e_Temp)
	format(e_Records_LV,127,"%s/demos_lv.txt", e_Temp)
	format(e_Records_LT,127,"%s/demos_lt.txt", e_Temp)
	format(e_Records_RO,127,"%s/demos_ro.txt", e_Temp)
	format(e_Records_SK,127,"%s/demos_sk.txt", e_Temp)
	format(e_Records_NO,127,"%s/demos_no.txt", e_Temp)
	format(e_Records_SE,127,"%s/demos_se.txt", e_Temp)
	format(e_Records_DK,127,"%s/demos_dk.txt", e_Temp)
	format(e_Records_FI,127,"%s/demos_fi.txt", e_Temp)
	format(e_Records_BG,127,"%s/demos_bg.txt", e_Temp)
	format(e_Records_RU,127,"%s/demos_ru.txt", e_Temp)
	format(e_Records_CL,127,"%s/demos_cl.txt", e_Temp)
	format(e_Records_ARG,127,"%s/demos_arg.txt", e_Temp)
	format(e_Records_BR,127,"%s/demos_br.txt", e_Temp)
	format(e_Records_LA,127,"%s/demos_la.txt", e_Temp)
	CheckRecordCvar();
/*	
	format( e_LastUpdate, 127, "%s/demos_last_update.ini", e_Temp );
	
	if( !file_exists( e_LastUpdate ) ) {
		
		UpdateRecords( );
		
		return;
	}
	
	new iYear, iMonth, iDay, szDate[ 11 ];
	date( iYear, iMonth, iDay );
	
	new iFile = fopen( e_LastUpdate, "rt" );
	fgets( iFile, szDate, 10 );
	fclose( iFile );
	
	if( iYear > str_to_num( szDate[ 0 ] ) || iMonth > str_to_num( szDate[ 5 ] ) || iDay > str_to_num( szDate[ 8 ] ) )
	UpdateRecords();
*/
		
}

public CheckRecordCvar() {
	new Cvar[128]
	get_cvar_string("kz_records_country", Cvar, 127)
	
	if (equal(Cvar, "wr")) {
		e_Records_Cvar = e_Records_WR
		e_CountryText = "Current World record on :" 
		
	}
	if (equal(Cvar, "ee")) {
		e_Records_Cvar = e_Records_EE
		e_CountryText = "Current Estonian record on :" 
		
	}
	if (equal(Cvar, "lv")) {
		e_Records_Cvar = e_Records_LV
		e_CountryText = "Current Latvian record on :" 
		
	}
	if (equal(Cvar, "lt")) {
		e_Records_Cvar = e_Records_LT
		e_CountryText = "Current Lihtuanian record on :" 
		
	}	
	if (equal(Cvar, "baltic")) {
		e_Records_Cvar = e_Records_BLT
		e_CountryText = "Current Baltic record on :" 
		
	}
	if (equal(Cvar, "ro")) {
		e_Records_Cvar = e_Records_RO
		e_CountryText = "Current Romanian record on :" 
		
	}
	if (equal(Cvar, "sk")) {
		e_Records_Cvar = e_Records_SK
		e_CountryText = "Current Slovakian record on :" 
		
	}
	if (equal(Cvar, "no")) {
		e_Records_Cvar = e_Records_NO
		e_CountryText = "Current Norway record on :" 
		
	}
	if (equal(Cvar, "se")) {
		e_Records_Cvar = e_Records_SE
		e_CountryText = "Current Swedish record on :" 
		
	}
	if (equal(Cvar, "dk")) {
		e_Records_Cvar = e_Records_DK
		e_CountryText = "Current Danish record on :" 
		
	}
	if (equal(Cvar, "fi")) {
		e_Records_Cvar = e_Records_FI
		e_CountryText = "Current Finland record on :" 
		
	}
	if (equal(Cvar, "bg")) {
		e_Records_Cvar = e_Records_BG
		e_CountryText = "Current Bulgarian record on :" 
		
	}
	if (equal(Cvar, "ru")) {
		e_Records_Cvar = e_Records_RU
		e_CountryText = "Current Russian record on :" 
		
	}
	if (equal(Cvar, "cl")) {
		e_Records_Cvar = e_Records_CL
		e_CountryText = "Current Chile record on :" 
		
	}
	if (equal(Cvar, "arg")) {
		e_Records_Cvar = e_Records_ARG
		e_CountryText = "Current Argentina record on :" 
		
	}
	if (equal(Cvar, "br")) {
		e_Records_Cvar = e_Records_BR
		e_CountryText = "Current Brazil record on :" 
		
	}
	
	if (equal(Cvar, "la")) {
		e_Records_Cvar = e_Records_LA
		e_CountryText = "Current Latin American record on :"
	}
	
	
}

public CmdSayCheck(id) {
	new message[64], length
	read_args(message, 63)
	remove_quotes(message)
	strtolower(message)
	length = strlen(message)
	if ( message[0] == '/') {
		
	if (message[1] == 'w' && message[2]== 'r') {
	if (length > 3  && message[3] == ' ') {
		CmdSay(message[4], 1, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,1, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'e' && message[2] == 'e') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 2, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,2, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'l' && message[2] == 'v') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 3, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,3, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'l' && message[2] == 't') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 4, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,4, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'b' && message[2] == 'a' && message[3] == 'l'  && message[4] == 't' && message[5] == 'i' && message[6] == 'c') {
	if (length > 7  && message[7] == ' ') {
		CmdSay(message[8], 5, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 7) {
		CmdSay(0,5, id)
		return PLUGIN_HANDLED
	}
	}

	} else if (message[1] == 'r' && message[2] == 'o') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 6, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,6, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 's' && message[2] == 'k') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 7, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,7, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'n' && message[2] == 'o') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 8, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,8, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 's' && message[2] == 'e') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 9, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,9, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'd' && message[2] == 'k') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 10, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,10, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'f' && message[2] == 'i') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 11, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,11, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'b' && message[2] == 'g') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 12, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,12, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'r' && message[2] == 'u') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 13, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,13, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'c' && message[2] == 'l') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 14, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,14, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'a' && message[2] == 'r' && message[3] == 'g') {
	if (length > 4  && message[4] == ' ' ) {
		CmdSay(message[5], 15, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 4) {
		CmdSay(0,15, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'b' && message[2] == 'r') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 16, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,16, id)
		return PLUGIN_HANDLED
	}
	}
	} else if (message[1] == 'l' && message[2] == 'a') {
	if (length > 3  && message[3] == ' ' ) {
		CmdSay(message[4], 17, id)
		return PLUGIN_HANDLED
	} else {
		if (length == 3) {
		CmdSay(0,17, id)
		return PLUGIN_HANDLED
	}
	}
}
}
	return PLUGIN_CONTINUE;
}


public CmdSay( map, country, id ) {
	CheckRecordCvar()
	new szCommand[ 36 ];
	read_args( szCommand, 35 );
	remove_quotes( szCommand );
	new e_Whatmap[ 32 ];
	new e_WhatFile[ 128 ];
	
	e_Whatmap[31] = map;
		
	parse( szCommand, szCommand, 3, e_Whatmap, 31 );
	
	
	switch(country) {
		case 0: e_WhatFile = e_Records_Cvar
		case 1: e_WhatFile = e_Records_WR, e_CountryText = "Current World record on :"
		case 2: e_WhatFile = e_Records_EE, e_CountryText = "Current Estonian record on :"
		case 3: e_WhatFile = e_Records_LV, e_CountryText = "Current Latvian record on :"
		case 4: e_WhatFile = e_Records_LT, e_CountryText = "Current Lihtuanian record on :"
		case 5: e_WhatFile = e_Records_BLT, e_CountryText = "Current Baltic record on :"
		case 6: e_WhatFile = e_Records_RO, e_CountryText = "Current Romanian record on :"
		case 7: e_WhatFile = e_Records_SK, e_CountryText = "Current Slovakian record on :"
		case 8: e_WhatFile = e_Records_NO, e_CountryText = "Current Norway record on :"
		case 9: e_WhatFile = e_Records_SE, e_CountryText = "Current Swedish record on :"
		case 10: e_WhatFile = e_Records_DK, e_CountryText = "Current Danish record on :"
		case 11: e_WhatFile = e_Records_FI, e_CountryText = "Current Finland record on :"
		case 12: e_WhatFile = e_Records_BG, e_CountryText = "Current Bulgarian record on :"
		case 13: e_WhatFile = e_Records_RU, e_CountryText = "Current Russian record on :"
		case 14: e_WhatFile = e_Records_CL, e_CountryText = "Current Chile record on :"
		case 15: e_WhatFile = e_Records_ARG, e_CountryText = "Current Argentina record on :"
		case 16: e_WhatFile = e_Records_BR, e_CountryText = "Current Brazil record on :"
		case 17: e_WhatFile = e_Records_LA, e_CountryText = "Current Latin American record on :"
		
	}
	
	if ( !e_Whatmap[ 0 ] ) {
	e_Whatmap = e_MapName
	}
	
	if (map == 0) {
	e_Whatmap = e_MapName
	}
		
	new e_Message[ 401 ], e_Author[ 6 ][ 32 ], e_Time[ 6 ][ 9 ], e_Extension[ 6 ][ 8 ], iLen, iFounds;
	
	iFounds = GetRecordData( e_Whatmap, e_Author, e_Time, e_Extension, e_WhatFile );
	iLen    = formatex( e_Message, 400, "%s ^x04%s^x03:",e_CountryText, e_Whatmap[0] );
	
	
	if( iFounds > 0 ) {
			for( new i; i < iFounds; i++ ) {
				if( !e_Author[ i ][ 0 ] )
					break;
				
				if( e_Extension[ i ][ 0 ] ) {
				if( e_Time[ i ][ 0 ] == '*' )
					iLen += formatex( e_Message[ iLen ], 400 - iLen, " ^x04%s ^x03 No record.", e_Extension[ i ] );
				else
					iLen += formatex( e_Message[ iLen ], 400 - iLen, " ^x04%s %s^x03 by^x04 %s", e_Extension[ i ], e_Time[ i ], e_Author[ i ] );
				} else {
				if( e_Time[ i ][ 0 ] == '*' )
					iLen += formatex( e_Message[ iLen ], 400 - iLen, "^n  No record." );
					else
						iLen += formatex( e_Message[ iLen ], 400 - iLen, " ^x04%s^x03 by^x04 %s", e_Time[ i ], e_Author[ i ] );
				}
			}
		} else {
			iLen += formatex( e_Message[ iLen ], 400 - iLen, "^n   No record." );
		}
		
	if (id > 0 ) {
		ColorChat(id, GREY,"^x03%s",e_Message)
	}
	else
	{
	ColorChat(0, GREY,"^x03%s",e_Message)
	}
	return PLUGIN_HANDLED;
	}
	
	
	
	
	
ClimbtimeToString( const Float:flClimbTime, szOutPut[ ], const iLen ) {
	if( !flClimbTime ) {
		copy( szOutPut, iLen, "**:**.**" );
		
		return;
	}
	
	new iMinutes = floatround( flClimbTime / 60.0, floatround_floor );
	new iSeconds = floatround( flClimbTime - iMinutes * 60, floatround_floor );
	new iMiliSeconds = floatround( ( flClimbTime - ( iMinutes * 60 + iSeconds ) ) * 100, floatround_floor );
	
	formatex( szOutPut, iLen, "%02i:%02i.%02i", iMinutes, iSeconds, iMiliSeconds );
}

GetRecordData( const Map[ 32 ], Jumper[ 6 ][ 32 ], Time[ 6 ][ 9 ], Extension[ 6 ][ 8 ], e_WhatFile[ 128 ]) {
	new szData[ 64 ], szMap[ 32 ], szTime[ 9 ], iFounds, iLen, iMapLen = strlen( Map );
	
	new RecFile[128]
	RecFile = e_WhatFile
	
	
	new iFile = fopen( RecFile, "rt" );
	
	if( !iFile )
		return 0;
	
	while( !feof( iFile ) ) {
		fgets( iFile, szData, 63 );
		trim( szData );
		
		if( !szData[ 0 ] || !equali( szData, Map, iMapLen ) )
			continue;
		
		iLen = 1 + copyc( szMap, 31, szData, ' ' );
		
		if( szMap[ iMapLen ] != '[' && iMapLen != strlen( szMap ) )
			continue;
		
		iLen += 1 + copyc( szTime, 8, szData[ iLen ], ' ' );
		copy( Jumper[ iFounds ], 32, szData[ iLen ] );
		
		if( szTime[ 2 ] != ':' )
			ClimbtimeToString( str_to_float( szTime ), szTime, 8 );
		
		copy( Time[ iFounds ], 8, szTime );
		
		//Time[ iFounds ] = str_to_num( szTime );
		
		if( szMap[ iMapLen ] == '[' )
			copyc( Extension[ iFounds ], 8, szMap[ iMapLen + 1 ], ']' );
		
		iFounds++;
	}
	
	fclose( iFile );
	
	return iFounds;
}

public ReadWeb ( const iSocket ) {
	new RecFile[128]
	if ( e_UpdatedNR <= 2 ) 
		RecFile = e_Records_WR
	
	if ( e_UpdatedNR == 3 ) 
		RecFile = e_Records_EE
	
	if ( e_UpdatedNR == 4 ) 
		RecFile = e_Records_BLT
	
	if ( e_UpdatedNR == 5 ) 
		RecFile = e_Records_LV
	
	if ( e_UpdatedNR == 6 ) 
		RecFile = e_Records_LT
		
	if ( e_UpdatedNR == 7 )
		RecFile = e_Records_RO
		
	if ( e_UpdatedNR == 8 )
		RecFile = e_Records_SK
		
	if ( e_UpdatedNR == 9 )
		RecFile = e_Records_NO
		
	if ( e_UpdatedNR == 10 )
		RecFile = e_Records_SE
		
	if ( e_UpdatedNR == 11 )
		RecFile = e_Records_DK
		
	if ( e_UpdatedNR == 12 )
		RecFile = e_Records_FI
		
	if ( e_UpdatedNR == 13 )
		RecFile = e_Records_BG
		
	if ( e_UpdatedNR == 14 )
		RecFile = e_Records_RU
		
	if ( e_UpdatedNR == 15 )
		RecFile = e_Records_CL
		
	if ( e_UpdatedNR == 16 )
		RecFile = e_Records_ARG
		
	if ( e_UpdatedNR == 17 )
		RecFile = e_Records_BR
		
	if ( e_UpdatedNR == 18 )
		RecFile = e_Records_BR
		
	if ( e_UpdatedNR == 19 )
		RecFile = e_Records_LA


	e_UpdatedNR++;
	
	
	while (socket_recv( iSocket, e_Buffer, 25000 )) {
	
	if( e_Buffer[ 0 ] ) {
		if( e_Buffer[ 0 ] == 'H' && e_Buffer[ 1 ] == 'T' ) { // Header
			new iPos;
			iPos  = contain( e_Buffer, "^r^n^r^n" )   + 4;
			iPos += contain( e_Buffer[ iPos ], "^n" ) + 1;
			
			formatex( e_Buffer, charsmax( e_Buffer ), e_Buffer[ iPos ] );
		}
		
		new iFile = fopen( RecFile, "at" );
		fputs( iFile, e_Buffer );
		fclose( iFile );		
	}
}
	e_Buffer[ 0 ] = 0; // Clean the memory.
	socket_close( iSocket );
	
}

public UpdateRecords( ) {
	
	if ( file_exists( e_Records_WR ) )
		delete_file(e_Records_WR);
		
	if ( file_exists( e_Records_EE ) )
		delete_file(e_Records_EE);
		
	if ( file_exists( e_Records_BLT ) )
		delete_file(e_Records_BLT);
		
	if ( file_exists( e_Records_LV ) )
		delete_file(e_Records_LV);
		
	if ( file_exists( e_Records_LT ) )
		delete_file(e_Records_LT);
		
	if ( file_exists( e_Records_RO ) )
		delete_file(e_Records_RO);
		
	if ( file_exists( e_Records_SK ) )
		delete_file(e_Records_SK);
		
	if ( file_exists( e_Records_NO ) )
		delete_file(e_Records_NO);
		
	if ( file_exists( e_Records_SE ) )
		delete_file(e_Records_SE);
		
	if ( file_exists( e_Records_DK ) )
		delete_file(e_Records_DK);
		
	if ( file_exists( e_Records_FI ) )
		delete_file(e_Records_FI);
		
	if ( file_exists( e_Records_BG ) )
		delete_file(e_Records_BG);
				
	if ( file_exists( e_Records_RU ) )
		delete_file(e_Records_RU);
		
	if ( file_exists( e_Records_CL ) )
		delete_file(e_Records_CL);
		
	if ( file_exists( e_Records_ARG ) )
		delete_file(e_Records_ARG);
		
	if ( file_exists( e_Records_BR ) )
		delete_file(e_Records_BR);
		
	if ( file_exists( e_Records_LA ) )
		delete_file(e_Records_LA);
		
	if( file_exists( e_LastUpdate ) )
		delete_file( e_LastUpdate );
	
	new iYear, iMonth, iDay, szTemp[ 11 ];
	date( iYear, iMonth, iDay );
	
	new iFile = fopen( e_LastUpdate, "wt" );
	formatex( szTemp, 10, "%04ix%02ix%02i", iYear, iMonth, iDay );
	fputs( iFile, szTemp );
	fclose( iFile );

		
	new const e_DownloadLinks[19][] = {
		"http://xtreme-jumps.eu/demos_tcl.txt",
		"http://cosy-climbing.net/demoz.txt",
		"http://kz-baltic.eu/demos_ee.txt",
		"http://kz-baltic.eu/demos.txt",
		"http://kz-baltic.eu/demos_lv.txt",
		"http://kz-baltic.eu/demos_lt.txt",
		"http://www.romanian-jumpers.com/demos.txt",
		"http://www.kzsk.sk/demos/demos.txt",
		"http://www.kz-scandinavia.com/demos_no.txt",
		"http://www.kz-scandinavia.com/demos_se.txt",
		"http://www.kz-scandinavia.com/demos_dk.txt",
		"http://www.kz-scandinavia.com/demos_fi.txt",
		"http://bulgarian-kreedz.net/demos.txt",
		"http://kzru.net/demos.txt",
		"http://www.kreedz-chile.cl/demos.txt",
		"http://www.kz-argentina.com.ar/demos.txt",
		"http://kz-brazil.com/demos.txt",
		"http://www.kz-brazil.com/demos_no.txt",
		"http://www.kz-la.com/demos.txt"
	}
	
	new e_Host[ 96 ], e_Url[ 96 ], e_Socket[ 256 ], iPos, iSocket;
	
	for( new i; i < 19; i++ ) {
		copy( e_Host, 95, e_DownloadLinks[ i ][ 7 ] );
		iPos = contain( e_Host, "/" );
		
		if( iPos != -1 ) {
			copy( e_Url, 95, e_Host[ iPos + 1 ] );
			
			e_Host[ iPos ] = 0;
		}
		
		iSocket = socket_open( e_Host, 80, SOCKET_TCP, iPos );
		
		if( iPos > 0 ) {
			
			continue;
		}
		
		formatex( e_Socket, 255, "GET /%s HTTP/1.1^nHost: %s^r^n^r^n", e_Url, e_Host );
		
		socket_send( iSocket, e_Socket, 255 );
		
		set_task( 0.25, "ReadWeb", iSocket );
	}
		
		
}

public hamUse(ent, id) {
	new Cvar[128]
	get_cvar_string("kz_records_country", Cvar, 127)
	
	if (equal(Cvar, "off")) {
		return PLUGIN_HANDLED;
	}
	if(!(1 <= id <= get_maxplayers())) return HAM_IGNORED;
	
	new szTarget[32];
	pev(ent, pev_target, szTarget, 31);
	
	if((equal(szTarget, "counter_off") || 
	equal(szTarget, "clockstopbutton") || 
	equal(szTarget, "clockstop") || 
	equal(szTarget, "stop_counter") || 
	equal(szTarget, "multi_stop"))) 
	{
		if (ShowRecordEnd) {
		CmdSay( 0,0,-1 )
		ShowRecordEnd = false
		set_task(10.0,"enable_record")
		}
		
	}
	return HAM_IGNORED;
}

public enable_record()
{
	ShowRecordEnd = true
}