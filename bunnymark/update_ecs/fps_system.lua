local ECS = require 'ecs.ecs'

---@class BunnyMoveSystem:EcsSystem
local System = ECS.CLASS.class("FpsSystem", ECS.System)

function System.new() return ECS.CLASS.new_instance(System) end

function System:initialize()
    ECS.System.initialize(self)
    self.frames = {}
end

function System:update(dt)
    table.insert(self.frames, socket.gettime())
    if #self.frames == 61 then
        table.remove(self.frames, 1)
    end
end

function System:get_fps()
    local frames = self.frames
    return 1 / ((frames[#frames] - frames[1]) / (#frames - 1))
end

return System
