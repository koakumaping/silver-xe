local module = {}

local trimMask = lcd.loadMask('./bitmaps/trim.png')
local trim2Mask = lcd.loadMask('./bitmaps/trim2.png')
local trim3Mask = lcd.loadMask('./bitmaps/trim3.png')

local moduleX = 0
local moduleY = 0
local moduleWidth = 120
local moduleHeight = 70

local Rud = 0
local Ele = 1
local Thr = 2
local Ail = 3
local step = 8

local trim1 = 0
local trim2 = 0
local trim3 = 0
local trim4 = 0

local function format(value)
  return value > 0 and string.format('+%d', value) or string.format('%d', value)
end

function module.wakeup(widget)
  local needLcdInvalidate = false
  local _trim1 = system.getSource({category = CATEGORY_TRIM, member = Ail}):value()
  local _trim2 = system.getSource({category = CATEGORY_TRIM, member = Ele}):value()
  local _trim3 = system.getSource({category = CATEGORY_TRIM, member = Thr}):value()
  local _trim4 = system.getSource({category = CATEGORY_TRIM, member = Rud}):value()

  if _trim1 ~= trim1 then
    trim1 = _trim1
    needLcdInvalidate = true
  end

  if _trim2 ~= trim2 then
    trim2 = _trim2
    needLcdInvalidate = true
  end

  if _trim3 ~= trim3 then
    trim3 = _trim3
    needLcdInvalidate = true
  end

  if _trim4 ~= trim4 then
    trim4 = _trim4
    needLcdInvalidate = true
  end

  if needLcdInvalidate then
    lcd.invalidate(moduleX, moduleY, moduleWidth, moduleHeight)
  end
end

function module.paint(widget, x, y)
  local size = 46
  local width = 18
  local borderWidth = 2

  local padding = var.padding
  local fix = 6

  local xStart = x + 23
  local yStart = y - 2

  if moduleX ~= xStart then moduleX = xStart end
  if moduleY ~= yStart then moduleY = yStart end

  lcd.font(FONT_XS)
  -- Ail
  local ailMaskX = xStart + size + 4
  local ailMaskY = yStart + size + 4
  lcd.color(var.textColor)
  lcd.drawText(ailMaskX + size, ailMaskY - width + 2, 'A', RIGHT)
  lcd.drawMask(ailMaskX, ailMaskY, trimMask)
  lcd.color(var.themeColor)
  lcd.drawFilledRectangle(ailMaskX + util.convertTrim(trim1), ailMaskY + borderWidth + fix, 4, 4)

  -- Ele
  local eleMaskX = xStart + size + 4
  local eleMaskY = yStart
  lcd.color(var.textColor)
  lcd.drawText(eleMaskX + width, eleMaskY, 'E')
  lcd.drawMask(eleMaskX, eleMaskY, trim2Mask)
  lcd.color(var.themeColor)
  lcd.drawFilledRectangle(eleMaskX + borderWidth + fix, eleMaskY + util.convertReverseTrim(trim2) + 1, 4, 4)

  -- Thr
  local thrMaskX = xStart + size - width + 4
  local thrMaskY = yStart
  lcd.color(var.textColor)
  lcd.drawText(thrMaskX - padding + 4, thrMaskY, 'T', RIGHT)
  lcd.drawMask(thrMaskX, thrMaskY, trim3Mask)
  lcd.color(var.themeColor)
  lcd.drawFilledRectangle(thrMaskX + borderWidth, thrMaskY + util.convertReverseTrim(trim3) + 1, 4, 4)

  -- Rud
  local rudMaskX = xStart
  local rudMaskY = yStart + size + 4
  lcd.color(var.textColor)
  lcd.drawText(rudMaskX, rudMaskY - width + 2, 'R')
  lcd.drawMask(rudMaskX, rudMaskY, trimMask)
  lcd.color(var.themeColor)
  lcd.drawFilledRectangle(rudMaskX + util.convertTrim(trim4), rudMaskY + borderWidth + fix, 4, 4)
end

return module