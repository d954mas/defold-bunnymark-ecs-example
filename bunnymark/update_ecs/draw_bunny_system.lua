local ECS = require 'ecs.ecs'

local BUNNY_IMAGES = {
	hash("rabbitv3_batman"),
	hash("rabbitv3_bb8"),
	hash("rabbitv3"),
	hash("rabbitv3_ash"),
	hash("rabbitv3_frankenstein"),
	hash("rabbitv3_neo"),
	hash("rabbitv3_sonic"),
	hash("rabbitv3_spidey"),
	hash("rabbitv3_stormtrooper"),
	hash("rabbitv3_superman"),
	hash("rabbitv3_tron"),
	hash("rabbitv3_wolverine"),
}

---@class BunnyMoveSystem:EcsSystem
local System = ECS.CLASS.class("DrawBunnySystem", ECS.System)
System.filter = ECS.filter("bunny")

function System.new() return ECS.CLASS.new_instance(System) end

function System:on_add(e)
    local id = factory.create("#factory")
    if id then
		msg.post(msg.url(nil, id, "sprite"), "play_animation", { id = BUNNY_IMAGES[math.random(1, #BUNNY_IMAGES)] })
		-- we use msg.url() inside the engine, if you need maximum speed
		-- it's better to pre-cache URLs 
		e.bunny_go = { id = msg.url(nil, id, nil) }
	else
        print("failed to create bunny visual")
    end
end

function System:update(dt)
    local entities = self.entities_list
    for i = 1, #entities do
        local e = entities[i]
        if e.bunny_go then
            go.set_position(e.position, e.bunny_go.id)
        end
    end
end

return System
