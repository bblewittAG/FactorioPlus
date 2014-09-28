GetTable = function()
  Debug = Debug or {}
  return Debug
end

FuncRegister("Print", function(Text)
  game.player.print(""..Text)
end)

FuncRegister("PrintTable", function(Table)
  for i, d in pairs(Table) do
    Debug.Print(i.." : "..tostring(d))
  end
end)

local Tables = {}
local Temp = {}

function FormatButton(Value, Gui, N, i, Num)
  local F, T, Ex = function()
  end, type(Value), {}
  if T == "table" then
    Gui.add{type = "button", name = N, direction = "horizontal", caption = "T: "..tostring(i)}
    F = OpenTable
  else
    Gui.add{type = "button", name = N, direction = "horizontal", caption = i..": "..tostring(Value)}
    Ex = {G = Gui, I = i}
    F = function(V, N, I, ID, E) E.G[N].caption = E.I..": "..tostring(V)
	end
  end
  return {F = F, N = N, T = Value, I = Num, E = Ex, ID = i}
end

function ClearChildren(Gui, Num)
  local N = Num + 1
  M = Gui["TableList"..N]
  while M ~= nil do
    M.destroy() N = N + 1
    M = Gui["TableList"..N]
  end
end

function OpenTable(Table, Name, Num, ID)
  local Gui = game.player.gui.top["MLCD"]
  local M = Gui["TableList"..Num]
  if M ~= nil then
    M.destroy() ClearChildren(Gui, Num)
  end
  Gui.add{type = "table", name = "TableList"..Num, direction = "horizontal", colspan =# Table + 1}
  Gui["TableList"..Num].add{type = "label", name = "Label", direction = "horizontal", caption = ID}
  for i, d in pairs(Table) do
    local N = Name..tostring(i)
    Temp[N] = FormatButton(d, Gui["TableList"..Num], N, i, Num + 1)
  end
end

FuncRegister("RegisterTable", function(Name, Table)
  Tables[Name] = Table
end)

FuncRegister("OpenMLCDebug", function()
  local P = game.player.gui.top
  if P["MLCD"] then
    return
  end
  P.add{type = "frame", name = "MLCD"} P = P["MLCD"]
  OpenTable(Tables, "Tables", 1, "Tables")
end)

remote.addinterface("MoDebug", {OpenGui = function()
  Debug.OpenMLCDebug()
end, CloseGui = function()
  local M = game.player.gui.top["MLCD"]
  if M~=nil then
    Temp={} M.destroy()
  end
end})

game.onevent(defines.events.onguiclick, function(event)
  local N = Temp[event.element.name]
  if N~=nil then
    N.F(N.T, N.N, N.I, N.ID, N.E)
  end
end)