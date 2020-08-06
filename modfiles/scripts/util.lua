util = {}

-- Determines the actual area an entity takes up
function util.determine_entity_area(entity)
    local collision_box, position = entity.prototype.collision_box, entity.position
    return {
        left_top = {
            x = position.x + collision_box.left_top.x,
            y = position.y + collision_box.left_top.y
        },
        right_bottom = {
            x = position.x + collision_box.right_bottom.x,
            y = position.y + collision_box.right_bottom.y
        }
    }
end

-- Removes all zones that overlap with the given area
function util.remove_overlapping_zones(spec)
    local zones = global.zones
    for index, zone in pairs(zones) do
        if zone:overlaps_with(spec) then
            zone:destroy_render_objects()
            zones[index] = nil
        end
    end
end