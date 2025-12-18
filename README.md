# Defold ECS Bunnymark Example

This example is a showcase of how to use the lua ecs runtime in Defold. It's a bunnymark that spawns bunnies, draw bunnies, and measures FPS.


## Why this ECS?
- Based on [tiny-ecs](https://github.com/bakpakin/tiny-ecs), but I removed every feature that I don't use in my games.
- tiny-ecs ships with 864 lines of code, while `ecs/ecs.lua` is only 487 lines.
- Systems, entities, filters, and the tiny class helper all live in a single file, so you can inspect and tweak every part without hunting across a whole framework.

## Project layout
- `ecs/ecs.lua` – ECS runtime (world management, filters, timing helpers, minimal class helper).
- `bunnymark/update_ecs/ecs_world.lua` – wraps the runtime, wires all systems, exposes helpers such as `add_bunny` and `get_fps`.
- `bunnymark/update_ecs/move_bunny_system.lua` – updates bunny velocity/position.
- `bunnymark/update_ecs/draw_bunny_system.lua` – spawns sprite GOs, caches URLs, and pushes positions to the engine.
- `bunnymark/update_ecs/fps_system.lua` – keeps a rolling window and exposes `get_fps`.
- `bunnymark/update_ecs/ecs_debug_view.lua` – optional  gui that visualizes systems state.
- `bunnymark/update_ecs/update_ecs.script` – Defold script that forwards lifecycle events to the ECS world.

If you only need the ECS, copy the `ecs` folder into your own Defold project and require `ecs.ecs`.

To see timings, enable `ecs_debug_view` or Defold's web profiler—you will get per-system stats because the runtime records `__time` for each system and use  profiler scopes if profiler is available. For even more accurate measurements use [chronos](https://github.com/d954mas/defold-chronos); the runtime will switch from `socket.gettime` to `chronos.nanotime` automatically if the module is present.

## Using the ECS in your own update script
```lua
local ECS = require "ecs.ecs"
local MoveSystem = require "bunnymark.update_ecs.move_bunny_system"
local DrawSystem = require "bunnymark.update_ecs.draw_bunny_system"

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

## API
### ECS module
- `ECS.world()` – creates a world instance.
- `ECS.filter(pattern)` – compiles a string expression like `a&!b|(c&d)` into a predicate used by systems.
- `ECS.System` – base class for systems (extend it through `ECS.CLASS.class`).
- `ECS.CLASS` – tiny OOP helper with `CLASS.class(name, parent)` and `CLASS.new_instance(class, ...)`.

### World
- `world:add_entity(entity)` – queue the entity (plain table) to enter or refresh inside the world.
- `world:remove_entity(entity)` – marks the entity for removal and calls system `on_remove`.
- `world:add_system(system)` / `world:remove_system(system)` – register systems in update order.
- `world:update(dt)` – processes system/entity queues, then calls each system’s `update`. Call this in update or fixed_update
- `world:draw(dt)` – optional function for systems that need draw_line or imgui
- `world:clear_entities()`, `world:clear_systems()`, `world:refresh()`, `world:clear()` – helpers to reset queues and contents.
- Hooks: override `world:on_entity_added`, `world:on_entity_removed`, and `world:on_entity_updated` to react to entity lifecycle events.

### System
- Declare a `filter` via `ECS.filter`. Systems will only receive entities that satisfy the filter.
- Optional fields: `interval` (only update every N seconds), `odd`/`even` (run on alternating frames).
- Lifecycle callbacks: `initialize`, `on_add(entity)`, `on_remove(entity)`, `on_add_to_world(world)`, `on_remove_from_world(world)`.
- Runtime methods: `update(self, dt)` for logic, `draw(self, dt)` if you need a render pass.
- Timing: during debug builds the runtime tracks `__time.current`, `max`, and `average` to help profile individual systems.

## Credits
- ECS core based on tiny-ecs by bakpakin.
- Bunny graphics from https://pixijs.github.io/bunny-mark/
