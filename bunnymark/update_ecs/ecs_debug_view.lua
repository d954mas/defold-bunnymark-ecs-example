
local EcsDebugView = {}

function EcsDebugView:init()
	self.vh = {
		lbl = gui.get_node("ecs/lbl"),
		root = gui.get_node("ecs/root"),
	}
	self.labels = {
		[0] = gui.clone(self.vh.lbl),
	}
	self.visible = false
	self.sorted_systems = {}
	self.sort_system_f = function (a, b)
		return a.__time.average_value > b.__time.average_value
	end

	gui.set_enabled(self.labels[0], true)
	gui.set_text(self.labels[0], string.format("%-20s %-9s %-6s %-6s %-9s \n", "Name", "Entities", "T", "TAvg", "TMax"))
end

function EcsDebugView:update(ecs)
	if self.visible then
		local systems =ecs.systems
		for i = 1, math.max(#self.sorted_systems, #systems) do
			self.sorted_systems[i] = systems[i]
		end

		table.sort(self.sorted_systems, self.sort_system_f)
		for i = 1, #self.sorted_systems do
			local sys = self.sorted_systems[i]
			local lbl = self.labels[i]
			if not lbl then
				lbl = gui.clone(self.vh.lbl)
				gui.set_enabled(lbl, true)
				self.labels[i] = lbl
				local position = vmath.vector3(0, 0-i * 13, 0)
				gui.set_position(lbl, position)
			end
			gui.set_text(lbl, string.format("%-20s %-9d %-6.3f %-6.3f %-6.3f\n", sys.__class.name, #sys.entities_list,
			sys.__time.current * 1000, sys.__time.average_value * 1000, sys.__time.max * 1000))
		end
	end
end

function EcsDebugView:set_visible(visible)
	self.visible = visible
	gui.set_enabled(self.vh.root, visible)
end

return EcsDebugView
