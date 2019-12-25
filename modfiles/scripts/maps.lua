maps = { status_to_statistic = {} }

maps.type_to_category = {
    ["assembling-machine"] = "assembler",
    ["rocket-silo"] = "assembler",
    ["furnace"] = "assembler"
}

maps.status_to_statistic.assembler = {
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