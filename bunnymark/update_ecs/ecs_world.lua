local ECS = require "ecs.ecs"
local MoveBunnySystem = require "bunnymark.update_ecs.move_bunny_system"
local DrawBunnySystem = require "bunnymark.update_ecs.draw_bunny_system"
local FpsSystem = require "bunnymark.update_ecs.fps_system"

local M = {}

function M:init()
    self.ecs_world = ECS.world()
	self.fps_system = FpsSystem.new()
	self.ecs_world:add_system(self.fps_system)
	self.ecs_world:add_system(MoveBunnySystem.new())
	self.ecs_world:add_system(DrawBunnySystem.new())

	self.ecs_world.on_entity_removed = function(self, entity)
		if entity.bunny then
			go.delete(entity.bunny_go.id, true)
			entity.bunny_go = nil
		end
	end
end

function M:add_bunny()
	---@class Entity
	local bunny = {
		position = vmath.vector3(math.random(640), math.random(930, 1030), 0),
		velocity = -math.random(200),
		bunny = true
	}
    self.ecs_world:add_entity(bunny)
	return bunny
end

function M:get_bunnies()
	return #self.ecs_world.entities_list
end

function M:get_fps()
	return self.fps_system:get_fps()
end

function M:update(dt)
    self.ecs_world:update(dt)
end

function M:final()
	self.ecs_world:clear()
	self.ecs_world = nil
	self.fps_system = nil
end

return M