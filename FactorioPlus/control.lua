MLC = {
	Math=true,
	Timers=true,
	Misc=false,
	Entity=true,
	Debug=false
}

MoSave = require "mologiccore.base"

local KTE = MoEntity.KeyToEnt
local ReqItem = {}
ReqItem["irongen"] = "iron-ore"
ReqItem["coppergen"] = "copper-ore"

local ItemCoolDown = 5
local ItemMax = 50

MoTimers.CreateTimer("MainThink", 0.2, 0, false, function()
  MoEntity.CallLoop("iboxs", function(ent)
    local E = KTE(ent.entity)
    if E.valid then
	  local MyItem = ReqItem[E.name]
      local Inv = E.getitemcount(MyItem)
      if Inv < ItemMax and game.tick > ent.extra.CoolDown then
        if E.caninsert({name = MyItem, count = 1}) then
          E.insert({name = MyItem, count = 1})
          ent.extra.CoolDown = (ItemCoolDown*60) + game.tick
        end
      end
      return true
    end	
    return false 
  end)
end)

function RegEnt(entity)
  MoEntity.AddToLoop("iboxs", entity, {CoolDown = 0})
end

MoEntity.SubscribeOnBuilt("irongen", "IBoxDetect", RegEnt)
MoEntity.SubscribeOnBuilt("coppergen", "IBoxDetect", RegEnt)