-- ********************************************************
-- **              Mizus RaidTracker - GUI               **
-- **           <http://nanaki.affenfelsen.de>           **
-- ********************************************************
--
-- This addon is written and copyrighted by:
--    * Mizukichan @ EU-Thrall (2010)
--
-- The localizations are written by:
--    * enGB/enUS: Mizukichan
--    * deDE: Mizukichan
--
--
--    This file is part of Mizus RaidTracker.
--
--    Mizus RaidTracker is free software: you can redistribute it and/or 
--    modify it under the terms of the GNU General Public License as 
--    published by the Free Software Foundation, either version 3 of the 
--    License, or (at your option) any later version.
--
--    Mizus RaidTracker is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with Mizus RaidTracker.  
--    If not, see <http://www.gnu.org/licenses/>.


--------------
--  Locals  --
--------------
local ScrollingTable = LibStub("ScrollingTable");

local MRT_GUI_RaidLogTableSelection = nil;
local MRT_GUI_RaidBosskillsTableSelection = nil;

local msgbox;

-- table definitions
local MRT_RaidLogTableColDef = { 
    {["name"] = MRT_L.GUI["Col_Num"], ["width"] = 25, ["defaultsort"] = "dsc"}, 
    {["name"] = MRT_L.GUI["Col_Date"], ["width"] = 75}, 
    {["name"] = MRT_L.GUI["Col_Zone"], ["width"] = 100},
    {["name"] = MRT_L.GUI["Col_Size"], ["width"] = 25},
};
local MRT_RaidAttendeesTableColDef = {
    {["name"] = "", ["width"] = 1},                           -- invisible coloumn for storing the player number index from the raidlog-table
    {["name"] = MRT_L.GUI["Col_Name"], ["width"] = 84},
    {["name"] = MRT_L.GUI["Col_Join"], ["width"] = 40},
    {["name"] = MRT_L.GUI["Col_Leave"], ["width"] = 40},
};
local MRT_RaidBosskillsTableColDef = {
    {["name"] = MRT_L.GUI["Col_Num"], ["width"] = 25, ["defaultsort"] = "dsc"},
    {["name"] = MRT_L.GUI["Col_Time"], ["width"] = 40},
    {["name"] = MRT_L.GUI["Col_Name"], ["width"] = 110},
    {["name"] = MRT_L.GUI["Col_Difficulty"], ["width"] = 40},
};
local MRT_BossLootTableColDef = {
    {["name"] = "", ["width"] = 1},                            -- invisible coloumn for storing the loot number index from the raidlog-table
    {["name"] = MRT_L.GUI["Col_Name"], ["width"] = 179},
    {["name"] = MRT_L.GUI["Col_Looter"], ["width"] = 85},
    {["name"] = MRT_L.GUI["Col_Cost"], ["width"] = 30},
};
local MRT_BossAttendeesTableColDef = {
    {["name"] = MRT_L.GUI["Col_Name"], ["width"] = 85}
};


---------------------------------------------------------------
--  parse localization and set up tables after ADDON_LOADED  --
---------------------------------------------------------------
function MRT_GUI_ParseValues()
    -- Parse title strings
    MRT_GUIFrame_Title:SetText(MRT_L.GUI["Header_Title"]);
    MRT_GUIFrame_RaidLogTitle:SetText(MRT_L.GUI["Tables_RaidLogTitle"]);
    MRT_GUIFrame_RaidAttendeesTitle:SetText(MRT_L.GUI["Tables_RaidAttendeesTitle"]);
    MRT_GUIFrame_RaidBosskillsTitle:SetText(MRT_L.GUI["Tables_RaidBosskillsTitle"]);
    MRT_GUIFrame_BossLootTitle:SetText(MRT_L.GUI["Tables_BossLootTitle"]);
    MRT_GUIFrame_BossAttendeesTitle:SetText(MRT_L.GUI["Tables_BossAttendeesTitle"]);
    -- Create and anchor tables
    MRT_GUI_RaidLogTable = ScrollingTable:CreateST(MRT_RaidLogTableColDef, 12, nil, nil, MRT_GUIFrame);
    MRT_GUI_RaidLogTable.frame:SetPoint("TOPLEFT", MRT_GUIFrame_RaidLogTitle, "BOTTOMLEFT", 0, -15);
    MRT_GUI_RaidLogTable:EnableSelection(true);
    MRT_GUI_RaidAttendeesTable = ScrollingTable:CreateST(MRT_RaidAttendeesTableColDef, 12, nil, nil, MRT_GUIFrame);
    MRT_GUI_RaidAttendeesTable.frame:SetPoint("TOPLEFT", MRT_GUIFrame_RaidAttendeesTitle, "BOTTOMLEFT", 0, -15);
    MRT_GUI_RaidAttendeesTable:EnableSelection(true);
    MRT_GUI_RaidBosskillsTable = ScrollingTable:CreateST(MRT_RaidBosskillsTableColDef, 12, nil, nil, MRT_GUIFrame);
    MRT_GUI_RaidBosskillsTable.frame:SetPoint("TOPLEFT", MRT_GUIFrame_RaidBosskillsTitle, "BOTTOMLEFT", 0, -15);
    MRT_GUI_RaidBosskillsTable:EnableSelection(true);
    MRT_GUI_BossLootTable = ScrollingTable:CreateST(MRT_BossLootTableColDef, 12, nil, nil, MRT_GUIFrame);
    MRT_GUI_BossLootTable.frame:SetPoint("TOPLEFT", MRT_GUIFrame_BossLootTitle, "BOTTOMLEFT", 0, -15);
    MRT_GUI_BossLootTable:EnableSelection(true);
    MRT_GUI_BossAttendeesTable = ScrollingTable:CreateST(MRT_BossAttendeesTableColDef, 12, nil, nil, MRT_GUIFrame);
    MRT_GUI_BossAttendeesTable.frame:SetPoint("TOPLEFT", MRT_GUIFrame_BossAttendeesTitle, "BOTTOMLEFT", 0, -15);
    MRT_GUI_BossAttendeesTable:EnableSelection(true);
    -- parse button local / anchor buttons relative to tables
    MRT_GUIFrame_RaidLog_Export_Button:SetText(MRT_L.GUI["Button_Export"]);
    MRT_GUIFrame_RaidLog_Export_Button:SetPoint("TOPLEFT", MRT_GUI_RaidLogTable.frame, "BOTTOMLEFT", 0, -5);
    MRT_GUIFrame_RaidLog_Delete_Button:SetText(MRT_L.GUI["Button_Delete"]);
    MRT_GUIFrame_RaidLog_Delete_Button:SetPoint("LEFT", MRT_GUIFrame_RaidLog_Export_Button, "RIGHT", 10, 0);
    MRT_GUIFrame_RaidLog_ExportNormal_Button:SetText(MRT_L.GUI["Button_ExportNormal"]);
    MRT_GUIFrame_RaidLog_ExportNormal_Button:SetPoint("TOP", MRT_GUIFrame_RaidLog_Export_Button, "BOTTOM", 0, -5);
    MRT_GUIFrame_RaidLog_ExportHeroic_Button:SetText(MRT_L.GUI["Button_ExportHeroic"]);
    MRT_GUIFrame_RaidLog_ExportHeroic_Button:SetPoint("LEFT", MRT_GUIFrame_RaidLog_ExportNormal_Button, "RIGHT", 10, 0);
    MRT_GUIFrame_RaidBosskills_Add_Button:SetText(MRT_L.GUI["Button_Add"]);
    MRT_GUIFrame_RaidBosskills_Add_Button:SetPoint("TOPLEFT", MRT_GUI_RaidBosskillsTable.frame, "BOTTOMLEFT", 0, -5);
    MRT_GUIFrame_RaidBosskills_Delete_Button:SetText(MRT_L.GUI["Button_Delete"]);
    MRT_GUIFrame_RaidBosskills_Delete_Button:SetPoint("LEFT", MRT_GUIFrame_RaidBosskills_Add_Button, "RIGHT", 10, 0);
    MRT_GUIFrame_RaidBosskills_Export_Button:SetText(MRT_L.GUI["Button_Export"]);
    MRT_GUIFrame_RaidBosskills_Export_Button:SetPoint("TOP", MRT_GUIFrame_RaidBosskills_Add_Button, "BOTTOM", 0, -5);
    MRT_GUIFrame_RaidAttendees_Add_Button:SetText(MRT_L.GUI["Button_Add"]);
    MRT_GUIFrame_RaidAttendees_Add_Button:SetPoint("TOPLEFT", MRT_GUI_RaidAttendeesTable.frame, "BOTTOMLEFT", 0, -5);
    MRT_GUIFrame_RaidAttendees_Delete_Button:SetText(MRT_L.GUI["Button_Delete"]);
    MRT_GUIFrame_RaidAttendees_Delete_Button:SetPoint("LEFT", MRT_GUIFrame_RaidAttendees_Add_Button, "RIGHT", 10, 0);
    MRT_GUIFrame_BossLoot_Add_Button:SetText(MRT_L.GUI["Button_Add"]);
    MRT_GUIFrame_BossLoot_Add_Button:SetPoint("TOPLEFT", MRT_GUI_BossLootTable.frame, "BOTTOMLEFT", 0, -5);
    MRT_GUIFrame_BossLoot_Modify_Button:SetText(MRT_L.GUI["Button_Modify"]);
    MRT_GUIFrame_BossLoot_Modify_Button:SetPoint("LEFT", MRT_GUIFrame_BossLoot_Add_Button, "RIGHT", 10, 0);
    MRT_GUIFrame_BossLoot_Delete_Button:SetText(MRT_L.GUI["Button_Delete"]);
    MRT_GUIFrame_BossLoot_Delete_Button:SetPoint("LEFT", MRT_GUIFrame_BossLoot_Modify_Button, "RIGHT", 10, 0);
    MRT_GUIFrame_BossAttendees_Add_Button:SetText(MRT_L.GUI["Button_Add"]);
    MRT_GUIFrame_BossAttendees_Add_Button:SetPoint("TOPLEFT", MRT_GUI_BossAttendeesTable.frame, "BOTTOMLEFT", 0, -5);
    MRT_GUIFrame_BossAttendees_Delete_Button:SetText(MRT_L.GUI["Button_Delete"]);
    MRT_GUIFrame_BossAttendees_Delete_Button:SetPoint("TOP", MRT_GUIFrame_BossAttendees_Add_Button, "BOTTOM", 0, -5);
    -- disable buttons, if function is NYI
    MRT_GUIFrame_RaidBosskills_Add_Button:Disable();
    MRT_GUIFrame_RaidAttendees_Add_Button:Disable();
    MRT_GUIFrame_BossLoot_Add_Button:Disable();
    MRT_GUIFrame_BossLoot_Delete_Button:Disable();
    MRT_GUIFrame_BossAttendees_Add_Button:Disable();
    MRT_GUIFrame_BossAttendees_Delete_Button:Disable();
    -- Insert table data
    MRT_GUI_CompleteTableUpdate();
end


---------------------
--  Show/Hide GUI  --
---------------------
function MRT_GUI_Toggle()
    if (not MRT_GUIFrame:IsShown()) then
        MRT_GUIFrame:Show();
        MRT_GUIFrame:SetScript("OnUpdate", function() MRT_GUI_OnUpdateHandler(); end);
        MRT_GUI_CompleteTableUpdate();
    else
        MRT_GUIFrame:Hide();
        MRT_GUIFrame:SetScript("OnUpdate", nil);
    end
end


----------------------
--  Button handler  --
----------------------
function MRT_GUI_RaidExportComplete()
    MRT_GUI_HideDialogs();
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then 
        MRT_Print(MRT_L.GUI["No raid selected"]);
        return;
    end
    local raidnum = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    MRT_CreateRaidExport(raidnum, nil, nil);
end

function MRT_GUI_RaidExportNormal()
    MRT_GUI_HideDialogs();
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then 
        MRT_Print(MRT_L.GUI["No raid selected"]);
        return;
    end
    local raidnum = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    MRT_CreateRaidExport(raidnum, nil, "N");
end

function MRT_GUI_RaidExportHard()
    MRT_GUI_HideDialogs();
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then 
        MRT_Print(MRT_L.GUI["No raid selected"]);
        return;
    end
    local raidnum = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    MRT_CreateRaidExport(raidnum, nil, "H");
end

function MRT_GUI_RaidDelete()
    MRT_GUI_HideDialogs();
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then
        MRT_Print(MRT_L.GUI["No raid selected"]);
        return;
    end
    if (raid_select == MRT_NumOfCurrentRaid) then
        MRT_Print(MRT_L.GUI["Can not delete current raid"]);
        return;
    end
    local raidnum = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    StaticPopupDialogs.MRT_GUI_ZeroRowDialog.text = string.format(MRT_L.GUI["Confirm raid entry deletion"], raidnum);
    StaticPopupDialogs.MRT_GUI_ZeroRowDialog.OnAccept = function() MRT_GUI_RaidDeleteAccept(raidnum); end
    StaticPopup_Show("MRT_GUI_ZeroRowDialog");
end

function MRT_GUI_RaidDeleteAccept(raidnum)
    table.remove(MRT_RaidLog, raidnum);
    -- Modify MRT_NumOfCurrentRaid if there is an active raid
    if (MRT_NumOfCurrentRaid ~= nil) then
        MRT_NumOfCurrentRaid = #MRT_RaidLog;
    end
    -- Do a table update
    MRT_GUI_CompleteTableUpdate();
end

function MRT_GUI_BossDelete()
    MRT_GUI_HideDialogs();
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then
        MRT_Print(MRT_L.GUI["No raid selected"]);
        return;
    end
    local boss_select = MRT_GUI_RaidBosskillsTable:GetSelection();
    if (boss_select == nil) then
        MRT_Print(MRT_L.GUI["No boss selected"]);
        return;
    end
    local raidnum = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    local bossnum = MRT_GUI_RaidBosskillsTable:GetCell(boss_select, 1);
    local bossname = MRT_GUI_RaidBosskillsTable:GetCell(boss_select, 3);
    StaticPopupDialogs.MRT_GUI_ZeroRowDialog.text = string.format(MRT_L.GUI["Confirm boss entry deletion"], bossnum, bossname);
    StaticPopupDialogs.MRT_GUI_ZeroRowDialog.OnAccept = function() MRT_GUI_BossDeleteAccept(raidnum, bossnum); end
    StaticPopup_Show("MRT_GUI_ZeroRowDialog");
end

function MRT_GUI_BossDeleteAccept(raidnum, bossnum)
    table.remove(MRT_RaidLog[raidnum]["Bosskills"], bossnum);
    -- Modify MRT_NumOfLastBoss if active raid was modified
    if (MRT_NumOfCurrentRaid == raidnum) then
        MRT_NumOfLastBoss = #MRT_RaidLog[raidnum]["Bosskills"];
    end
    -- Do a table update, if the displayed raid was modified
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then return; end
    local raidnum_selected = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    if (raidnum_selected == raidnum) then
        MRT_GUI_RaidDetailsTableUpdate(raidnum);
    end
end

function MRT_GUI_BossExport()
    MRT_GUI_HideDialogs();
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then
        MRT_Print(MRT_L.GUI["No raid selected"]);
        return;
    end
    local boss_select = MRT_GUI_RaidBosskillsTable:GetSelection();
    if (boss_select == nil) then
        MRT_Print(MRT_L.GUI["No boss selected"]);
        return;
    end
    local raidnum = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    local bossnum = MRT_GUI_RaidBosskillsTable:GetCell(boss_select, 1);
    MRT_CreateRaidExport(raidnum, bossnum, nil);
end

function MRT_GUI_RaidAttendeeDelete()
    MRT_GUI_HideDialogs();
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then
        MRT_Print(MRT_L.GUI["No raid selected"]);
        return;
    end
    local attendee_select = MRT_GUI_RaidAttendeesTable:GetSelection();
    if (attendee_select == nil) then
        MRT_Print(MRT_L.GUI["No raid attendee selected"]);
        return;
    end
    local raidnum = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    local attendee = MRT_GUI_RaidAttendeesTable:GetCell(attendee_select, 1);
    StaticPopupDialogs.MRT_GUI_ZeroRowDialog.text = string.format(MRT_L.GUI["Confirm raid attendee entry deletion"], attendee);
    StaticPopupDialogs.MRT_GUI_ZeroRowDialog.OnAccept = function() MRT_GUI_RaidAttendeeDeleteAccept(raidnum, attendee); end
    StaticPopup_Show("MRT_GUI_ZeroRowDialog");
end

function MRT_GUI_RaidAttendeeDeleteAccept(raidnum, attendee)
    MRT_RaidLog[raidnum]["Players"][attendee] = nil;
    -- Do a table update, if the displayed raid was modified
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then return; end
    local raidnum_selected = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    if (raidnum_selected == raidnum) then
        MRT_GUI_RaidAttendeesTableUpdate(raidnum);
    end
end

function MRT_GUI_LootModify()
    MRT_GUI_HideDialogs();
    local raid_select = MRT_GUI_RaidLogTable:GetSelection();
    if (raid_select == nil) then
        MRT_Print(MRT_L.GUI["No raid selected"]);
        return;
    end
    local boss_select = MRT_GUI_RaidBosskillsTable:GetSelection();
    if (boss_select == nil) then
        MRT_Print(MRT_L.GUI["No boss selected"]);
        return;
    end
    local loot_select = MRT_GUI_BossLootTable:GetSelection();
    if (loot_select == nil) then
        MRT_Print(MRT_L.GUI["No loot selected"]);
        return;
    end
    local raidnum = MRT_GUI_RaidLogTable:GetCell(raid_select, 1);
    local bossnum = MRT_GUI_RaidBosskillsTable:GetCell(boss_select, 1);
    local lootnum = MRT_GUI_BossLootTable:GetCell(loot_select, 1);
    MRT_GUI_ThreeRowDialog_Title:SetText(MRT_L.GUI["Modify loot data"]);
    MRT_GUI_ThreeRowDialog_EB1_Text:SetText(MRT_L.GUI["Itemlink"]);
    MRT_GUI_ThreeRowDialog_EB1:SetText(MRT_RaidLog[raidnum]["Loot"][lootnum]["ItemLink"]);
    MRT_GUI_ThreeRowDialog_EB2_Text:SetText(MRT_L.GUI["Looter"]);
    MRT_GUI_ThreeRowDialog_EB2:SetText(MRT_GUI_BossLootTable:GetCell(loot_select, 3));
    MRT_GUI_ThreeRowDialog_EB3_Text:SetText(MRT_L.GUI["Value"]);
    MRT_GUI_ThreeRowDialog_EB3:SetText(MRT_GUI_BossLootTable:GetCell(loot_select, 4));
    MRT_GUI_ThreeRowDialog_OKButton:SetText(MRT_L.GUI["Button_Modify"]);
    MRT_GUI_ThreeRowDialog_OKButton:SetScript("OnClick", function() MRT_GUI_LootModifyAccept(raidnum, bossnum, lootnum); end);
    MRT_GUI_ThreeRowDialog_CancelButton:SetText(MRT_L.Core["MB_Cancel"]);
    MRT_GUI_ThreeRowDialog:Show();
end

function MRT_GUI_LootModifyAccept(raidnum, bossnum, lootnum)
    local itemLink = MRT_GUI_ThreeRowDialog_EB1:GetText();
    local looter = MRT_GUI_ThreeRowDialog_EB2:GetText();
    local cost = MRT_GUI_ThreeRowDialog_EB3:GetText();
    if (cost == "") then cost = 0; end
    cost = tonumber(cost);
    -- sanity-check values here - especially the itemlink / looter is free text / cost has to be a number
    -- example itemLink: |cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0|h[Broken Fang]|h|r
    -- strip the itemlink into its parts / may change to use deformat with easier pattern ("|c%s|H%s|h[%s]|h|r")
    local _, _, itemString = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]");
    local _, _, itemColor, _, itemId, _, _, _, _, _, _, _, _, itemName = string.find(itemLink, "|?c?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?");
    if (not itemString or not itemColor or not itemId or not itemName) then
        MRT_Print(MRT_L.GUI["No itemLink found"]);
        return;
    end
    if (not cost) then
        MRT_Print(MRT_L.GUI["Item cost invalid"]);
        return;
    end
    itemId = tonumber(itemId);
    MRT_GUI_HideDialogs();
    -- insert new values here / if (lootnum == nil) then treat as a newly added item
    local MRT_LootInfo = {
        ["ItemLink"] = itemLink,
        ["ItemString"] = itemString,
        ["ItemId"] = itemId,
        ["ItemName"] = itemName,
        ["ItemColor"] = itemColor,
        ["BossNumber"] = bossnum,
        ["Looter"] = looter,
        ["DKPValue"] = cost,
    }
    if (lootnum) then
        oldLootDB = MRT_RaidLog[raidnum]["Loot"][lootnum];
        MRT_LootInfo["ItemCount"] = oldLootDB["ItemCount"];
        MRT_LootInfo["Time"] = oldLootDB["Time"];
        MRT_RaidLog[raidnum]["Loot"][lootnum] = MRT_LootInfo;
    else
        MRT_LootInfo["ItemCount"] = 1;
        MRT_LootInfo["Time"] = time();
        tinsert(MRT_RaidLog[raidnum]["Loot"], MRT_LootInfo);
    end
end


------------------------
--  OnUpdate handler  --
------------------------
-- Is there a better way to handle OnClick-Events from each table without overwriting the sort functions?
function MRT_GUI_OnUpdateHandler()
    local raidnum = MRT_GUI_RaidLogTable:GetSelection();
    local bossnum = MRT_GUI_RaidBosskillsTable:GetSelection();
    if (raidnum ~= MRT_GUI_RaidLogTableSelection) then
        MRT_GUI_RaidLogTableSelection = raidnum;
        if (raidnum) then
            MRT_GUI_RaidDetailsTableUpdate(MRT_GUI_RaidLogTable:GetCell(raidnum, 1));
        else
            MRT_GUI_RaidDetailsTableUpdate(nil);
        end
    end
    if (bossnum ~= MRT_GUI_RaidBosskillsTableSelection) then
        MRT_GUI_RaidBosskillsTableSelection = bossnum;
        if (bossnum) then
            MRT_GUI_BossDetailsTableUpdate(MRT_GUI_RaidBosskillsTable:GetCell(bossnum, 1))
        else
            MRT_GUI_BossDetailsTableUpdate(nil);
        end
    end
end


------------------------------
--  table update functions  --
------------------------------
-- update all tables
function MRT_GUI_CompleteTableUpdate()
    MRT_GUI_RaidLogTableUpdate();
    MRT_GUI_RaidDetailsTableUpdate(nil);
    MRT_GUI_BossDetailsTableUpdate(nil);
end

-- update raid details tables
function MRT_GUI_RaidDetailsTableUpdate(raidnum)
    MRT_GUI_RaidAttendeesTableUpdate(raidnum);
    MRT_GUI_RaidBosskillsTableUpdate(raidnum);
    MRT_GUI_BossDetailsTableUpdate(nil);
end

-- update boss details tables
function MRT_GUI_BossDetailsTableUpdate(bossnum)
    MRT_GUI_BossLootTableUpdate(bossnum);
    MRT_GUI_BossAttendeesTableUpdate(bossnum);
end

-- update raid list table
function MRT_GUI_RaidLogTableUpdate()
    local MRT_GUI_RaidLogTableData = {};
    local MRT_RaidLogSize = #MRT_RaidLog;
    -- insert reverse order
    for i, v in ipairs(MRT_RaidLog) do
        --MRT_GUI_RaidLogTableData[i] = {i, date("%m/%d %H:%M", v["StartTime"]), v["RaidZone"], v["RaidSize"]};
        MRT_GUI_RaidLogTableData[(MRT_RaidLogSize-i+1)] = {i, date("%m/%d %H:%M", v["StartTime"]), v["RaidZone"], v["RaidSize"]};
    end
    MRT_GUI_RaidLogTable:ClearSelection();
    MRT_GUI_RaidLogTable:SetData(MRT_GUI_RaidLogTableData, true);
end

-- update raid attendees table
function MRT_GUI_RaidAttendeesTableUpdate(raidnum)
    local MRT_GUI_RaidAttendeesTableData = {};
    if (raidnum) then
        local index = 1;
        for k, v in pairs(MRT_RaidLog[raidnum]["Players"]) do
            if (v["Leave"]) then
                MRT_GUI_RaidAttendeesTableData[index] = {k, v["Name"], date("%H:%M", v["Join"]), date("%H:%M", v["Leave"])};
            else
                MRT_GUI_RaidAttendeesTableData[index] = {k, v["Name"], date("%H:%M", v["Join"]), nil};
            end
            index = index + 1;
        end
    end
    table.sort(MRT_GUI_RaidAttendeesTableData, function(a, b) return (a[2] < b[2]); end);
    MRT_GUI_RaidAttendeesTable:SetData(MRT_GUI_RaidAttendeesTableData, true);
end

-- update bosskill table
function MRT_GUI_RaidBosskillsTableUpdate(raidnum)
    local MRT_GUI_RaidBosskillsTableData = {};
    local MRT_BosskillsCount = nil;
    if (raidnum) then MRT_BosskillsCount = #MRT_RaidLog[raidnum]["Bosskills"]; end;
    if (raidnum and MRT_BosskillsCount) then
        for i, v in ipairs(MRT_RaidLog[raidnum]["Bosskills"]) do
            if (v["Difficulty"] > 2) then
                --MRT_GUI_RaidBosskillsTableData[i] = {i, date("%H:%M", v["Date"]), v["Name"], MRT_L.GUI["Cell_Hard"]};
                MRT_GUI_RaidBosskillsTableData[(MRT_BosskillsCount-i+1)] = {i, date("%H:%M", v["Date"]), v["Name"], MRT_L.GUI["Cell_Hard"]};
            else
                --MRT_GUI_RaidBosskillsTableData[i] = {i, date("%H:%M", v["Date"]), v["Name"], MRT_L.GUI["Cell_Normal"]};
                MRT_GUI_RaidBosskillsTableData[(MRT_BosskillsCount-i+1)] = {i, date("%H:%M", v["Date"]), v["Name"], MRT_L.GUI["Cell_Normal"]};
            end
        end
    end
    MRT_GUI_RaidBosskillsTable:ClearSelection();
    MRT_GUI_RaidBosskillsTable:SetData(MRT_GUI_RaidBosskillsTableData, true);
end

-- update bossloot table
function MRT_GUI_BossLootTableUpdate(bossnum)
    local MRT_GUI_BossLootTableData = {};
    if (bossnum) then
        local index = 1
        local raidnum = MRT_GUI_RaidLogTable:GetCell(MRT_GUI_RaidLogTableSelection, 1);
        for i, v in ipairs(MRT_RaidLog[raidnum]["Loot"]) do
            if (v["BossNumber"] == bossnum) then
                --MRT_GUI_BossLootTableData[index] = {i, v["ItemLink"], v["Looter"], v["DKPValue"]};
                MRT_GUI_BossLootTableData[index] = {i, "|c"..v["ItemColor"]..v["ItemName"].."|r", v["Looter"], v["DKPValue"]};
                --MRT_GUI_BossLootTableData[index] = {i, v["ItemLink"], "|c"..v["ItemColor"]..v["ItemName"].."|r", v["Looter"], v["DKPValue"]};
                index = index + 1;
            end
        end
    end
    table.sort(MRT_GUI_BossLootTableData, function(a, b) return (a[2] < b[2]); end);
    MRT_GUI_BossLootTable:SetData(MRT_GUI_BossLootTableData, true);
end

-- update bossattendee table
function MRT_GUI_BossAttendeesTableUpdate(bossnum)
    local MRT_GUI_BossAttendeesTableData = {};
    if (bossnum) then
        local raidnum = MRT_GUI_RaidLogTable:GetCell(MRT_GUI_RaidLogTableSelection, 1);
        for i, v in ipairs(MRT_RaidLog[raidnum]["Bosskills"][bossnum]["Players"]) do
            MRT_GUI_BossAttendeesTableData[i] = {v};
        end
    end
    table.sort(MRT_GUI_BossAttendeesTableData, function(a, b) return (a[1] < b[1]); end);
    MRT_GUI_BossAttendeesTable:SetData(MRT_GUI_BossAttendeesTableData, true);
end


--------------------------------------
--  functions for the dialog boxes  --
--------------------------------------
function MRT_GUI_HideDialogs()
    StaticPopup_Hide("MRT_GUI_ZeroRowDialog");
    MRT_GUI_OneRowDialog:Hide();
    MRT_GUI_TwoRowDialog:Hide();
    MRT_GUI_ThreeRowDialog:Hide();
    MRT_ExportFrame_Hide();
end

-- enable shift-click-parsing of item links
function MRT_GUI_Hook_ChatEdit_InsertLink(link)
    if MRT_GUI_OneRowDialog:IsVisible() then
        if MRT_GUI_OneRowDialog_EB1:HasFocus() then 
            MRT_GUI_OneRowDialog_EB1:SetText(link); 
        end
    end
    if MRT_GUI_TwoRowDialog:IsVisible() then
        if MRT_GUI_TwoRowDialog_EB1:HasFocus() then 
            MRT_GUI_TwoRowDialog_EB1:SetText(link);
        elseif MRT_GUI_TwoRowDialog_EB2:HasFocus() then 
            MRT_GUI_TwoRowDialog_EB2:SetText(link);
        end
    end
    if MRT_GUI_ThreeRowDialog:IsVisible() then
        if MRT_GUI_ThreeRowDialog_EB1:HasFocus() then 
            MRT_GUI_ThreeRowDialog_EB1:SetText(link); 
        elseif MRT_GUI_ThreeRowDialog_EB2:HasFocus() then 
            MRT_GUI_ThreeRowDialog_EB2:SetText(link);
        elseif MRT_GUI_ThreeRowDialog_EB3:HasFocus() then 
            MRT_GUI_ThreeRowDialog_EB3:SetText(link);
        end
    end
end
hooksecurefunc("ChatEdit_InsertLink", MRT_GUI_Hook_ChatEdit_InsertLink);


-------------------------------------
--  ZeroRowDialog as static popup  --
-------------------------------------
-- To show/hide this dialog: StaticPopup_Show("Popup name") / StaticPopup_Hide("Popup name")
StaticPopupDialogs["MRT_GUI_ZeroRowDialog"] = {
    text = "FIXME!",
    button1 = MRT_L.Core["MB_Yes"],
    button2 = MRT_L.Core["MB_No"],
    OnAccept = nil,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

