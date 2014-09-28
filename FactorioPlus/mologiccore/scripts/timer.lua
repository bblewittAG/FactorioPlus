GetTable = function()
  MoTimers = MoTimers or {}
  return MoTimers
end

local Timers = {}
local WaitingList = {}
local SetTab = function(Table)
  for i, d in pairs(Table) do
  Timers[d.Name] = d
  end
end

RegisterSaveTable("MoTimers", Timers, SetTab, false)
if MLC.Debug then
  Debug.RegisterTable("Timers", Timers)
end

local Functions = {}
local function MergeWaitingList()
  for i, d in pairs(WaitingList) do
    if Timers[i] ~= nil and d.O or Timers[i] == nil then
      Timers[i] = util.table.deepcopy(d.T)
    end
  end
  WaitingList = {}
end

FuncRegister("CacheFunction", function(Name, Function)
  Functions["CB"..Name] = Function
end)

FuncRegister("CreateTimer", function(Name, Length, Repeat, Over, CallBack, Data)
  if IsLoaded then
    if Timers[Name] ~= nil and Over then
	  return
	end
    Timers[Name] = {Name = Name, Repeat = Repeat, Nxt = game.tick + (Length*60), Dur = Length, Del = false, CallBack = "CB"..Name, Data = Data}
    Functions["CB"..Name] = CallBack
  else
    WaitingList[Name] = {O = Over, T = {Name = Name, Repeat = Repeat, Nxt = game.tick + (Length*60), Dur = Length, Del = false, CallBack = "CB"..Name, Data = Data}}
    Functions["CB"..Name] = CallBack
  end
end)

FuncRegister("DeleteTimer", function(Name)
  Timers[Name] = nil
end)

FuncRegister("TimerTimeLeft", function(Name) 
  if Timers[Name] ~= nil then
    local Return = (Timers[Name].Nxt-game.tick)/60
    return Return
  end
  return 0
end)

FuncRegister("GetTimers", function()
  return Timers
end)

game.onevent(defines.events.ontick, function(event)
  if not IsLoaded then
    MLCSaveFix()
    MergeWaitingList()
    return
  end
  for i, d in pairs(Timers) do
    if game.tick >= d.Nxt then
      if d.Repeat > 1 or d.Repeat == 0 then
        if d.Repeat >1 then
          d.Repeat = d.Repeat -1
        end
        d.Nxt = game.tick + (d.Dur*60)
      else
        d.Del = true
      end
      if Functions["CB"..d.Name] == nil then
        d.Del = true
        game.player.print("Warning: "..d.Name.." doesnt have a function!")
      else
        Functions["CB"..d.Name](d.Data)
      end
    end
    if d.Del == true then
      MoTimers.DeleteTimer(d.Name)
    end
  end
end)