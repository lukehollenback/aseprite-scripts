----------------------------------------------------------------------------------------------------
-- Adjusts the hue, saturation, and lightness of the current foreground color up slightly to help
-- create a quick color palette ramp.
----------------------------------------------------------------------------------------------------

local spr = app.activeSprite
if not spr then
  return app.alert("There is no active sprite.")
end

app.transaction(
  function()
    local col = app.fgColor

    col.hslHue = col.hslHue + 5
    col.hslSaturation = col.hslSaturation + 0.05
    col.hslLightness = col.hslLightness + 0.05

    app.fgColor = col
  end
)

app.refresh()