-- WIP
function widget:GetInfo()
	return {
		name    = 'Gravity weapon state',
		desc    = 'Displays gravity weapon state',
		author  = 'gajop, Bluestone, Funkencool',
		date    = 'April, 2015',
		license = 'GNU GPL v2',
        layer = 0,
		enabled = true,
	}
end

local Chili, window

local spGetMyTeamID      = Spring.GetMyTeamID
local myTeamID = spGetMyTeamID()

local onOffState
local onOffStateBtn
local attackCmd

local playerUnitID = nil

local pullCol = {0.3, 0.5, 1}
local pushCol = {1, 0.5, 1}

function ColStr(t)
		R255 = math.floor(t[1]*255)  --the first \255 is just a tag (not colour setting) no part can end with a zero due to engine limitation (C)
        G255 = math.floor(t[2]*255)
        B255 = math.floor(t[3]*255)
        if ( R255%10 == 0) then
                R255 = R255+1
        end
        if( G255%10 == 0) then
                G255 = G255+1
        end
        if ( B255%10 == 0) then
                B255 = B255+1
        end
	return "\255"..string.char(R255)..string.char(G255)..string.char(B255) --works thanks to zwzsg
end 

-------------------------------------------

local function resizeUI(vsx,vsy)
    if onOffStateBtn ~= nil then
        onOffStateBtn:SetPos(vsx*0.28, vsy*(1-0.10-0.01), vsx*0.07, vsy*0.10) 
    end
end

local function cmdAction(obj, x, y, button, mods)
    if button==1 then
        -- left mouse, select command
        if obj.disabled then return end
        local index = Spring.GetCmdDescIndex(obj.cmdId)
        if (index) then
            local left, right = (button == 1), (button == 3)
            local alt, ctrl, meta, shift = mods.alt, mods.ctrl, mods.meta, mods.shift
            Spring.SetActiveCommand(index, button, left, right, alt, ctrl, meta, shift)
        end
    elseif button==3 and playerUnitID then
        -- right mouse, switch between push/pull
        local state = Spring.GetUnitIsActive(playerUnitID)
        if state ~= nil then
            local newState = state and 0 or 1
            Spring.GiveOrderToUnit(playerUnitID, CMD.ONOFF, {[1] = newState}, {})
            updateRequired = true
        end        
    end
end

local function addOnOffState(cmd)
    local param = cmd.params[cmd.params[1] + 2]
    if param:find("On") then
        param = ColStr(pushCol) .. "Push\b"
    else
        param = ColStr(pullCol) .. "Pull\b"
    end
    onOffStateBtn = Chili.Button:New{
		caption   = param,
		cmdName   = attackCmd.name,
		tooltip   = cmd.tooltip,
		cmdId     = attackCmd.id,
		cmdAName  = attackCmd.action,
		padding   = {10,0,0,0},
		margin    = {0,0,0,0},
		OnMouseUp = {cmdAction},
		font      = {
			size  = 20,
		},
        parent = Chili.Screen0,
		--backgroundColor = black,
	}
    local vsx,vsy = Spring.GetViewGeometry()
    resizeUI(vsx,vsy)
end

local function parseCmds()
	-- Parses through each cmd and gives it its own button
    onOffState = nil
    if onOffStateBtn ~= nil then
        onOffStateBtn:Dispose()
        onOffStateBtn = nil
    end
	for _, cmd in pairs(Spring.GetActiveCmdDescs()) do
		if cmd.action == "onoff" then
            onOffState = cmd
        elseif cmd.action == "attack" then
            attackCmd = cmd
        end
	end
    if onOffState ~= nil then
        addOnOffState(onOffState)
    end
end

function widget:ViewResize(vsx,vsy)
	resizeUI(vsx,vsy)
end

function widget:Initialize()
	Chili = WG.Chili
    if Spring.GetGameFrame()>0 then
        parseCmds()
    end
    
    local vsx,vsy = Spring.GetViewGeometry()
    resizeUI(vsx,vsy)
end

function widget:CommandsChanged()
    -- guess which unit is the player
    if not playerUnitID or not Spring.ValidUnitID(playerUnitID) then 
        for _, unitID in ipairs(Spring.GetAllUnits()) do
            if UnitDefs[Spring.GetUnitDefID(unitID)].customParams.player then
                playerUnitID = unitID
            end
        end
        if not Spring.ValidUnitID(playerUnitID) then return end
    end

	updateRequired = true
end

function widget:Update()
    if updateRequired then
        parseCmds()
        updateRequired = false
    end
end