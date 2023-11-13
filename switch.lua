local module = {}

local moduleX = 0
local moduleY = 0
local moduleWidth = 320
local moduleHeight = 70

local width = 27
local height = 27

local switchBitmap = lcd.loadBitmap('./bitmaps/check_sw_bg.png')
local switchUpMask = lcd.loadMask('./bitmaps/check_sw_up.png')
local switchMidMask = lcd.loadMask('./bitmaps/check_sw_mid.png')
local switchDownMask = lcd.loadMask('./bitmaps/check_sw_down.png')

local MIN = -1024

local switchTable = { MIN, MIN, MIN, MIN, MIN, MIN, MIN, MIN, MIN, MIN, MIN, MIN }
local switchNameTable = { 'SA', 'SB', 'SC', 'SD', 'SE', 'SF', 'SG', 'SH', 'SI', 'SJ', 'SK', 'SL' }
local switchTwoStageNameTable = { 'SC', 'SD', 'SE', 'SF', 'SI', 'SJ', 'SK', 'SL' }

local gutter = var.padding + height

function module.indexOf(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

function module.getSwitchValue(widget, name)
  local index = module.indexOf(switchNameTable, name)
  return switchTable[index]
end

function module.paintSwitch(widget, xStart, yStart, name, index)
  local borderWidth = 2
  local paddingRight = 8

  local value = module.getSwitchValue(widget, name)
  local x = xStart + (paddingRight + width) * index

  lcd.drawBitmap(x, yStart, switchBitmap)

  if value < 0 then lcd.color(var.themeColor) else lcd.color(var.greyColor) end
  lcd.drawMask(x + 7, yStart + 1, switchUpMask)

  if module.indexOf(switchTwoStageNameTable, name) == nil then
    if value == 0 then lcd.color(var.themeColor) else lcd.color(var.greyColor) end
    lcd.drawMask(x + 10, yStart + 10, switchMidMask)
  end

  if value > 0 then lcd.color(var.themeColor) else lcd.color(var.greyColor) end
  lcd.drawMask(x + 7, yStart + 18, switchDownMask)

  -- lcd.color(var.textColor)
  -- lcd.font(FONT_XS)
  -- local w = lcd.getTextSize(name)
  -- lcd.drawText(x + (width - w) / 2, yStart + height + 2, name)
end

function module.wakeup(widget)
  local needLcdInvalidate = false
  local _switchTable = switchTable
  for i, name in ipairs(switchNameTable) do
    local source = system.getSource(name)
    if source ~= nil then
      local newValue = source:value()
      if switchTable[i] ~= newValue then
        switchTable[i] = source:value()
        needLcdInvalidate = true
      end
    end
  end

  if needLcdInvalidate then
    lcd.invalidate(moduleX, moduleY, moduleWidth, moduleHeight)
  end
end

function module.paint(widget, x, y)
  local xStart = x + 8
  local yStart = y
  local xPadding = 103

  if moduleX ~= xStart then moduleX = xStart end
  if moduleY ~= yStart then moduleY = yStart end

  module.paintSwitch(widget, xStart, yStart, 'SA', 0)
  module.paintSwitch(widget, xStart, yStart, 'SB', 1)
  module.paintSwitch(widget, xStart, yStart, 'SC', 2)

  module.paintSwitch(widget, xStart + xPadding, yStart, 'SG', 3)
  module.paintSwitch(widget, xStart + xPadding, yStart, 'SH', 4)
  module.paintSwitch(widget, xStart + xPadding, yStart, 'SI', 5)

  module.paintSwitch(widget, xStart, yStart + gutter, 'SD', 0)
  module.paintSwitch(widget, xStart, yStart + gutter, 'SE', 1)
  module.paintSwitch(widget, xStart, yStart + gutter, 'SF', 2)

  module.paintSwitch(widget, xStart + xPadding, yStart + gutter, 'SJ', 3)
  module.paintSwitch(widget, xStart + xPadding, yStart + gutter, 'SK', 4)
  module.paintSwitch(widget, xStart + xPadding, yStart + gutter, 'SL', 5)
end

return module
