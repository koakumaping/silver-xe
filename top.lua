local module = {}

local moduleX = 0
local moduleY = 0
local moduleWidth <const> = 320
local moduleHeight <const> = 32

local battery = 8.4
local batteryMaskWidth <const> = 38
local batteryMaskHeight <const> = 18
local B1Mask = lcd.loadMask('./bitmaps/b1.png')
local B2Mask = lcd.loadMask('./bitmaps/b2.png')
local B3Mask = lcd.loadMask('./bitmaps/b3.png')
local B4Mask = lcd.loadMask('./bitmaps/b4.png')
local B5Mask = lcd.loadMask('./bitmaps/b5.png')

local RSSI24G = -1
local RSSI24G1Mask = lcd.loadMask('./bitmaps/24G1.png')
local RSSI24G2Mask = lcd.loadMask('./bitmaps/24G2.png')
local RSSI24G3Mask = lcd.loadMask('./bitmaps/24G3.png')
local RSSI24G4Mask = lcd.loadMask('./bitmaps/24G4.png')
local RSSI24G5Mask = lcd.loadMask('./bitmaps/24G5.png')
local RSSI24G6Mask = lcd.loadMask('./bitmaps/24G6.png')

local RSSI900M = -1
local RSSI900M1Mask = lcd.loadMask('./bitmaps/900M1.png')
local RSSI900M2Mask = lcd.loadMask('./bitmaps/900M2.png')
local RSSI900M3Mask = lcd.loadMask('./bitmaps/900M3.png')
local RSSI900M4Mask = lcd.loadMask('./bitmaps/900M4.png')
local RSSI900M5Mask = lcd.loadMask('./bitmaps/900M5.png')
local RSSI900M6Mask = lcd.loadMask('./bitmaps/900M6.png')

local g1Color = var.bgColor
local g2Color = var.bgColor
local g3Color = var.bgColor
local g4Color = var.bgColor
local g5Color = var.bgColor
local g6Color = var.bgColor

local m1Color = var.bgColor
local m2Color = var.bgColor
local m3Color = var.bgColor
local m4Color = var.bgColor
local m5Color = var.bgColor
local m6Color = var.bgColor

local b1Color = var.bgColor
local b2Color = var.bgColor
local b3Color = var.bgColor
local b4Color = var.bgColor
local b5Color = var.bgColor


function module.getTime()
  return os.date("%H:%M", os.time())
end

local time = module.getTime()

function module.wakeup(widget)
  local needLcdInvalidate = false
  local TDMode = 1

  local RSSISource = system.getSource('RSSI')
  if RSSISource ~= nil then
    if TDMode == 1 then TDMode = 0 end

    local newValue = RSSISource:value()
    if RSSI24G ~= newValue then
      RSSI24G = newValue
      needLcdInvalidate = true
    end
  else
    if RSSI24G ~= -1 then
      RSSI24G = -1
      needLcdInvalidate = true
    end
  end

  if TDMode == 1 then
    local RSSI24GSource = system.getSource('RSSI 2.4G')
    if RSSI24GSource ~= nil then
      local newValue = RSSI24GSource:value()
      if RSSI24G ~= newValue then
        RSSI24G = newValue
        needLcdInvalidate = true
      end
    else
      if RSSI24G ~= -1 then
        RSSI24G = -1
        needLcdInvalidate = true
      end
    end

    local RSSI900MSource = system.getSource('RSSI 900M')
    if RSSI900MSource ~= nil then
      local newValue = RSSI900MSource:value()
      if RSSI900M ~= newValue then
        RSSI900M = newValue
        needLcdInvalidate = true
      end
    else
      if RSSI900M ~= -1 then
        RSSI900M = -1
        needLcdInvalidate = true
      end
    end
  end

  local _battery = system.getSource({ category = CATEGORY_SYSTEM, member = MAIN_VOLTAGE }):value()
  if battery ~= _battery then
    battery = _battery
    needLcdInvalidate = true
  end

  local _time = module.getTime()
  if time ~= _time then
    time = _time
    needLcdInvalidate = true
  end

  if needLcdInvalidate then
    lcd.invalidate(moduleX, moduleY, moduleWidth, moduleHeight)
  end
end

function module.paint(widget, x, y)
  local xStart = x + var.padding
  local yStart = y

  if moduleX ~= xStart then moduleX = xStart end
  if moduleY ~= yStart then moduleY = yStart end

  -- RSSI24G
  local RSSI24GColor = var.greenColor
  if RSSI24G == 0 then
    RSSI24GColor = var.redColor
  elseif RSSI24G == -1 then
    RSSI24GColor = var.bgColor
  else
    if RSSI24G >= 70 then
      RSSI24GColor = var.greenColor
    elseif RSSI24G >= 40 then
      RSSI24GColor = var.yellowColor
    else
      RSSI24GColor = var.redColor
    end
  end

  g1Color = RSSI24GColor
  g2Color = RSSI24GColor
  g3Color = RSSI24GColor
  g4Color = RSSI24GColor
  g5Color = RSSI24GColor
  g6Color = RSSI24GColor

  if RSSI24G <= 90 then
    g1Color = var.bgColor
  end
  if RSSI24G <= 80 then
    g2Color = var.bgColor
  end
  if RSSI24G <= 70 then
    g3Color = var.bgColor
  end
  if RSSI24G <= 50 then
    g4Color = var.bgColor
  end
  if RSSI24G <= 30 then
    g5Color = var.bgColor
  end
  if RSSI24G <= 0 then
    g6Color = var.bgColor
  end

  lcd.color(g1Color)
  lcd.drawMask(xStart + 6 * 0, yStart, RSSI24G1Mask)
  lcd.color(g2Color)
  lcd.drawMask(xStart + 6 * 1, yStart, RSSI24G2Mask)
  lcd.color(g3Color)
  lcd.drawMask(xStart + 6 * 2, yStart, RSSI24G3Mask)
  lcd.color(g4Color)
  lcd.drawMask(xStart + 6 * 3, yStart, RSSI24G4Mask)
  lcd.color(g5Color)
  lcd.drawMask(xStart + 6 * 4, yStart, RSSI24G5Mask)
  lcd.color(g6Color)
  lcd.drawMask(xStart + 6 * 5, yStart, RSSI24G6Mask)

  -- RSSI900M
  local RSSI900MColor = var.greenColor
  if RSSI900M == 0 then
    RSSI900MColor = var.redColor
  elseif RSSI900M == -1 then
    RSSI900MColor = var.noneColor
  else
    if RSSI900M >= 70 then
      RSSI900MColor = var.greenColor
    elseif RSSI900M >= 40 then
      RSSI900MColor = var.yellowColor
    else
      RSSI900MColor = var.redColor
    end
  end

  m1Color = RSSI900MColor
  m2Color = RSSI900MColor
  m3Color = RSSI900MColor
  m4Color = RSSI900MColor
  m5Color = RSSI900MColor
  m6Color = RSSI900MColor

  if RSSI900M <= 90 then
    m1Color = var.bgColor
  end
  if RSSI900M <= 80 then
    m2Color = var.bgColor
  end
  if RSSI900M <= 70 then
    m3Color = var.bgColor
  end
  if RSSI900M <= 50 then
    m4Color = var.bgColor
  end
  if RSSI900M <= 30 then
    m5Color = var.bgColor
  end
  if RSSI900M <= 0 then
    m6Color = var.bgColor
  end

  lcd.color(m1Color)
  lcd.drawMask(xStart + 44 + 6 * 0, yStart, RSSI900M1Mask)
  lcd.color(m2Color)
  lcd.drawMask(xStart + 44 + 6 * 1, yStart, RSSI900M2Mask)
  lcd.color(m3Color)
  lcd.drawMask(xStart + 44 + 6 * 2, yStart, RSSI900M3Mask)
  lcd.color(m4Color)
  lcd.drawMask(xStart + 44 + 6 * 3, yStart, RSSI900M4Mask)
  lcd.color(m5Color)
  lcd.drawMask(xStart + 44 + 6 * 4, yStart, RSSI900M5Mask)
  lcd.color(m6Color)
  lcd.drawMask(xStart + 44 + 6 * 5, yStart, RSSI900M6Mask)

  -- battery
  local batteryColor = var.greenColor
  if battery <= 7.6 then
    batteryColor = var.yellowColor
  end

  if battery <= 7.4 then
    batteryColor = var.redColor
  end

  b1Color = batteryColor
  b2Color = batteryColor
  b3Color = batteryColor
  b4Color = batteryColor
  b5Color = batteryColor

  if battery <= 8.0 then
    b1Color = var.bgColor
  end
  if battery <= 7.8 then
    b2Color = var.bgColor
  end
  if battery <= 7.6 then
    b3Color = var.bgColor
  end
  if battery <= 7.4 then
    b4Color = var.bgColor
  end
  if battery <= 7.2 then
    b5Color = var.bgColor
  end

  lcd.color(b1Color)
  lcd.drawMask(moduleWidth - batteryMaskWidth - var.padding + 8 * 0, yStart, B1Mask)
  lcd.color(b2Color)
  lcd.drawMask(moduleWidth - batteryMaskWidth - var.padding + 8 * 1, yStart, B2Mask)
  lcd.color(b3Color)
  lcd.drawMask(moduleWidth - batteryMaskWidth - var.padding + 8 * 2, yStart, B3Mask)
  lcd.color(b4Color)
  lcd.drawMask(moduleWidth - batteryMaskWidth - var.padding + 8 * 3, yStart, B4Mask)
  lcd.color(b5Color)
  lcd.drawMask(moduleWidth - batteryMaskWidth - var.padding + 8 * 4, yStart, B5Mask)

  lcd.font(FONT_S)
  lcd.color(var.blackColor)
  lcd.drawText(xStart + 44 + 6 * 7, yStart + 1, modelName)
  lcd.drawText(moduleWidth - batteryMaskWidth - var.padding - 4, yStart + 1, time, RIGHT)
end

return module