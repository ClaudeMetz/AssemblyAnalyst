assembler = {}

local category_map = {
    [defines.entity_status.working] = "working",
    [defines.entity_status.fluid_production_overload] = "output_overload",
    [defines.entity_status.item_production_overload] = "output_overload",
    [defines.entity_status.waiting_to_launch_rocket] = "output_overload",
    [defines.entity_status.fluid_ingredient_shortage] = "input_shortage",
    [defines.entity_status.item_ingredient_shortage] = "input_shortage",
    [defines.entity_status.no_power] = "insufficient_power",
    [defines.entity_status.low_power] = "insufficient_power",
    [defines.entity_status.no_recipe] = "disabled",
    [defines.entity_status.disabled_by_script] = "disabled",
    [defines.entity_status.marked_for_deconstruction] = "disabled"
}

function assembler.data_init()
    return {
        working = 0,
        output_overload = 0,
        input_shortage = 0,
        insufficient_power = 0,
        disabled = 0
    }
end

function assembler.observe(entity, data)
    local category = category_map[entity.status]
    data[category] = data[category] + 1
end

function assembler.redraw(entity, data)
end