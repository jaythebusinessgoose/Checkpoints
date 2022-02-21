local Checkpoints = require('Checkpoints/checkpoints')
local checkpoints = Checkpoints()

-- This example loads checkpoints via the "checkpoint" tilecode and saves the current checkpoint for later.
local level = {
    title = "Test Checkpoints Saving",
    -- Set rest of level properties here.
}

local level_state = {
    loaded = false,
    callbacks = {},
}

local persistent_state = {
    checkpoint = nil,
}

-- Call this function to load a checkpoint externally.
function level.update_checkpoint_position(x, y, layer, time)
    persistent_state.checkpoint = {x=x, y=y, layer=layer, time=time}
    checkpoints.activate_checkpoint_at(x, y, layer, time)
end

-- Clear checkpoint on completing the level, or can call this function externally to clear the checkpoint.
function level.clear_checkpoint()
    persistent_state.checkpoint = nil

    -- Clear the checkpoint state and start the level back from the main entrance.
    checkpoints.clear_checkpoint()
end

-- Set the callback to update our internal state when a checkpoint is activated.
checkpoints.checkpoint_activate_callback(function(x, y, layer, time)
    persistent_state.checkpoint = {x=x, y=y, layer=layer, time=time}
end)

function level.load_level()
    if level_state.loaded then return end
    level_state.loaded = true

    -- Clear the checkpoint state when completing the level so that going back to the level later starts the player over.
    level_state.callbacks[#level_state.callbacks+1] = set_callback(function()
        level.clear_checkpoint()
    end, ON.TRANSITION)

    checkpoints.activate()

    -- Add custom lua functions here.
end

function level.unload_level()
    if not level_state.loaded then return end

    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end

    checkpoints.deactivate()
end

return level