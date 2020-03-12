data = { status_to_statistic = {} }

data.entity_built_filter = {
    {filter="crafting-machine"},
    {filter="type", type="lab"}
}

data.type_to_category = {
    ["assembling-machine"] = "assembler",
    ["rocket-silo"] = "assembler",
    ["furnace"] = "assembler",
    ["lab"] = "lab"
}


data.status_to_statistic.assembler = {
    [defines.entity_status.working] = "working",
    [defines.entity_status.fluid_production_overload] = "output_overload",
    [defines.entity_status.item_production_overload] = "output_overload",
    [defines.entity_status.fluid_ingredient_shortage] = "input_shortage",
    [defines.entity_status.item_ingredient_shortage] = "input_shortage",
    [defines.entity_status.no_power] = "insufficient_power",
    [defines.entity_status.no_fuel] = "insufficient_power",
    [defines.entity_status.low_power] = "insufficient_power",
    [defines.entity_status.no_recipe] = "disabled",
    [defines.entity_status.disabled_by_script] = "disabled",
    [defines.entity_status.marked_for_deconstruction] = "disabled",
    [defines.entity_status.waiting_to_launch_rocket] = "disabled"
}

data.status_to_statistic.lab = {
    [defines.entity_status.working] = "working",
    [defines.entity_status.missing_science_packs] = "input_shortage",
    [defines.entity_status.no_power] = "insufficient_power",
    [defines.entity_status.no_fuel] = "insufficient_power",
    [defines.entity_status.low_power] = "insufficient_power",
    [defines.entity_status.no_research_in_progress] = "disabled",
    [defines.entity_status.disabled_by_script] = "disabled",
    [defines.entity_status.marked_for_deconstruction] = "disabled"
}


function data.statistics_template()
    return {
        working = 0,
        output_overload = 0,
        input_shortage = 0,
        insufficient_power = 0,
        disabled = 0
    }
end

-- Defines order and color of the status-categories
data.render_parameters = {
    [1] = {
        name = "working",
        color = {0, 135, 0}
    },
    [2] = {
        name = "output_overload",
        color = {102, 224, 0}
    },
    [3] = {
        name = "input_shortage",
        color = {255, 165, 0}
    },
    [4] = {
        name = "insufficient_power",
        color = {204, 0, 0}
    },
    [5] = {
        name = "disabled",
        color = {204, 0, 204}
    }
}