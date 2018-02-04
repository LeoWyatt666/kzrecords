# kzrecords

## KZ World and Coommunity Records.

### File Version 0.5

Install:
1. Copy all files from folder "file" to "addons"
2. Add "SoLoader" metamod plugin in "addons/metamod/plugins.ini"
3. Add modules "curl" in "addons/amxmodx/configs/modules.ini"
4. Add plugin "kzrecords.amxx" in "addons/amxmodx/configs/plugins.ini"

5. Edit config file in addons/amxmodx/configs/kzrecords.cfg
```ini
// Cvars
kzr_prefix 		"[kzr]"	// Prefix message
kzr_end 		"1" 	// Finish buton show WR (1/0)
kzr_bots 		"wr" 	// Show FakeBot (wr, ru, ...)
kzr_bot_team	"1"		// Team in ScoreBoard: 1 = TERR, 2 = CT, 0/3 = SPECTATOR
```

6. Usage commands:
```ini
say /wr 		// /wr, /ru, ...
kzr_update xj 	// empty, xj, cc, ru
```

### MySQL Version 0.5

Install:
1. Copy all files from folder "mysql" to "addons"
2. Add plugin "kzrecords_sql.amxx" in addons/amxmodx/configs/plugins.ini
3. Add SQL files from folder addons/amxmodx/files/
4. Add to Cron php script update "addons/amxmodx/files/upd_kz_records.php"

5. Edit config file in addons/amxmodx/configs/kzrecords_sql.cfg
```ini
// Cvars
kzr_prefix 		"[kzr]"	// Prefix message
kzr_end 		"1" 	// Finish buton show WR (1/0)
kzr_bots 		"wr" 	// Show FakeBot (wr, ru, ...)
kzr_bot_team	"1"		// Team in ScoreBoard: 1 = TERR, 2 = CT, 0/3 = SPECTATOR

kzr_sql_host	"127.0.0.1" // DB host
kzr_sql_db		""			// DB database
kzr_sql_user	""			// DB user
kzr_sql_pass	""			// DB password
```

6. Usage commands:
```ini
say /wr 		// /wr, /ru, ...
```
