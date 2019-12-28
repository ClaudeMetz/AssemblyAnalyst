-- This is a 'class' representing an redraw-schedule, attached to a specific zone
Schedule = {}
Schedule.__index = Schedule

function Schedule.init(zone, cycle_rate)
    local schedule = {
        zone = zone,
        cycles = nil,
        cycle_rate = cycle_rate,
        current_cycle = nil
    }
    setmetatable(schedule, Schedule)

    schedule:reset()

    return schedule
end

-- Resets the schedule, incorporating the current entity_map of its zone
function Schedule:reset()
    self.current_cycle = 1
    self.cycles = {}

    local entity_map = self.zone.entity_map
    local actions_per_cycle = math.ceil(table_size(entity_map) / self.cycle_rate)
    local this_cycle, actions_this_cycle = 1, 0

    for _, entity in pairs(entity_map) do
        self.cycles[this_cycle] = self.cycles[this_cycle] or {}
        table.insert(self.cycles[this_cycle], entity)
        
        actions_this_cycle = actions_this_cycle + 1
        if actions_this_cycle == actions_per_cycle then
            this_cycle = this_cycle + 1
            actions_this_cycle = 0
        end
    end
end

-- Advances the cycle of this schedule and executes the associated actions
function Schedule:tick()
    local cycle = self.cycles[self.current_cycle]

    if cycle ~= nil then  -- there might not be any work to do
        for _, entity in pairs(cycle) do entity:redraw_statusbar() end
    end

    if self.current_cycle == self.cycle_rate then self.current_cycle = 1
    else self.current_cycle = self.current_cycle + 1 end
end