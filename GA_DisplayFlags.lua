if( not gaCore ) then
    gaCore = {};
end
if( not gaCore.temp ) then
    gaCore.temp = {};
end
if( not gaCore.const ) then
    gaCore.const = {};
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Display Flags
--     A Races: DRAENEI, DWARF, GNOME, HUMAN, NIGHT_ELF, WORGEN
--     H Races: BLOOD_ELF, GOBLIN, ORC, TAUREN, TROLL, UNDEAD
--     N Races: PANDAREN
--     Classes: DEATH_KNIGHT, DRUID, HUNTER, MAGE, MONK, PALADIN, PRIEST, ROGUE, SHAMAN, WARLOCK, WARRIOR
-- Class Roles: DPS, HEALER, TANK
--  Raid Roles: RAID_LEADER, RAID_ASSISTANT, MASTER_LOOTER, MAIN_TANK, MAIN_ASSIST
-- Raid Groups: GROUP1, GROUP2, GROUP3, GROUP4, GROUP5, GROUP6, GROUP7, GROUP8
-- Guild Ranks: GUILD_MASTER, RANK2, RANK3, RANK4, RANK5, RANK6, RANK7, RANK8, RANK9, RANK10
--    Presence: AFK, DND, AFK_OR_DND, NOT_AFK, NOT_DND
--   PvP Flags: PVP_ON, PVP_OFF, FFA_ON, FFA_OFF
--  Zone Flags: NEUTRAL, FRIENDLY, HOSTILE, SANCTUARY, NORMAL_DUNGEON, HEROIC_DUNGEON, NORMAL_RAID, HEROIC_RAID,
--              RAID_10, RAID_25, ARENA, BATTLEGROUND, EXP_CLASSIC, EXP_BC, EXP_WRATH, EXP_CATA, EXP_MISTS
------------------------------------------------------------------------------------------------------------------------------------------------------------

gaCore.const.displayFlags = {};
    -- Matching Rules
        gaCore.const.displayFlags["MATCH_ALL"] = 0;
        gaCore.const.displayFlags["MATCH_ANY"] = 1;
    -- Alliance Races
        gaCore.const.displayFlags["DRAENEI"] = true;
        gaCore.const.displayFlags["DWARF"] = true;
        gaCore.const.displayFlags["GNOME"] = true;
        gaCore.const.displayFlags["HUMAN"] = true;
        gaCore.const.displayFlags["NIGHT_ELF"] = true;
        gaCore.const.displayFlags["WORGEN"] = true;
    -- Horde Races
        gaCore.const.displayFlags["BLOOD_ELF"] = true;
        gaCore.const.displayFlags["GOBLIN"] = true;
        gaCore.const.displayFlags["ORC"] = true;
        gaCore.const.displayFlags["TAUREN"] = true;
        gaCore.const.displayFlags["TROLL"] = true;
    -- Neutral Races
        gaCore.const.displayFlags["PANDAREN"] = true;
    -- Classes
        gaCore.const.displayFlags["DEATH_KNIGHT"] = true;
        gaCore.const.displayFlags["DRUID"] = true;
        gaCore.const.displayFlags["HUNTER"] = true;
        gaCore.const.displayFlags["MAGE"] = true;
        gaCore.const.displayFlags["MONK"] = true;
        gaCore.const.displayFlags["PALADIN"] = true;
        gaCore.const.displayFlags["PRIEST"] = true;
        gaCore.const.displayFlags["ROGUE"] = true;
        gaCore.const.displayFlags["SHAMAN"] = true;
        gaCore.const.displayFlags["WARLOCK"] = true;
        gaCore.const.displayFlags["WARRIOR"] = true;
    -- Class Roles
        gaCore.const.displayFlags["DPS"] = true;
        gaCore.const.displayFlags["HEALER"] = true;
        gaCore.const.displayFlags["TANK"] = true;
    -- Raid Roles
        gaCore.const.displayFlags["RAID_LEADER"] = true;
        gaCore.const.displayFlags["RAID_ASSISTANT"] = true;
        gaCore.const.displayFlags["MASTER_LOOTER"] = true;
        gaCore.const.displayFlags["MAIN_TANK"] = true;
        gaCore.const.displayFlags["MAIN_ASSIST"] = true;
    -- Raid Groups
        gaCore.const.displayFlags["GROUP1"] = true;
        gaCore.const.displayFlags["GROUP2"] = true;
        gaCore.const.displayFlags["GROUP3"] = true;
        gaCore.const.displayFlags["GROUP4"] = true;
        gaCore.const.displayFlags["GROUP5"] = true;
        gaCore.const.displayFlags["GROUP6"] = true;
        gaCore.const.displayFlags["GROUP7"] = true;
        gaCore.const.displayFlags["GROUP8"] = true;
    -- Guild Ranks
        gaCore.const.displayFlags["GUILD_MASTER"] = true;
        gaCore.const.displayFlags["RANK2"] = true;
        gaCore.const.displayFlags["RANK3"] = true;
        gaCore.const.displayFlags["RANK4"] = true;
        gaCore.const.displayFlags["RANK5"] = true;
        gaCore.const.displayFlags["RANK6"] = true;
        gaCore.const.displayFlags["RANK7"] = true;
        gaCore.const.displayFlags["RANK8"] = true;
        gaCore.const.displayFlags["RANK9"] = true;
        gaCore.const.displayFlags["RANK10"] = true;
    -- Presence
        gaCore.const.displayFlags["AFK"] = true;
        gaCore.const.displayFlags["DND"] = true;
        gaCore.const.displayFlags["AFK_OR_DND"] = true;
        gaCore.const.displayFlags["NOT_AFK"] = true;
        gaCore.const.displayFlags["NOT_DND"] = true;
    -- PvP Flags
        gaCore.const.displayFlags["PVP_ON"] = true;
        gaCore.const.displayFlags["PVP_OFF"] = true;
        gaCore.const.displayFlags["FFA_ON"] = true;
        gaCore.const.displayFlags["FFA_OFF"] = true;
    -- Zone Flags
        gaCore.const.displayFlags["NEUTRAL"] = true;
        gaCore.const.displayFlags["FRIENDLY"] = true;
        gaCore.const.displayFlags["HOSTILE"] = true;
        gaCore.const.displayFlags["SANCTUARY"] = true;
        gaCore.const.displayFlags["NORMAL_DUNGEON"] = true;
        gaCore.const.displayFlags["HEROIC_DUNGEON"] = true;
        gaCore.const.displayFlags["NORMAL_RAID"] = true;
        gaCore.const.displayFlags["HEROIC_RAID"] = true;
        gaCore.const.displayFlags["RAID_SIZE_10"] = true;
        gaCore.const.displayFlags["RAID_SIZE_25"] = true;
        gaCore.const.displayFlags["ARENA"] = true;
        gaCore.const.displayFlags["ARENA_SIZE_2"] = true;
        gaCore.const.displayFlags["ARENA_SIZE_3"] = true;
        gaCore.const.displayFlags["ARENA_SIZE_5"] = true;
        gaCore.const.displayFlags["BATTLEGROUND_NORMAL"] = true;
        gaCore.const.displayFlags["BATTLEGROUND_RATED"] = true;
        gaCore.const.displayFlags["EXP_CLASSIC"] = true;
        gaCore.const.displayFlags["EXP_BC"] = true;
        gaCore.const.displayFlags["EXP_WRATH"] = true;
        gaCore.const.displayFlags["EXP_CATA"] = true;
        gaCore.const.displayFlags["EXP_MISTS"] = true;


gaCore.const.displayFlagsReverse = {};
gaCore.temp.displayFlagNextValue = 1;
for flag, value in pairs( gaCore.const.displayFlags ) do
    if( value == true ) then
        gaCore.temp.displayFlagNextValue = gaCore.temp.displayFlagNextValue * 2;
        gaCore.const.displayFlags[flag] = gaCore.temp.displayFlagNextValue;
        gaCore.const.displayFlagsReverse[gaCore.temp.displayFlagNextValue] = flag;
    end
end
gaCore.lastDisplayFlag = gaCore.temp.displayFlagNextValue;


gaCore.displayFlagFunctions = {};
    -- Matching Rules
        gaCore.displayFlagFunctions["MATCH_ALL"] = nil;
        gaCore.displayFlagFunctions["MATCH_ANY"] = nil;
    -- Alliance Races
        gaCore.displayFlagFunctions["DRAENEI"] = true;
        gaCore.displayFlagFunctions["DWARF"] = true;
        gaCore.displayFlagFunctions["GNOME"] = true;
        gaCore.displayFlagFunctions["HUMAN"] = true;
        gaCore.displayFlagFunctions["NIGHT_ELF"] = true;
        gaCore.displayFlagFunctions["WORGEN"] = true;
    -- Horde Races
        gaCore.displayFlagFunctions["BLOOD_ELF"] = true;
        gaCore.displayFlagFunctions["GOBLIN"] = true;
        gaCore.displayFlagFunctions["ORC"] = true;
        gaCore.displayFlagFunctions["TAUREN"] = true;
        gaCore.displayFlagFunctions["TROLL"] = true;
    -- Neutral Races
        gaCore.displayFlagFunctions["PANDAREN"] = true;
    -- Classes
        gaCore.displayFlagFunctions["DEATH_KNIGHT"] = true;
        gaCore.displayFlagFunctions["DRUID"] = true;
        gaCore.displayFlagFunctions["HUNTER"] = true;
        gaCore.displayFlagFunctions["MAGE"] = true;
        gaCore.displayFlagFunctions["MONK"] = true;
        gaCore.displayFlagFunctions["PALADIN"] = true;
        gaCore.displayFlagFunctions["PRIEST"] = true;
        gaCore.displayFlagFunctions["ROGUE"] = true;
        gaCore.displayFlagFunctions["SHAMAN"] = true;
        gaCore.displayFlagFunctions["WARLOCK"] = true;
        gaCore.displayFlagFunctions["WARRIOR"] = true;
    -- Class Roles
        gaCore.displayFlagFunctions["DPS"] = true;
        gaCore.displayFlagFunctions["HEALER"] = true;
        gaCore.displayFlagFunctions["TANK"] = true;
    -- Raid Roles
        gaCore.displayFlagFunctions["RAID_LEADER"] = true;
        gaCore.displayFlagFunctions["RAID_ASSISTANT"] = true;
        gaCore.displayFlagFunctions["MASTER_LOOTER"] = true;
        gaCore.displayFlagFunctions["MAIN_TANK"] = true;
        gaCore.displayFlagFunctions["MAIN_ASSIST"] = true;
    -- Raid Groups
        gaCore.displayFlagFunctions["GROUP1"] = true;
        gaCore.displayFlagFunctions["GROUP2"] = true;
        gaCore.displayFlagFunctions["GROUP3"] = true;
        gaCore.displayFlagFunctions["GROUP4"] = true;
        gaCore.displayFlagFunctions["GROUP5"] = true;
        gaCore.displayFlagFunctions["GROUP6"] = true;
        gaCore.displayFlagFunctions["GROUP7"] = true;
        gaCore.displayFlagFunctions["GROUP8"] = true;
    -- Guild Ranks
        gaCore.displayFlagFunctions["GUILD_MASTER"] = true;
        gaCore.displayFlagFunctions["RANK2"] = true;
        gaCore.displayFlagFunctions["RANK3"] = true;
        gaCore.displayFlagFunctions["RANK4"] = true;
        gaCore.displayFlagFunctions["RANK5"] = true;
        gaCore.displayFlagFunctions["RANK6"] = true;
        gaCore.displayFlagFunctions["RANK7"] = true;
        gaCore.displayFlagFunctions["RANK8"] = true;
        gaCore.displayFlagFunctions["RANK9"] = true;
        gaCore.displayFlagFunctions["RANK10"] = true;
    -- Presence
        gaCore.displayFlagFunctions["AFK"] = true;
        gaCore.displayFlagFunctions["DND"] = true;
        gaCore.displayFlagFunctions["AFK_OR_DND"] = true;
        gaCore.displayFlagFunctions["NOT_AFK"] = true;
        gaCore.displayFlagFunctions["NOT_DND"] = true;
    -- PvP Flags
        gaCore.displayFlagFunctions["PVP_ON"] = true;
        gaCore.displayFlagFunctions["PVP_OFF"] = true;
        gaCore.displayFlagFunctions["FFA_ON"] = true;
        gaCore.displayFlagFunctions["FFA_OFF"] = true;
    -- Zone Flags
        gaCore.displayFlagFunctions["NEUTRAL"] = true;
        gaCore.displayFlagFunctions["FRIENDLY"] = true;
        gaCore.displayFlagFunctions["HOSTILE"] = true;
        gaCore.displayFlagFunctions["SANCTUARY"] = true;
        gaCore.displayFlagFunctions["NORMAL_DUNGEON"] = true;
        gaCore.displayFlagFunctions["HEROIC_DUNGEON"] = true;
        gaCore.displayFlagFunctions["NORMAL_RAID"] = true;
        gaCore.displayFlagFunctions["HEROIC_RAID"] = true;
        gaCore.displayFlagFunctions["RAID_SIZE_10"] = true;
        gaCore.displayFlagFunctions["RAID_SIZE_25"] = true;
        gaCore.displayFlagFunctions["ARENA"] = true;
        gaCore.displayFlagFunctions["ARENA_SIZE_2"] = true;
        gaCore.displayFlagFunctions["ARENA_SIZE_3"] = true;
        gaCore.displayFlagFunctions["ARENA_SIZE_5"] = true;
        gaCore.displayFlagFunctions["BATTLEGROUND_NORMAL"] = true;
        gaCore.displayFlagFunctions["BATTLEGROUND_RATED"] = true;
        gaCore.displayFlagFunctions["EXP_CLASSIC"] = true;
        gaCore.displayFlagFunctions["EXP_BC"] = true;
        gaCore.displayFlagFunctions["EXP_WRATH"] = true;
        gaCore.displayFlagFunctions["EXP_CATA"] = true;
        gaCore.displayFlagFunctions["EXP_MISTS"] = true;