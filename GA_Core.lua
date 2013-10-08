-------------------------------------------------------------------------------------
-- Package: Global Announce [Core]
--      By: Mysticell of Stormrage (US)
--  E-Mail: mysticell@warcraft365.com
-- Website: http://summit.warcraft365.com/index.php?/page/addons/ga/index.php
-- This site is currently under development.  Please send all inquiries via email.
-------------------------------------------------------------------------------------
-- Global Announce is an extensive communications addon which allows players and
-- other addons to easily send more noticeable messages to you.
-------------------------------------------------------------------------------------
-- Thanks to: Nefarion (of the Wowhead forums)     WoWWiki / Wowpedia
--            #wowuidev at freenode                WoWInterface
--            Kirov                                WoWProgramming
--            Ðemus of Stormrage                   SoundLib
--            <Summit> of Stormrage                Lua-users
-------------------------------------------------------------------------------------
-- Developer documentation is included in this package.
-------------------------------------------------------------------------------------
-- Your use of this software is governed by the Creative Commons BY-NC-SA license.
--
-- A copy of the license is available at:
-- http://creativecommons.org/licenses/by-nc-sa/3.0/us/
--
-- All derivitave work must include this notice and all original author credits.
-- You may not create derivitations that would be in violation of any Blizzard
-- policies, terms of service, or end user license agreements.
--
-- Additional permissions may be requested at:
-- http://summit.warcraft365.com/index.php?/page/addons/licensing_extra.php
-- or by emailing the author at: mysticell@warcraft365.com
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
-- Static Variables
-------------------------------------------------------------------------------------
-- NAMESPACE
if( not gaCore ) then
    gaCore = {};
end

-- GLOBAL
gaCore.addonVersion = GetAddOnMetadata("GlobalAnnounce", "Version");
gaCore.messagePrefix = "|cFF33CCFF[GlobalAnnounce]|r ";
gaCore.defaultLanguage = GetDefaultLanguage("player");
gaCore.playerFaction = UnitFactionGroup("player");
gaCore.playerGUID = UnitGUID("player");
gaCore.playerName = UnitName("player");
gaCore.playerRealm = GetRealmName();
gaCore.chatFrame = DEFAULT_CHAT_FRAME;
gaCore.debugMessageFrame = ChatFrame4;

-- LOCAL
gaCore.pluginVersion = GetAddOnMetadata("GlobalAnnounce", "Version");
gaCore.pluginMsgPrefix = gaCore.messagePrefix .. "|cFFFFFFFF[Core]|r ";

-- CONSTANTS
if( not gaCore.const ) then
    gaCore.const = {};
end

-- TEMP
if( not gaCore.temp ) then
    gaCore.temp = {};
end

-- EVENTS
gaCore.events = { "PLAYER_LOGIN",
                  "GUILD_MOTD",
                  "CHAT_MSG_ADDON" };

-- PREFIXES
gaCore.prefixes = { "GAnnoLogon",
                    "GAnnoRecvd",
                    "GAnnoPingRply",
                    "GAnnoEF",
                    "GAnnoRW",
                    "GAnnoPop",
                    "GAnnoSct",
                    "GAnnoSnd",
                    "GAnnoPing" };




-------------------------------------------------------------------------------------
-- Helper Functions
-------------------------------------------------------------------------------------
--[[
-- Function decToHex (updated): http://lua-users.org/lists/lua-l/2004-09/msg00054.html
function gaCore.decToHex(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.fmod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

function gaCore.rgbToHex(c)
    return gaCore.decToHex(math.round(c["r"])*255) .. gaCore.decToHex(math.round(c["g"])*255) .. gaCore.decToHex(math.round(c["b"])*255);
end
]]--

-- Function percToHex: http://www.wowpedia.org/RGBPercToHex
function gaCore.percToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

function gaCore.rgbToHex(c)
    return gaCore.percToHex( c["r"], c["g"], c["b"] );
end

function gaCore.inTable( value, t )
    for k, v in pairs( t ) do
        if( value == v ) then
            return true;
        end
    end
    return false;
end

-- Function ripairs: http://lua-users.org/wiki/IteratorsTutorial
function gaCore.ripairs( t )
    local max = 1;
    while t[max] ~= nil do
        max = max + 1;
    end
    local function ripairs_it( t, i )
        i = i-1;
        local v = t[i];
        if v ~= nil then
            return i,v;
        else
            return nil;
        end
    end
    return ripairs_it, t, max;
end

function gaCore.groupedWithUnit( source, dest )
    if( UnitInRaid(source) or UnitInParty(source) or UnitName("player") == source or UnitInRaid(dest) or UnitInParty(dest) or UnitName("player") == dest ) then
        return true;
    end
    return false;
end




-------------------------------------------------------------------------------------
-- Display Flag Functions
-------------------------------------------------------------------------------------
function gaCore.encodeDisplayFlags( flags )
    gaCore.temp.enum = 0;
    for index, flag in ipairs( flags ) do
        print( tostring( index ) .. " " .. tostring( flag ) .. " " .. tostring( gaCore.const.displayFlags[flag] ) );
        gaCore.temp.enum = gaCore.temp.enum + gaCore.const.displayFlags[flag];
    end
    return gaCore.temp.enum;
end

-- localize enum
function gaCore.decodeDisplayFlags( enum )
    gaCore.temp.flags = {};
    -- add even/odd check here
    for value, flag in gaCore.ripairs( gaCore.const.displayFlagsReverse ) do
        if( value <= enum ) then
            enum = enum - value;
            table.insert( gaCore.temp.flags, nil, flag );
        end
    end
    return gaCore.temp.flags;
end

function gaCore.evalDisplayFlags( flags )
    for flag in pairs( flags ) do
        
    end
end




-------------------------------------------------------------------------------------
-- Define StaticPopups
-------------------------------------------------------------------------------------
StaticPopupDialogs["GMOTD_POPUP"] = {
    text = "%s",
    whileDead = 1,
    hideOnEscape = 1,
    button1 = "Okay",
    timeout = 0
};
StaticPopupDialogs["GANNOUNCE_GUILD_POPUP"] = {
    text = "%s",
    whileDead = 1,
    hideOnEscape = 1,
    button1 = "Okay",
    timeout = 0
};
StaticPopupDialogs["GANNOUNCE_PARTY_POPUP"] = {
    text = "%s",
    whileDead = 1,
    hideOnEscape = 1,
    button1 = "Okay",
    timeout = 0
};
StaticPopupDialogs["GANNOUNCE_RAID_POPUP"] = {
    text = "%s",
    whileDead = 1,
    hideOnEscape = 1,
    button1 = "Okay",
    timeout = 0
};
StaticPopupDialogs["GANNOUNCE_INSTANCE_CHAT_POPUP"] = {
    text = "%s",
    whileDead = 1,
    hideOnEscape = 1,
    button1 = "Okay",
    timeout = 0
};
StaticPopupDialogs["GANNOUNCE_WHISPER_POPUP"] = {
    text = "%s",
    whileDead = 1,
    hideOnEscape = 1,
    button1 = "Okay",
    timeout = 0
};
StaticPopupDialogs["GANNOUNCE_SYSTEM_POPUP"] = {
    text = "%s",
    whileDead = 1,
    hideOnEscape = 1,
    button1 = "Okay",
    timeout = 0
};




-------------------------------------------------------------------------------------
-- Initialize
-------------------------------------------------------------------------------------
function gaCore.registerEvents(k,v)
    gaCore.eventFrame:RegisterEvent(v);
end
gaCore.eventFrame = CreateFrame("Frame", "gaCore.eventFrame");
table.foreach(gaCore.events, gaCore.registerEvents);

function gaCore.registerPrefixes(k,v)
    RegisterAddonMessagePrefix(v);
end




-------------------------------------------------------------------------------------
-- Create MessageFrame
-------------------------------------------------------------------------------------
--gaCore.messageFrame = CreateFrame("MessageFrame", "gaCore.messageFrame");




-------------------------------------------------------------------------------------
-- OnLoad
-------------------------------------------------------------------------------------
function gaCore.onLoad()
    -- Addon info to chat
    DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. "Global Announce Loaded (v" .. gaCore.addonVersion .. ") Type |cFFFFFFFF/ga|r for commands.", .3, 1, 0);
    DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. "Please send bug reports to: |cFF33CCFFmysticell@warcraft365.com|r", .3, 1, 0);
    -- Register addon message prefixes
    table.foreach(gaCore.prefixes, gaCore.registerPrefixes);
    -- New User
    if (gAnnounceSettings == nil) then
        gAnnounceSettings = {};
        gAnnounceSettings["displayGmotdPopup"] = 1;
        gAnnounceSettings["receiveAnnounces"] = 1;
        gAnnounceSettings["playSounds"] = 1;
        gAnnounceSettings["efDisplaytime"] = 12;
        gAnnounceSettings["soundsVerbose"] = 0;
    end
    -- New setting efDisplayTime
    if (gAnnounceSettings["efDisplaytime"] == nil) then
        gAnnounceSettings["efDisplaytime"] = 12;
        DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. "|cFF8C66FFA new setting has been added!|r  Type |cFFFFFFFF/ga settings eftime (seconds)|r to set how long error frame announcements should be displayed for before they fade out.", .3, 1, 0);
        UIErrorsFrame:AddMessage(gaCore.messagePrefix .. "|cFF8C66FFA new setting has been added!|r  See the chat frame for more info.", .3, 1, 0, gAnnounceSettings["efDisplayTime"]);
    end
    -- Announcement display disabled
    if (gAnnounceSettings["receiveAnnounces"] == 0) then
        DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. "Displaying announcements is currently |cFFFF0000DISABLED|r.  Type |cFFFFFFFF/ga settings enabled on|r to enable announcements.", .3, 1, 0);
        UIErrorsFrame:AddMessage(gaCore.messagePrefix .. "|cFFFF0000Displaying announcements is currently disabled.  See the chat frame for more info.", 1, 0, 0, gAnnounceSettings["efDisplayTime"]);
    end
    -- New setting playSounds
    if (gAnnounceSettings["playSounds"] == nil) then
        gAnnounceSettings["playSounds"] = 1;
        DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. "|cFF8C66FFA new setting has been added!|r  Type |cFFFFFFFF/ga settings playsounds (on||off)|r to enable or disable sound alerts that were added in v0.6.", .3, 1, 0);
        UIErrorsFrame:AddMessage(gaCore.messagePrefix .. "|cFF8C66FFA new setting has been added!|r  See the chat frame for more info.", .3, 1, 0, gAnnounceSettings["efDisplayTime"]);
    end
    -- Playing sound alerts disabled
    if (gAnnounceSettings["playSounds"] == 0) then
        DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. "Playing sound alerts is currently |cFFFF0000DISABLED|r.  Type |cFFFFFFFF/ga settings playsounds on|r to enable.", .3, 1, 0);
        UIErrorsFrame:AddMessage(gaCore.messagePrefix .. "|cFFFF0000Playing sound alerts is currently disabled.  See the chat frame for more info.", 1, 0, 0, gAnnounceSettings["efDisplayTime"]);
    end
    -- New setting soundsVerbose
    if (gAnnounceSettings["soundsVerbose"] == nil) then
        gAnnounceSettings["soundsVerbose"] = 0;
        DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. "|cFF8C66FFA new setting has been added!|r  Type |cFFFFFFFF/ga settings soundsverbose (on||off)|r to enable or disable showing a message when you receive the sound alert.", .3, 1, 0);
        UIErrorsFrame:AddMessage(gaCore.messagePrefix .. "|cFF8C66FFA new setting has been added!|r  See the chat frame for more info.", .3, 1, 0, gAnnounceSettings["efDisplayTime"]);
    end
    -- Show GMOTD login popup
    if (IsInGuild()) then
        if (gAnnounceSettings["displayGmotdPopup"] == 1) then
            -- Fix for bug ID#2 'GMOTD popup shows when GMOTD is blank"
            if (GetGuildRosterMOTD() and GetGuildInfo("player") and string.len(GetGuildRosterMOTD()) > 0) then
                StaticPopup_Show("GMOTD_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["GUILD"]) .. GetGuildInfo("player") .. ": |r" .. GetGuildRosterMOTD());
            else
                -- Fix for bug ID#1 'attempt to concatenate a nil value'
                --StaticPopup_Show("GMOTD_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["GUILD"]) .. GetGuildInfo("player") .. ": |rERROR: Unable to fetch guild MOTD or it is not set.");
            end
        end
    end
    -- Send version to guild
    SendAddonMessage("GAnnoLogon", gaCore.addonVersion, "GUILD");
    -- Ensure gaCore.playerGUID is set
    if( gaCore.playerGUID == nil ) then
        gaCore.playerGUID = UnitGUID("player");
    end
end




-------------------------------------------------------------------------------------
-- Display Announcement
-------------------------------------------------------------------------------------
function gaCore.displayAnnouncement(prefix, channel, text, sender, printchat)
    if (string.match(text, "^@(.+)$")) then
        text = string.sub(text, 2);
        printchat = false;
        if (prefix == "GAnnoSnd") then
            gaCore.temp.showSoundVerboseMessage = false;
        end
    else
        if (prefix == "GAnnoSnd") then
            gaCore.temp.showSoundVerboseMessage = true;
        end
    end
    if (type(printchat) ~= "boolean") then
        printchat = true;
    end
    -- UIErrorsFrame Announcement
    if (prefix == "GAnnoEF") then
        if (channel == "GUILD") then
            UIErrorsFrame:AddMessage(text, ChatTypeInfo["GUILD"]["r"] , ChatTypeInfo["GUILD"]["g"], ChatTypeInfo["GUILD"]["b"], GetChatTypeIndex("GUILD"), gAnnounceSettings["efDisplaytime"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Guild Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["GUILD"]["r"], ChatTypeInfo["GUILD"]["g"], ChatTypeInfo["GUILD"]["b"]); end
        elseif (channel == "PARTY") then
            UIErrorsFrame:AddMessage(text, ChatTypeInfo["PARTY"]["r"], ChatTypeInfo["PARTY"]["g"], ChatTypeInfo["PARTY"]["b"], GetChatTypeIndex("PARTY"), gAnnounceSettings["efDisplaytime"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Party Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["PARTY"]["r"], ChatTypeInfo["PARTY"]["g"], ChatTypeInfo["PARTY"]["b"]); end
        elseif (channel == "RAID") then
            UIErrorsFrame:AddMessage(text, ChatTypeInfo["RAID_LEADER"]["r"], ChatTypeInfo["RAID_LEADER"]["g"], ChatTypeInfo["RAID_LEADER"]["b"], GetChatTypeIndex("RAID_LEADER"), gAnnounceSettings["efDisplaytime"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Raid Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["RAID_LEADER"]["r"], ChatTypeInfo["RAID_LEADER"]["g"], ChatTypeInfo["RAID_LEADER"]["b"]); end
        elseif (channel == "INSTANCE_CHAT") then
            UIErrorsFrame:AddMessage(text, ChatTypeInfo["INSTANCE_CHAT_LEADER"]["r"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["g"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["b"], GetChatTypeIndex("INSTANCE_CHAT_LEADER"), gAnnounceSettings["efDisplaytime"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Instance Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["INSTANCE_CHAT_LEADER"]["r"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["g"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["b"]); end
        elseif (channel == "WHISPER") then
            UIErrorsFrame:AddMessage("[" .. sender .. "]: " .. text, ChatTypeInfo["WHISPER"]["r"], ChatTypeInfo["WHISPER"]["g"], ChatTypeInfo["WHISPER"]["b"], GetChatTypeIndex("WHISPER"), gAnnounceSettings["efDisplaytime"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[" .. sender .. "]: " .. text, ChatTypeInfo["WHISPER"]["r"], ChatTypeInfo["WHISPER"]["g"], ChatTypeInfo["WHISPER"]["b"]); end
            SendAddonMessage("GAnnoRecvd", text, WHISPER, sender);
        elseif (channel == "SYSTEM") then
            UIErrorsFrame:AddMessage(text, ChatTypeInfo["SYSTEM"]["r"], ChatTypeInfo["SYSTEM"]["g"], ChatTypeInfo["SYSTEM"]["b"], gAnnounceSettings["efDisplaytime"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage(text, ChatTypeInfo["SYSTEM"]["r"], ChatTypeInfo["SYSTEM"]["g"], ChatTypeInfo["SYSTEM"]["b"]); end
        end
    -- Raid Warning Announcement
    elseif (prefix == "GAnnoRW") then
        if (channel == "GUILD") then
            RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["GUILD"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Guild Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["GUILD"]["r"] , ChatTypeInfo["GUILD"]["g"], ChatTypeInfo["GUILD"]["b"]); end
        elseif (channel == "PARTY") then
            RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["PARTY"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Party Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["PARTY"]["r"] , ChatTypeInfo["PARTY"]["g"], ChatTypeInfo["PARTY"]["b"]); end
        elseif (channel == "RAID") then
            RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Raid Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["RAID"]["r"] , ChatTypeInfo["RAID"]["g"], ChatTypeInfo["RAID"]["b"]); end
        elseif (channel == "INSTANCE_CHAT") then
            RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["INSTANCE_CHAT"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Instance Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["INSTANCE_CHAT_LEADER"]["r"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["g"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["b"]); end
        elseif (channel == "WHISPER") then
            RaidNotice_AddMessage(RaidWarningFrame, "[" .. sender .. "]: " .. text, ChatTypeInfo["WHISPER"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[" .. sender .. "]: " .. text, ChatTypeInfo["WHISPER"]["r"], ChatTypeInfo["WHISPER"]["g"], ChatTypeInfo["WHISPER"]["b"]); end
            SendAddonMessage("GAnnoRecvd", text, WHISPER, sender);
        elseif (channel == "SYSTEM") then
            RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["SYSTEM"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage(text, ChatTypeInfo["SYSTEM"]["r"], ChatTypeInfo["SYSTEM"]["g"], ChatTypeInfo["SYSTEM"]["b"]); end
        end
    -- StaticPopup Announcement
    elseif (prefix == "GAnnoPop") then
        if (channel == "GUILD") then
            StaticPopup_Show("GANNOUNCE_GUILD_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["GUILD"]) .. text .. "|r");
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Guild Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["GUILD"]["r"] , ChatTypeInfo["GUILD"]["g"], ChatTypeInfo["GUILD"]["b"]); end
        elseif (channel == "PARTY") then
            StaticPopup_Show("GANNOUNCE_PARTY_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["PARTY"]) .. text .. "|r");
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Party Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["PARTY"]["r"], ChatTypeInfo["PARTY"]["g"], ChatTypeInfo["PARTY"]["b"]); end
        elseif (channel == "RAID") then
            StaticPopup_Show("GANNOUNCE_RAID_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["RAID_LEADER"]) .. text .. "|r");
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Raid Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["RAID_LEADER"]["r"], ChatTypeInfo["RAID_LEADER"]["g"], ChatTypeInfo["RAID_LEADER"]["b"]); end
        elseif (channel == "INSTANCE_CHAT") then
            StaticPopup_Show("GANNOUNCE_INSTANCE_CHAT_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["INSTANCE_CHAT_LEADER"]) .. text .. "|r");
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Instance Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["INSTANCE_CHAT_LEADER"]["r"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["g"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["b"]); end
        elseif (channel == "WHISPER") then
            StaticPopup_Show("GANNOUNCE_WHISPER_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["WHISPER"]) .. "[" .. sender .. "]: " .. text .. "|r");
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[" .. sender .. "]: " .. text, ChatTypeInfo["WHISPER"]["r"], ChatTypeInfo["WHISPER"]["g"], ChatTypeInfo["WHISPER"]["b"]); end
            SendAddonMessage("GAnnoRecvd", text, WHISPER, sender);
        elseif (channel == "SYSTEM") then
            StaticPopup_Show("GANNOUNCE_SYSTEM_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["SYSTEM"]) .. text .. "|r");
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage(text, ChatTypeInfo["SYSTEM"]["r"], ChatTypeInfo["SYSTEM"]["g"], ChatTypeInfo["SYSTEM"]["b"]); end
        end
    -- Blizzard Scrolling Combat Text Announcement
    elseif (prefix == "GAnnoSct") then
        if (channel == "GUILD") then
            CombatText_AddMessage(text, COMBAT_TEXT_SCROLL_FUNCTION, ChatTypeInfo["GUILD"]["r"] , ChatTypeInfo["GUILD"]["g"], ChatTypeInfo["GUILD"]["b"], 0, 0);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Guild Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["GUILD"]["r"] , ChatTypeInfo["GUILD"]["g"], ChatTypeInfo["GUILD"]["b"]); end
        elseif (channel == "PARTY") then
            CombatText_AddMessage(text, COMBAT_TEXT_SCROLL_FUNCTION, ChatTypeInfo["PARTY"]["r"], ChatTypeInfo["PARTY"]["g"], ChatTypeInfo["PARTY"]["b"], 0, 0);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Party Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["PARTY"]["r"], ChatTypeInfo["PARTY"]["g"], ChatTypeInfo["PARTY"]["b"]); end
        elseif (channel == "RAID") then
            CombatText_AddMessage(text, COMBAT_TEXT_SCROLL_FUNCTION, ChatTypeInfo["RAID_LEADER"]["r"], ChatTypeInfo["RAID_LEADER"]["g"], ChatTypeInfo["RAID_LEADER"]["b"]);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Raid Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["RAID_LEADER"]["r"], ChatTypeInfo["RAID_LEADER"]["g"], ChatTypeInfo["RAID_LEADER"]["b"]); end
        elseif (channel == "INSTANCE_CHAT") then
            CombatText_AddMessage(text, COMBAT_TEXT_SCROLL_FUNCTION, ChatTypeInfo["INSTANCE_CHAT_LEADER"]["r"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["g"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["b"], 0, 0);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Instance Announcement] [" .. sender .. "]: " .. text, ChatTypeInfo["INSTANCE_CHAT_LEADER"]["r"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["g"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["b"]); end
        elseif (channel == "WHISPER") then
            CombatText_AddMessage("[" .. sender .. "]: " .. text, COMBAT_TEXT_SCROLL_FUNCTION, ChatTypeInfo["WHISPER"]["r"], ChatTypeInfo["WHISPER"]["g"], ChatTypeInfo["WHISPER"]["b"], 0, 0);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[" .. sender .. "]: " .. text, ChatTypeInfo["WHISPER"]["r"], ChatTypeInfo["WHISPER"]["g"], ChatTypeInfo["WHISPER"]["b"]); end
            SendAddonMessage("GAnnoRecvd", text, WHISPER, sender);
        elseif (channel == "SYSTEM") then
            CombatText_AddMessage(text, COMBAT_TEXT_SCROLL_FUNCTION, ChatTypeInfo["SYSTEM"]["r"], ChatTypeInfo["SYSTEM"]["g"], ChatTypeInfo["SYSTEM"]["b"], gAnnounceSettings["efDisplaytime"], 0, 0);
            if (printchat) then DEFAULT_CHAT_FRAME:AddMessage(text, ChatTypeInfo["SYSTEM"]["r"], ChatTypeInfo["SYSTEM"]["g"], ChatTypeInfo["SYSTEM"]["b"]); end
        end
    -- Sound Alerts
    elseif (prefix == "GAnnoSnd") then
        if (string.match(text, "^@(.+)$")) then
            text = string.sub(text, 2);
            gaCore.temp.showSoundVerboseMessage = false;
        else
            gaCore.temp.showSoundVerboseMessage = true;
        end
        if (string.match(text, "^#(.+)$")) then
            text = string.sub(text, 2);
            gaCore.temp.soundChannel = "Master";
        else
            gaCore.temp.soundChannel = nil;
        end
        gaCore.temp.soundIndex = tonumber(text);
        gaCore.temp.gaSoundIndex = string.match(text, "^ga(%d+)$");
        if (gaCore.temp.soundIndex) then
            gaCore.temp.soundFile = SoundLib[gaCore.temp.soundIndex];
            if (gaCore.temp.soundFile) then
                PlaySoundFile(gaCore.temp.soundFile, gaCore.temp.soundChannel);
            end
        elseif (gaCore.temp.gaSoundIndex) then
            if (gaSounds.fileList) then
                gaCore.temp.gaSoundFile = gaSounds.fileList[gaCore.temp.gaSoundIndex];
                if (gaCore.temp.gaSoundFile) then
                    PlaySoundFile(gaCore.temp.gaSoundFile, gaCore.temp.soundChannel);
                end
            else
                DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. "Could not play sound (" .. text .. ") because GA_Sounds is not installed or enabled.", 1, 0, 0);
            end
        else
            PlaySound(text);
            PlaySoundFile(text, gaCore.temp.soundChannel);
        end
        if (gAnnounceSettings["soundsVerbose"] == 1 and gaCore.temp.showSoundVerboseMessage) then
            if (channel == "GUILD") then
                if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Guild] " .. sender .. " sent an audio alert. (" .. text .. ")", ChatTypeInfo["GUILD"]["r"] , ChatTypeInfo["GUILD"]["g"], ChatTypeInfo["GUILD"]["b"]); end
            elseif (channel == "PARTY") then
                if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Party] " .. sender .. " sent an audio alert. (" .. text .. ")", ChatTypeInfo["PARTY"]["r"], ChatTypeInfo["PARTY"]["g"], ChatTypeInfo["PARTY"]["b"]); end
            elseif (channel == "RAID") then
                if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Raid] " .. sender .. " sent an audio alert. (" .. text .. ")", ChatTypeInfo["RAID_LEADER"]["r"], ChatTypeInfo["RAID_LEADER"]["g"], ChatTypeInfo["RAID_LEADER"]["b"]); end
            elseif (channel == "INSTANCE_CHAT") then
                if (printchat) then DEFAULT_CHAT_FRAME:AddMessage("[Instance] " .. sender .. " sent an audio alert. (" .. text .. ")", ChatTypeInfo["INSTANCE_CHAT_LEADER"]["r"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["g"], ChatTypeInfo["INSTANCE_CHAT_LEADER"]["b"]); end
            elseif (channel == "WHISPER") then
                if (printchat) then DEFAULT_CHAT_FRAME:AddMessage(sender .. " sent an audio alert. (" .. text .. ")", ChatTypeInfo["WHISPER"]["r"], ChatTypeInfo["WHISPER"]["g"], ChatTypeInfo["WHISPER"]["b"]); end
                SendAddonMessage("GAnnoRecvd", text, WHISPER, sender);
            elseif (channel == "SYSTEM") then
                if (sender) then
                    DEFAULT_CHAT_FRAME:addMessage(sender, ChatTypeInfo["SYSTEM"]["r"], ChatTypeInfo["SYSTEM"]["g"], ChatTypeInfo["SYSTEM"]["b"]);
                end
            end
        else
            if (channel == "WHISPER") then
                SendAddonMessage("GAnnoRecvd", text, WHISPER, sender);
            end
        end
    end
end




-------------------------------------------------------------------------------------
-- OnEvent
-------------------------------------------------------------------------------------
function gaCore.onEvent(self, event, prefix, text, channel, sender, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16)
    -- On Player Login
    if (event == "PLAYER_LOGIN") then
        gaCore.onLoad();
    -- On GMOTD Update
    elseif (event == "GUILD_MOTD") then
        -- Fix for bug ID#1 'attempt to concatenate a nil value'
        -- Fix for bug ID#2 'GMOTD popup shows when GMOTD is blank"
        if (gAnnounceSettings["displayGmotdPopup"] == 1 and GetGuildInfo("player") and prefix and string.len(prefix) > 0) then
            StaticPopup_Show("GMOTD_POPUP", "|cFF" .. gaCore.rgbToHex(ChatTypeInfo["GUILD"]) .. GetGuildInfo("player") .. ": |r" .. prefix);
        end
    -- On Addon Message
    elseif (event == "CHAT_MSG_ADDON") then
        if (gAnnounceSettings["receiveAnnounces"] == 1) then
            if (prefix == "GAnnoRecvd") then
                DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. sender .. " has received your message.", ChatTypeInfo["WHISPER_INFORM"]["r"], ChatTypeInfo["WHISPER_INFORM"]["g"], ChatTypeInfo["WHISPER_INFORM"]["b"]);
            -- Ping
            elseif (prefix == "GAnnoPing") then
                SendAddonMessage("GAnnoPingRply", gaCore.addonVersion, WHISPER, sender);
            -- Pong
            elseif (prefix == "GAnnoPingRply") then
                DEFAULT_CHAT_FRAME:AddMessage(gaCore.messagePrefix .. sender .. " has Global Announce. (v" .. text .. ")", ChatTypeInfo["WHISPER_INFORM"]["r"], ChatTypeInfo["WHISPER_INFORM"]["g"], ChatTypeInfo["WHISPER_INFORM"]["b"]);
            elseif (prefix == "GAnnoEF" or prefix == "GAnnoRW" or prefix == "GAnnoPop" or prefix == "GAnnoSct" or prefix == "GAnnoSnd") then
                if (channel == "GUILD") then
                    gaCore.temp.gpCheck = {};
                    gaCore.temp.gpCheck.guildName, gaCore.temp.gpCheck.guildRankName, gaCore.temp.gpCheck.guildRankIndex = GetGuildInfo(sender);
                    GuildControlSetRank(gaCore.temp.gpCheck.guildRankIndex);
                    gaCore.temp.gpCheck.gChatListen, gaCore.temp.gpCheck.gChatSpeak, gaCore.temp.gpCheck.oChatListen, gaCore.temp.gpCheck.oChatSpeak, gaCore.temp.gpCheck.gPromote, gaCore.temp.gpCheck.gDemote, gaCore.temp.gpCheck.gInviteMember, gaCore.temp.gpCheck.gRemoveMember, gaCore.temp.gpCheck.gSetMOTD, gaCore.temp.gpCheck.pEditNote, gaCore.temp.gpCheck.oViewNote, gaCore.temp.gpCheck.oEditNote, gaCore.temp.gpCheck.gModInfo, gaCore.temp.gpCheck._, gaCore.temp.gpCheck.bWithdrawRepair, gaCore.temp.gpCheck.bWithdrawGold, gaCore.temp.gpCheck.gCreateEvent, gaCore.temp.gpCheck.rReqAuth, gaCore.temp.gpCheck.gModBankTabs, gaCore.temp.gpCheck.gRemoveEvent = GuildControlGetRankFlags();
                    if (gaCore.showDebug) then
                        gaCore.debugMessageFrame:AddMessage("MystDBG: " .. tostring(gaCore.temp.gpCheck.guildRankIndex) .. "  " .. tostring(gaCore.temp.gpCheck.gSetMOTD) .. "  " .. tostring(GuildControlGetRankFlags()));
                    end                    
                    if (gaCore.temp.gpCheck.gSetMOTD == 1 or gaCore.temp.gpCheck.guildRankIndex == 0) then
                        if (prefix == "GAnnoSnd") then
                            if (gAnnounceSettings["playSounds"] == 1) then
                                gaCore.displayAnnouncement(prefix, channel, text, sender);
                            end
                        else
                            gaCore.displayAnnouncement(prefix, channel, text, sender);
                        end
                    end
                elseif (channel == "RAID") then
                    gaCore.temp.rpCheck = {};
                    gaCore.temp.rpCheck.name, gaCore.temp.rpCheck.rank, gaCore.temp.rpCheck.subgroup, gaCore.temp.rpCheck.level, gaCore.temp.rpCheck.class, gaCore.temp.rpCheck.fileName, gaCore.temp.rpCheck.zone, gaCore.temp.rpCheck.online, gaCore.temp.rpCheck.isDead, gaCore.temp.rpCheck.role, gaCore.temp.rpCheck.isML = GetRaidRosterInfo(UnitInRaid(sender));
                    if (gaCore.temp.rpCheck.rank >= 1) then
                        if (prefix == "GAnnoSnd") then
                            if (gAnnounceSettings["playSounds"] == 1) then
                                gaCore.displayAnnouncement(prefix, channel, text, sender);
                            end
                        else
                            gaCore.displayAnnouncement(prefix, channel, text, sender);
                        end
                    end
                else
                    if (prefix == "GAnnoSnd") then
                        if (gAnnounceSettings["playSounds"] == 1) then
                            gaCore.displayAnnouncement(prefix, channel, text, sender);
                        end
                    else
                        gaCore.displayAnnouncement(prefix, channel, text, sender);
                    end
                end
            end
        end
    end
end


-------------------------------------------------------------------------------------
-- SetScript
-------------------------------------------------------------------------------------
gaCore.eventFrame:SetScript("OnEvent", gaCore.onEvent);




-------------------------------------------------------------------------------------
-- Slash Command Handler
-------------------------------------------------------------------------------------
function gaCore.slashCommand(args, origin)
    if (gaCore.chatFrame == nil or not gaCore.chatFrame) then
                                -- ^BUGFIX: attempt to call method 'AddMessage' (a nil value)
        gaCore.chatFrame = DEFAULT_CHAT_FRAME;
    end
    if (args == nil) then
        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Global Announce Help (v" .. gaCore.addonVersion .. ")|r");
        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Please send bug reports to: |cFF33CCFFmysticell@warcraft365.com|r|r");
        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Send Announcement: |cFFFFFFFF/ga send (guild||party||raid||bg||player) (ef||rw||pop||sct||sound) (message)|r|r");
        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Ping Players (Addon Check): |cFFFFFFFF/ga ping (guild||party||raid||bg||player)|r|r");
        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Settings: |cFFFFFFFF/ga settings (gmotd||enabled||eftime||playsounds||soundsverbose||broadcast||broadcastchannel) (on||off||value)|r|r");
        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Permissions: |cFFFFFFFF/ga permissions|r|r");
    else
        local command, remains = args:match("^(%S*)%s*(.-)$");
        local arg1, remains2 = remains:match("^(%S*)%s*(.-)$");
        local arg2, arg3 = remains2:match("^(%S*)%s*(.-)$");
        if (command == "send") then
            if (arg1 == "guild") then
                if (CanEditMOTD()) then
                    if (arg2 == "ef") then
                        SendAddonMessage("GAnnoEF", arg3, GUILD);
                    elseif (arg2 == "rw") then
                        SendAddonMessage("GAnnoRW", arg3, GUILD);
                    elseif (arg2 == "pop") then
                        SendAddonMessage("GAnnoPop", arg3, GUILD);
                    elseif (arg2 == "sct") then
                        SendAddonMessage("GAnnoSct", arg3, GUILD);
                    elseif (arg2 == "sound") then
                        SendAddonMessage("GAnnoSnd", arg3, GUILD);
                    else
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Error: Improper or missing announcement type |cFFFFFFFF(ef||rw||pop||sct||sound)|r|r");
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Syntax: |cFFFFFFFF/ga send (guild||party||raid||bg||player) (ef||rw||pop||sct||sound) (message)|r|r");
                    end
                else
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFFFF0000Error: You do not have permission to send announcements to guild.|r");
                end
            elseif (arg1 == "party") then
                if (arg2 == "ef") then
                    SendAddonMessage("GAnnoEF", arg3, PARTY);
                elseif (arg2 == "rw") then
                    SendAddonMessage("GAnnoRW", arg3, PARTY);
                elseif (arg2 == "pop") then
                    SendAddonMessage("GAnnoPop", arg3, PARTY);
                elseif (arg2 == "sct") then
                    SendAddonMessage("GAnnoSct", arg3, PARTY);
                elseif (arg2 == "sound") then
                    SendAddonMessage("GAnnoSnd", arg3, PARTY);
                else
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Error: Improper or missing announcement type |cFFFFFFFF(ef||rw||pop||sct||sound)|r|r");
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Syntax: |cFFFFFFFF/ga send (guild||party||raid||bg||player) (ef||rw||pop||sct||sound) (message)|r|r");
                end
            elseif (arg1 == "raid") then
                if (IsRaidOfficer()) then
                    if (arg2 == "ef") then
                        SendAddonMessage("GAnnoEF", arg3, RAID);
                    elseif (arg2 == "rw") then
                        SendAddonMessage("GAnnoRW", arg3, RAID);
                    elseif (arg2 == "pop") then
                        SendAddonMessage("GAnnoPop", arg3, RAID);
                    elseif (arg2 == "sct") then
                        SendAddonMessage("GAnnoSct", arg3, RAID);
                    elseif (arg2 == "sound") then
                        SendAddonMessage("GAnnoSnd", arg3, RAID);
                    else
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Error: Improper or missing announcement type |cFFFFFFFF(ef||rw||pop||sct||sound)|r|r");
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Syntax: |cFFFFFFFF/ga send (guild||party||raid||bg||player) (ef||rw||pop||sct||sound) (message)|r|r");
                    end
                else
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFFFF0000Error: You do not have permission to send announcements to raid.|r");
                end
            elseif (arg1 == "battleground") then
                if (arg2 == "ef") then
                    SendAddonMessage("GAnnoEF", arg3, INSTANCE_CHAT);
                elseif (arg2 == "rw") then
                    SendAddonMessage("GAnnoRW", arg3, INSTANCE_CHAT);
                elseif (arg2 == "pop") then
                    SendAddonMessage("GAnnoPop", arg3, INSTANCE_CHAT);
                elseif (arg2 == "sct") then
                    SendAddonMessage("GAnnoSct", arg3, INSTANCE_CHAT);
                elseif (arg2 == "sound") then
                    SendAddonMessage("GAnnoSnd", arg3, INSTANCE_CHAT);
                else
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Error: Improper or missing announcement type |cFFFFFFFF(ef||rw||pop||sct||sound)|r|r");
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Syntax: |cFFFFFFFF/ga send (guild||party||raid||bg||player) (ef||rw||pop||sct||sound) (message)|r|r");
                end
            else
                if (UnitLevel("player") > 1) then
                    SendWho(arg1);
                    WhoFrame:Hide();
                    if (GetNumWhoResults() > 0) then
                        if (arg2 == "ef") then
                            SendAddonMessage("GAnnoEF", arg3, WHISPER, arg1);
                        elseif (arg2 == "rw") then
                            SendAddonMessage("GAnnoRW", arg3, WHISPER, arg1);
                        elseif (arg2 == "pop") then
                            SendAddonMessage("GAnnoPop", arg3, WHISPER, arg1);
                        elseif (arg2 == "sct") then
                            SendAddonMessage("GAnnoSct", arg3, WHISPER, arg1);
                        elseif (arg2 == "sound") then
                            SendAddonMessage("GAnnoSnd", arg3, WHISPER, arg1);
                        else
                            gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Error: Improper or missing announcement type |cFFFFFFFF(ef||rw||pop||sct||sound)|r|r");
                            gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Syntax: |cFFFFFFFF/ga send (guild||party||raid||bg||player) (ef||rw||pop||sct||sound) (message)|r|r");
                        end
                    else
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFFFF0000Error: No player named |cFFFFFFFF" .. arg1 .. "|r is online.|r");
                    end    
                else
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFFFF0000Error: You do not have permission to send announcements via whisper.|r");
                end
            end
        elseif (command == "ping") then
            if (arg1 == "guild") then
                SendAddonMessage("GAnnoPing", UnitName("player"), GUILD);
            elseif (arg1 == "party") then
                SendAddonMessage("GAnnoPing", UnitName("player"), PARTY);
            elseif (arg1 == "raid") then
                SendAddonMessage("GAnnoPing", UnitName("player"), RAID);
            elseif (arg1 == "battleground") then
                SendAddonMessage("GAnnoPing", UnitName("player"), INSTANCE_CHAT);
            else
                SendWho(arg1);
                if (GetNumWhoResults() > 0) then
                    SendAddonMessage("GAnnoPing", UnitName("player"), WHISPER, arg1);
                end    
            end
        elseif (command == "settings") then
            if (arg1 == "gmotd") then
                if (arg2 == "on") then
                    gAnnounceSettings["displayGmotdPopup"] = 1;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Guild MOTD popup enabled.|r");
                elseif (arg2 == "off") then
                    gAnnounceSettings["displayGmotdPopup"] = 0;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Guild MOTD popup disabled.|r");
                else
                    if (gAnnounceSettings["displayGmotdPopup"] == 1) then
                        gAnnounceSettings["displayGmotdPopup"] = 0;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Guild MOTD popup disabled.|r");
                    else
                        gAnnounceSettings["displayGmotdPopup"] = 1;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Guild MOTD popup enabled.|r");
                    end    
                end
            elseif (arg1 == "enabled") then
                if (arg2 == "on") then
                    gAnnounceSettings["receiveAnnounces"] = 1;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Announcement display enabled.|r");
                elseif (arg2 == "off") then
                    gAnnounceSettings["receiveAnnounces"] = 0;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Announcement display disabled.  |cFFFFFFFFUse |cFFFF0000/ga enabled on|r to re-enable.|r|r");
                else
                    if (gAnnounceSettings["receiveAnnounces"] == 1) then
                        gAnnounceSettings["receiveAnnounces"] = 0;
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Announcement display disabled.  |cFFFFFFFFUse |cFFFF0000/ga enabled on|r to re-enable.|r|r");
                    else
                        gAnnounceSettings["receiveAnnounces"] = 1;
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Announcement display enabled.|r");
                    end    
                end
            elseif (arg1 == "eftime") then
                if (arg2 == nil) then
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Current error frame announcement display time is |cFFFFFFFF" .. gAnnounceSettings["efDisplayTime"] .. " |4second:seconds;|r.|r");
                elseif (arg2 < 1) then
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFFFF0000Error frame announcement display time must be at least 1 second.|r");
                elseif (math.floor(arg2)) then
                    gAnnounceSettings["efDisplayTime"] = arg2;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Error frame announcement display time set to |cFFFFFFFF" .. gAnnounceSettings["efDisplayTime"] .. "|4second:seconds;|r.|r");
                else
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFFFF0000Error frame announcement display time must be set to a number greater than 1.|r");
                end
            elseif (arg1 == "playsounds") then
                if (arg2 == "on") then
                    gAnnounceSettings["playSounds"] = 1;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Sound alerts enabled.|r");
                elseif (arg2 == "off") then
                    gAnnounceSettings["playSounds"] = 0;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Sound alerts disabled.  |cFFFFFFFFUse |cFFFF0000/ga playsounds on|r to re-enable.|r|r");
                else
                    if (gAnnounceSettings["playSounds"] == 1) then
                        gAnnounceSettings["playSounds"] = 0;
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Sound alerts disabled.  |cFFFFFFFFUse |cFFFF0000/ga playsounds on|r to re-enable.|r|r");
                    else
                        gAnnounceSettings["playSounds"] = 1;
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Sound alerts enabled.|r");
                    end
                end
            elseif (arg1 == "soundsverbose") then
                if (arg2 == "on") then
                    gAnnounceSettings["soundsVerbose"] = 1;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Verbose output of sound alerts enabled.|r");
                elseif (arg2 == "off") then
                    gAnnounceSettings["soundsVerbose"] = 0;
                    gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Verbose output of sound alerts disabled.  |cFFFFFFFFUse |cFFFF0000/ga soundsverbose on|r to re-enable.|r|r");
                else
                    if (gAnnounceSettings["soundsVerbose"] == 1) then
                        gAnnounceSettings["soundsVerbose"] = 0;
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Verbose output of sound alerts disabled.  |cFFFFFFFFUse |cFFFF0000/ga soundsverbose on|r to re-enable.|r|r");
                    else
                        gAnnounceSettings["soundsVerbose"] = 1;
                        gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Verbose output of sound alerts enabled.|r");
                    end
                end
            else
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Error: Improper or missing setting |cFFFFFFFF(gmotd||enabled||eftime||playsounds||soundsverbose||broadcast||broadcastchannel)|r|r");
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Syntax: |cFFFFFFFF/ga settings (gmotd||enabled||eftime||playsounds||soundsverbose||broadcast||broadcastchannel) (on||off||value)|r|r");
            end
        elseif (command == "permissions") then
            -- [[ FLAGGED FOR FUTURE VERSION: Check permissions when receiving messages. ]]
            -- Check Guild Permissions
            local allowedGuild = CanEditMOTD();
            if (allowedGuild == 1) then
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "You can send announcements to guild.", 0, 1, 0);
            elseif (allowedGuild == 0) then
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "You must have the ability to edit the guild message of the day to be able to send announcements to guild.", 1, 0, 0);
            else
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "Error while checking guild permissions.  (Not in a guild.)", 1, 0, 0);
            end
            -- Check Raid Permissions
            local allowedRaid = IsRaidOfficer();
            if (allowedRaid == 1) then
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "You can send announcements to raid.", 0, 1, 0);
            elseif (allowedRaid == 0) then
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "You must be promoted to a raid assistant to be able to send announcements to raid.", 1, 0, 0);
            else
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "Error while checking raid permissions.  (Not in a raid group.)", 1, 0, 0);
            end
            -- Check Whisper Permissions
            local allowedWhisper = UnitLevel("player");
            if (allowedWhisper > 1) then
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "You can send announcements via whisper.", 0, 1, 0);
            elseif (allowedWhisper == 1) then
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "You must be at least level 2 before you can send announcements via whisper.", 1, 0, 0);
            else
                gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "Error while checking whisper permissions.", 1, 0, 0);
            end
        else
            gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Global Announce Help (v" .. gaCore.addonVersion .. ")|r");
            gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Please send bug reports to: |cFF33CCFFmysticell@warcraft365.com|r|r");
            gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Send Announcement: |cFFFFFFFF/ga send (guild||party||raid||bg||player) (ef||rw||pop||sct||sound) (message)|r|r");
            gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Ping Players (Addon Check): |cFFFFFFFF/ga ping (guild||party||raid||bg||player)|r|r");
            gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Settings: |cFFFFFFFF/ga settings (gmotd||enabled||eftime||playsounds||soundsverbose||broadcast||broadcastchannel) (on||off||value)|r|r");
            gaCore.chatFrame:AddMessage(gaCore.messagePrefix .. "|cFF00FF00Permissions: |cFFFFFFFF/ga permissions|r|r");
        end
    end
end

SlashCmdList["GANNOUNCE"] = gaCore.slashCommand;
SLASH_GANNOUNCE1 = "/ga";
SLASH_GANNOUNCE2 = "/gannounce";
SLASH_GANNOUNCE3 = "/globalannounce";