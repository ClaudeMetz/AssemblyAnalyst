DEV_ACTIVE = true  -- Enables certain conveniences for development
llog = require("scripts.llog")

REDRAW_CYCLE_RATE = 1 * 60  -- redraws entity status every second

require("scripts.events")


-- ** DATA **
DATA = { status_to_statistic = {} }

DATA.type_to_category = {
    ["assembling-machine"] = "assembler",
    ["rocket-silo"] = "assembler",
    ["furnace"] = "assembler",
    ["lab"] = "lab",
    ["mining-drill"] = "mining_drill",
    ["inserter"] = "inserter"
}

local common_status = {
    [defines.entity_status.working] = "working",

    [defines.entity_status.full_output] = "output_overload",
    [defines.entity_status.full_burnt_result_output] = "output_overload",

    [defines.entity_status.no_power] = "insufficient_power",
    [defines.entity_status.low_power] = "insufficient_power",
    [defines.entity_status.no_fuel] = "insufficient_power",
    [defines.entity_status.no_input_fluid] = "insufficient_power",
    [defines.entity_status.low_input_fluid] = "insufficient_power",
    [defines.entity_status.low_temperature] = "insufficient_power",

    [defines.entity_status.disabled] = "disabled",
    [defines.entity_status.frozen] = "disabled",
    [defines.entity_status.ghost] = "disabled",
    [defines.entity_status.broken] = "disabled",
    [defines.entity_status.disabled_by_control_behavior] = "disabled",
    [defines.entity_status.disabled_by_script] = "disabled",
    [defines.entity_status.marked_for_deconstruction] = "disabled"
}

local function add_common(status)
    for define, statistic in pairs(common_status) do status[define] = statistic end
end

DATA.status_to_statistic.assembler = {
    [defines.entity_status.launching_rocket] = "working",
    [defines.entity_status.preparing_rocket_for_launch] = "working",

    [defines.entity_status.waiting_for_space_in_destination] = "output_overload",
    [defines.entity_status.waiting_to_launch_rocket] = "output_overload",
    [defines.entity_status.waiting_for_space_in_platform_hub] = "output_overload",

    [defines.entity_status.no_ingredients] = "input_shortage",
    [defines.entity_status.item_ingredient_shortage] = "input_shortage",
    [defines.entity_status.fluid_ingredient_shortage] = "input_shortage",

    [defines.entity_status.no_recipe] = "disabled",
}
add_common(DATA.status_to_statistic.assembler)

DATA.status_to_statistic.lab = {
    [defines.entity_status.missing_science_packs] = "input_shortage",

    [defines.entity_status.no_research_in_progress] = "disabled",
}
add_common(DATA.status_to_statistic.lab)

DATA.status_to_statistic.mining_drill = {
    [defines.entity_status.waiting_for_space_in_destination] = "output_overload",

    [defines.entity_status.no_minable_resources] = "input_shortage",
    [defines.entity_status.missing_required_fluid] = "input_shortage",
}
add_common(DATA.status_to_statistic.mining_drill)

DATA.status_to_statistic.inserter = {
    [defines.entity_status.waiting_for_space_in_destination] = "output_overload",
    [defines.entity_status.waiting_for_target_to_be_built] = "output_overload",
    [defines.entity_status.waiting_for_train] = "output_overload",

    [defines.entity_status.waiting_for_source_items] = "input_shortage",
    [defines.entity_status.waiting_for_more_items] = "input_shortage",

    [defines.entity_status.no_filter] = "disabled"
}
add_common(DATA.status_to_statistic.inserter)

function DATA.statistics_template()
    return {
        working = 0,
        output_overload = 0,
        input_shortage = 0,
        insufficient_power = 0,
        disabled = 0
    }
end
