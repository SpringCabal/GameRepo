function gadget:GetInfo()
  return {
    name      = "Unselectable objects",
    desc      = "Unselectable objects (hidden during play mode)",
    author    = "gajop",
    date      = "April 2015",
    license   = "GNU GPL, v3",
    layer     = 0,
    enabled   = true,
  }
end


-- FlameRaw format: posx,posy,posz, dirx,diry,dirz, speedx,speedy,speedz, range

-- SYNCED
if gadgetHandler:IsSyncedCode() then
    
local devMode = (tonumber(Spring.GetModOptions().play_mode) or 0) == 0

function gadget:UnitCreated(unitID, unitDefID)
    if not devMode then
        local unitDef = UnitDefs[unitDefID]
        if unitDef.customParams.wall or unitDef.customParams.effect or unitDef.name == "plate" then
            Spring.SetUnitNoSelect(unitID, true)
        end
    end
end

function gadget:UnitPreDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponDefID, projectileID, attackerID, attackerDefID, attackerTeam)
    if UnitDefs[unitDefID].name == "crate" then
        return 0
    end
    return damage
end

end