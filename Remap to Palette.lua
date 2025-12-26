----------------------------------------------------------------------------------------------------
-- Remap Sprite to Current Palette
-- This script remaps all colors in the active sprite to the closest colors
-- in the currently loaded palette using Euclidean distance in RGB space.
----------------------------------------------------------------------------------------------------

-- Get a handle to the current sprite.
local sprite = app.activeSprite

if not sprite then
  app.alert("No active sprite")
  
  return
end

-- Get the currently-loaded palette.
local palette = sprite.palettes[1]

if not palette then
  app.alert("No palette loaded")
  
  return
end

-- Calculates Euclidean distance between two colors.
local function colorDistance(c1, c2)
  local dr = c1.red - c2.red
  local dg = c1.green - c2.green
  local db = c1.blue - c2.blue
  
  return math.sqrt(dr*dr + dg*dg + db*db)
end

-- Finds closest color in palette.
local function findClosestColor(color, palette)
  local minDistance = math.huge
  local closestColor = palette:getColor(0)

  for i = 0, #palette-1 do
    local paletteColor = palette:getColor(i)

    -- Skip fully transparent colors.
    if paletteColor.alpha > 0 then
      local distance = colorDistance(color, paletteColor)
      
      if distance < minDistance then
        minDistance = distance
        closestColor = paletteColor
      end
    end
  end

  return closestColor
end

-- Build color mapping table.
local colorMap = {}
local uniqueColors = {}

-- Collect all unique colors from all layers and frames.
for i, layer in ipairs(sprite.layers) do
  if layer.isImage then
    for frameNumber, frame in ipairs(sprite.frames) do
      local cel = layer:cel(frameNumber)
      
      if cel then
        local image = cel.image
        
        for pixel in image:pixels() do
          local pixelValue = pixel()
          
          if pixelValue ~= 0 then  -- Skip transparent pixels (mask color).
            local color = Color(pixelValue)
            
            if color.alpha > 0 then  -- Only process non-transparent colors.
              local key = color.rgbaPixel
              
              if not uniqueColors[key] then
                uniqueColors[key] = color
              end
            end
          end
        end
      end
    end
  end
end

-- Find closest palette color for each unique color.
local totalColors = 0

for key, color in pairs(uniqueColors) do
  totalColors = totalColors + 1
end

local processed = 0

for key, color in pairs(uniqueColors) do
  colorMap[key] = findClosestColor(color, palette)
  processed = processed + 1

  if processed % 10 == 0 then
    app.refresh()
  end
end

-- Apply the color mapping.
app.transaction(function()
  for i, layer in ipairs(sprite.layers) do
    if layer.isImage then
      for frameNumber, frame in ipairs(sprite.frames) do
        local cel = layer:cel(frameNumber)
        
        if cel then
          local image = cel.image:clone()
          
          for pixel in image:pixels() do
            local pixelValue = pixel()
            
            if pixelValue ~= 0 then
              local color = Color(pixelValue)
              
              if color.alpha > 0 then
                local key = color.rgbaPixel
                local newColor = colorMap[key]
                
                if newColor then
                  pixel(newColor.rgbaPixel)
                end
              end
            end
          end
          
          cel.image = image
        end
      end
    end
  end
end)

app.alert("Remapped " .. totalColors .. " unique colors to closest palette matches!")

-- Make sure the UI and state update.
app.refresh()
