----------------------------------------------------------------------------------------------------
-- Exports the defined tags of the sprite as individual image files according to the supplied root
-- directory and the export directory specified in the user data of each tag.
----------------------------------------------------------------------------------------------------

--
-- Get a handle to the current sprite.
--
local spr = app.activeSprite
if not spr then
  return app.alert("There is no active sprite.")
end

--
-- Ask the user where the root directory that they would like tags to be exported to resides.
--
local dlg = Dialog("Export Tags")
dlg:entry{ id="directory", label="Output Directory", focus=true }
dlg:slider{ id="scale", label="Scale", min=1, max=10, value=2 }
 :button{ id="ok", text="&Export"}
 :button{ text="&Cancel" }
 :show()

if not dlg.data.ok then
    return end

--
-- Export each tagged frame as its own PNG file according to its name. Tag names can specify
-- sub-directories to the export directory using slashes (e.g. "subdirectory/name") if desired.
--
-- NOTE: Currently, we only support exporting single-frame tags and PNG files. In the future, we
--  might add support for exporting multi-frame tags (either as sprite strips or as GIF files).
--
for i, tag in ipairs(spr.tags) do
    local img = Image(spr.width, spr.height)

    img:drawSprite(spr, tag.fromFrame.frameNumber, 0)
    img:resize(spr.width * dlg.data.scale, spr.height * dlg.data.scale)
    img:saveAs(dlg.data.directory .. "/" .. tag.name .. ".png")
end

--
-- Make sure the UI and state update.
--
app.refresh()