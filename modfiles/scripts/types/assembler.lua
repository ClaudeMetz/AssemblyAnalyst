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


function assembler.observe(_, entity, data)
    local category = category_map[entity.status]
    data[category] = data[category] + 1
end


-- Defines order and color of the status-categories
local category_render_parameters = {
    [1] = {
        name = "working",
        color = {0, 135, 0}
    },
    [2] = {
        name = "output_overload",
        color = {102, 204, 0}
    },
    [3] = {
        name = "input_shortage",
        color = {255, 255, 0}
    },
    [4] = {
        name = "insufficient_power",
        color = {204, 0, 0}
    },
    [5] = {
        name = "disabled",
        color = {204, 0, 204}
    },
}

function assembler.redraw(zone, entity, data)
    local unit_number = entity.unit_number
    local render_objects = zone:remove_render_objects(unit_number)

    local collision_box = entity.prototype.collision_box
    local left_top_offset = {
        x = collision_box.left_top.x,
        y = collision_box.right_bottom.y - 0.25
    }
    local usable_width = -collision_box.left_top.x + collision_box.right_bottom.x

    local total_datapoints = 0
    for _, datapoint in pairs(data) do total_datapoints = total_datapoints + datapoint end

    for _, category in ipairs(category_render_parameters) do
        local datapoint = data[category.name]
        local width = usable_width * (datapoint / total_datapoints)

        table.insert(render_objects, rendering.draw_rectangle{surface=entity.surface, left_top=entity, left_top_offset=left_top_offset, right_bottom=entity, right_bottom_offset=collision_box.right_bottom, filled=true, color=category.color})

        left_top_offset.x = left_top_offset.x + width
    end
end