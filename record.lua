local listTable = {}
local lineMax <const> = 1

local module = {}
local moduleX = 0
local moduleY = 0
local moduleWidth = 120
local moduleHeight = 200

local needRePrint = 1
local countMax = 0

function split(str, reps)
  local resultStrList = {}
  string.gsub(str,'[^'..reps..']+',function (w)
    table.insert(resultStrList,w)
  end)
  return resultStrList
end

function module.refresh(widget, x, y)
  local _listTable = {}
  local csv = io.open(string.format('%s%s%s', '/csv/', modelName, '.csv'), 'r')
  local count = 1
  while csv do
    local line = csv:read('*line')
    if line == nil then
      csv:close()
      break
    else
      if count > 1 then table.insert(_listTable, line) end
      count = count + 1
    end
  end
  csv:close()

  if countMax ~= count then
    countMax = count
    listTable = {}
    needRePrint = 1
    count = 1
    for index = #_listTable, 1, -1 do
      if count <= lineMax then table.insert(listTable, _listTable[index]) end
      count = count + 1
    end
    lcd.invalidate(moduleX, moduleY, moduleWidth, moduleHeight)
  end
end

function module.paint(widget, x, y)
  if needRePrint == 0 then return end

  needRePrint = 0
  local w = lcd.getTextSize('W')
  local xStart = x
  local yStart = y
  if moduleX ~= xStart then moduleX = xStart end
  if moduleY ~= yStart then moduleY = yStart end

  lcd.color(var.blackColor)

  local index = 1
  local line = listTable[index]
  local resultList = split(line, ',')
  local padding = 4
  for resultIndex = 1, #resultList do
    if resultIndex > 1 then
      padding = padding + lcd.getTextSize(resultList[resultIndex - 1]) + 4
    end
    -- date exp: 10-01
    if resultIndex == 6 then
      lcd.font(FONT_STD)
      -- local data = split(resultList[resultIndex], '-')
      -- resultList[resultIndex] = string.format('%s-%s', data[2], data[3])
      lcd.drawText(xStart + var.padding, yStart, resultList[resultIndex])
    end
    if resultIndex == 7 then
      lcd.font(FONT_STD)
      resultList[resultIndex] = split(resultList[resultIndex], ' ')[2]
      lcd.drawText(320 - var.padding, yStart, resultList[resultIndex], RIGHT)
    end

    local yFix = 32
    -- time
    if resultIndex == 2 then
      lcd.font(FONT_XXL)
      lcd.drawText(xStart + var.padding, yStart + yFix, resultList[resultIndex])
    end
    -- landing voltage
    if resultIndex == 3 then
      lcd.font(FONT_XXL)
      resultList[resultIndex] = split(resultList[resultIndex], '(')[1]
      lcd.drawText(xStart + var.padding, yStart + 84, resultList[resultIndex])
    end
    -- 24GMin
    if resultIndex == 4 then
      lcd.font(FONT_XXL)
      lcd.drawText(320 - var.padding, yStart + yFix, string.format('%s%s', resultList[resultIndex], 'dB'), RIGHT)
    end
    -- 900MMin
    if resultIndex == 5 then
      lcd.font(FONT_XXL)
      local value = resultList[resultIndex]
      if value == '-1' then value = '--' end
      -- resultList[resultIndex] = split(resultList[resultIndex], '(')[1]
      lcd.drawText(320 - var.padding, yStart + 84, string.format('%s%s', value, 'dB'), RIGHT)
    end
  end
end

return module