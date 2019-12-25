updater = {}

-- Defines order and color of the status-categories
local render_parameters = {
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
        color = {224, 224, 0}
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


function updater.data_init()
    return {
        working = 0,
        output_overload = 0,
        input_shortage = 0,
        insufficient_power = 0,
        disabled = 0
    }
end


-- Collects and saves the current status of the given entity
function updater.observe(entity, data)
    local category = maps.type_to_category[entity.type]
    local statistic = maps.status_to_statistic[category][entity.status]
    data[statistic] = data[statistic] + 1
end

-- Redraws the status bar for the given entity
function updater.redraw(entity, data, zone)
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

    for _, category in ipairs(render_parameters) do
        local datapoint = data[category.name]
        local width = usable_width * (datapoint / total_datapoints)

        table.insert(render_objects, rendering.draw_rectangle{surface=zone.surface, left_top=entity, left_top_offset=left_top_offset, right_bottom=entity, right_bottom_offset=collision_box.right_bottom, filled=true, color=category.color})

        left_top_offset.x = left_top_offset.x + width
    end
end