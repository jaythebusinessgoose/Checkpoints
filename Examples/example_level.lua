local Checkpoints = require('Checkpoints/checkpoints')
local checkpoints = Checkpoints()

-- This example loads checkpoints via the "checkpoint" tilecode and only keeps the progress during the current session.
local level = {
    title = "Test Checkpoints",
    -- Set rest of level properties here.
}

local level_state = {
    loaded = false,
}

function level.load_level()
    if level_state.loaded then return end
    level_state.loaded = true

    checkpoints.activate()

    -- Add custom lua functions here.
end

function level.unload_level()
    if not level_state.loaded then return end
    level_state.loaded = false

    checkpoints.deactivate()
end

return level