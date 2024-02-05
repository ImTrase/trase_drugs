-- Open source functions you can edit.
-- If you need support or have a question, join the discord: https://discord.gg/trase

-- Draws the marker on the floors.
-- @param coords table
-- @return void
function CreateMarker(coords)
    DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
end

-- Utilizes the text UI to prompt the user to press a key.
-- @param text string | boolean
-- @return void
function TextUI(text)
    if text then
        lib.showTextUI(text)
    else
        lib.hideTextUI()
    end
end