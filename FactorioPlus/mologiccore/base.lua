require "util"
require "defines"

local MLCDataVers = 1.44
local LastCompatable = 1.38
IsLoaded = false

function FuncRegister(Name, Function)
  local Table = GetTable()
  Table[Name] = Function
end

function GetTable()
end

local STables = {}
function RegisterSaveTable(Name, Table, Func, Over)
  STables[Name] = {N = Name, T = Table, O = Over, F = Func}
end

if MLC == nil then
  game.showmessagedialog("Warning, MoLogicCore Loaded without a setup table!")
else	
  MLCSaveFix = function()
    if not IsLoaded then
      MoSave()
    end
  end
  if MLC.Debug then
    require "scripts.debug"
  end
  if MLC.Math then
    require "scripts.math"
  end
  if MLC.Timers then
    require "scripts.timer"
  end
  if MLC.Misc then
    require "scripts.misc"
  end
  if MLC.Entity then
    require "scripts.entity"
  end
end

function TableCopy(Table)
  local NewTable = {}
  for i,d in pairs(Table) do
    local T = type(d)
    if T == "Table" then
      NewTable[i] = TableCopy(d)
    else
      NewTable[i] = d
    end
  end
  return NewTable
end

return function()
  if glob.MoLogicCore == nil or glob.MoLogicCore.Vers < LastCompatable then
     glob.MoLogicCore = {Vers = MLCDataVers}
  end
  for i, d in pairs(STables) do
    if glob.MoLogicCore[d.N] == nil then
      glob.MoLogicCore[d.N] = d.T
    else
      d.F(TableCopy(glob.MoLogicCore[d.N]))
      glob.MoLogicCore[d.N] = d.T
    end
  end	
  IsLoaded = true
end