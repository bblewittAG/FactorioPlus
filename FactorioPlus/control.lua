MLC = {
	Math=true,
	Timers=true,
	Misc=false,
	Entity=true,
	Debug=false
}

MoSave = require "mologiccore.base"

local KTE = MoEntity.KeyToEnt
local ReqItem = "iron-ore"
local ItemCoolDown = 4
local ItemMax = 50

MoTimers.CreateTimer("MainThink", 0.2, 0, false, function()
  MoEntity.CallLoop("iboxs", function(ent)
    local E = KTE(ent.entity)
    if E.valid then
      local Inv = E.getitemcount(ReqItem)
      if Inv < ItemMax and game.tick > ent.extra.CoolDown then
        if E.caninsert({name = ReqItem, count = 1}) then
          E.insert({name = ReqItem, count = 1})
          ent.extra.CoolDown = (ItemCoolDown*60) + game.tick
        end
      end
      return true
    end	
    return false 
  end)
end)

MoEntity.SubscribeOnBuilt("irongen", "IBoxDetect", function(entity)
  MoEntity.AddToLoop("iboxs", entity, {CoolDown = 0})
end)