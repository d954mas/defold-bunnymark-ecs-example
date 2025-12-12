# Defold ECS Bunnymark Example

This example is a showcase of how to use the lua ecs runtime in Defold. It's a bunnymark that spawns bunnies, draw bunnies, and measures FPS.


## Why this ECS?
- Based on [tiny-ecs](https://github.com/bakpakin/tiny-ecs), but I removed every feature that I don't use in my games.
- tiny-ecs ships with 864 lines of code, while `ecs/ecs.lua` is only 487 lines.
- Systems, entities, filters, and the tiny class helper all live in a single file, so you can inspect and tweak every part without hunting across a whole framework.

## Project layout
- `ecs/ecs.lua` – the trimmed ECS runtime (world management, filters, timing helpers, basic class utility).
--add more

If you only need the ECS library, copy the `ecs` folder into your own Defold project and require `ecs.ecs` from your game code.

## Using the ECS in your own update script
```lua
local ECS = require "ecs.ecs"
local MoveSystem = require "ecs.move_bunny_system"
local DrawSystem = require "ecs.draw_bunny_system"

function init(self)
    self.world = ECS.world()
    self.world:add_system(MoveSystem.new())
    self.world:add_system(DrawSystem.new())

    self.world:add_entity({
        bunny = true,
        position = vmath.vector3(400, 300, 0),
        velocity = 0,
    })
end

function update(self, dt)
    self.world:update(dt)
end
```
Entities are plain Lua tables; systems extend `ECS.System`, declare a filter (`System.filter = ECS.filter("bunny&velocity")`), and implement `update`, `draw`, `on_add`, or `on_remove` as needed. Because filtering is string-based you can tag entities with any components that make sense for your project.

#API

Добавь и распиши апи. 

## Credits
- ECS core based on tiny-ecs by bakpakin.
- Bunny graphics from https://pixijs.github.io/bunny-mark/
