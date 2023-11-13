-- Lua Gauge widget

local translations = {en='Silver'}
local alphaList = {0x1000000, 0x2000000, 0x3000000, 0x4000000, 0x5000000, 0x6000000, 0x7000000, 0x8000000, 0x9000000, 0xA000000, 0xB000000, 0xD000000, 0xE000000, 0xF000000}

local loadingMask = lcd.loadMask('./bitmaps/loading.png')

local themeColor = lcd.themeColor(THEME_FOCUS_COLOR)

local loading = 1
local recordInit = 0

local w = 320
local h = 240

local function loadLib(name)
  local lib = dofile('/scripts/silver/'..name..'.lua')
  if lib.init ~= nil then
    lib.init()
  end
  return lib
end

local switch = loadLib('switch')
local trim = loadLib('trim')
local top = loadLib('top')
local record = loadLib('record')

local function name(widget)
  local locale = system.getLocale()
  return translations[locale] or translations['en']
end

local function create()
  return {
    source = nil,
    txPowerSource = nil,
    alpha = 2,
    reserve = 1,
    createTime = os.clock(),
    lastTime = os.clock(),
  }
end

local function wakeup(widget)
  -- print(system.getSource('RSSI'), system.getSource('RSSI 2.4G'), system.getSource('RSSI 900M'))
  local time = os.clock()
  local delay = 0.1

  if time > widget.lastTime + delay and loading == 1 then
    widget.lastTime = time
    if widget.reserve == 0 then
      widget.alpha = widget.alpha + 1
      if widget.alpha > 9 then widget.reserve = 1 end
    else
      widget.alpha = widget.alpha - 1
      if widget.alpha < 2 then widget.reserve = 0 end
    end
    lcd.invalidate()
  end

  if time > widget.createTime + 1 and loading == 1 then
    loading = 0
    lcd.invalidate()
  end

  if needRefrshRecords == 1 then
    needRefrshRecords = 0
    record.refresh()
  end

  top.wakeup(widget)
  switch.wakeup(widget)
  trim.wakeup(widget)
end

local function paint(widget)
  if loading == 1 then
    lcd.color(string.format('%#x', themeColor) - alphaList[widget.alpha])
    lcd.drawFilledRectangle(0, 0, w, 8)
    lcd.color(themeColor)
    lcd.drawMask(0, 0, loadingMask)
  else
    top.paint(widget, 0, 8)
    switch.paint(widget, 0, 32)
    trim.paint(widget, 91, 32)
    record.paint(widget, 0, 100)
  end
end

local function init()
  system.registerWidget({
    key = 'silver',
    name = name,
    create = create,
    paint = paint,
    wakeup = wakeup,
    title = false,
  })
end

return { init = init }