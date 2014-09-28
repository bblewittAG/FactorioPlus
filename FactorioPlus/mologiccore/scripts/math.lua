GetTable = function()
  MoMath = MoMath or {}
  return MoMath
end

FuncRegister("Clamp", function(N1, N2, N3)
  if(N1 < N2) then
    return N2
  elseif(N1 > N3) then
    return N3
  end
  return N1
end)

FuncRegister("Sign", function(N1)
  if N1 > 0 then
    return 1
  elseif N1 < 0 then
    return -1
  end
  return 0
end)

FuncRegister("Approach", function(N1, N2, N3)
  local C = (MoMath.Sign(N2 - N1)*N3)
  if C > 0 then
    if N1 + C > N2 then
      return N2
    end
  else
    if N1 + C < N2 then
      return N2
    end
  end
  return N1 + C
end)