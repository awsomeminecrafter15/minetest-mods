-- xDoors mod by xyz

-- remove default doors (or left/right version) and drop new doors
local REMOVE_DEFAULT_DOORS = false

local models = {
    {
        -- bottom part
        {-0.5, -0.5, -0.5, -0.4, 0.5, 0.5},
        -- A
        {-0.5, 0.5, -0.5, -0.4, 1.5, -0.3},
        -- B
        {-0.5, 0.5, 0.3, -0.4, 1.5, 0.5},
        -- C
        {-0.5, 1.3, -0.3, -0.4, 1.5, 0.3},
        -- D
        {-0.5, 0.5, -0.3, -0.4, 0.6, 0.3},
        -- E
        {-0.5, 0.6, -0.05, -0.4, 1.3, 0.05},
        -- F
        {-0.5, 0.9, -0.3, -0.4, 1, -0.05},
        -- G
        {-0.5, 0.9, 0.05, -0.4, 1, 0.3}
    },
    {
        {0.4, -0.5, -0.5, 0.5, 0.5, 0.5},
        {0.4, 0.5, -0.5, 0.5, 1.5, -0.3},
        {0.4, 0.5, 0.3, 0.5, 1.5, 0.5},
        {0.4, 1.3, -0.3, 0.5, 1.5, 0.3},
        {0.4, 0.5, -0.3, 0.5, 0.6, 0.3},
        {0.4, 0.6, -0.05, 0.5, 1.3, 0.05},
        {0.4, 0.9, -0.3, 0.5, 1, -0.05},
        {0.4, 0.9, 0.05, 0.5, 1, 0.3}
    },
    {
        {-0.5, -0.5, -0.5, 0.5, 0.5, -0.4},
        {-0.5, 0.5, -0.5, -0.3, 1.5, -0.4},
        {0.3, 0.5, -0.5, 0.5, 1.5, -0.4},
        {-0.3, 1.3, -0.5, 0.3, 1.5, -0.4},
        {-0.3, 0.5, -0.5, 0.3, 0.6, -0.4},
        {-0.05, 0.6, -0.5, 0.05, 1.3, -0.4},
        {-0.3, 0.9, -0.5, -0.05, 1, -0.4},
        {0.05, 0.9, -0.5, 0.3, 1, -0.4}
    },
    {
        {-0.5, -0.5, 0.4, 0.5, 0.5, 0.5},
        {-0.5, 0.5, 0.4, -0.3, 1.5, 0.5},
        {0.3, 0.5, 0.4, 0.5, 1.5, 0.5},
        {-0.3, 1.3, 0.4, 0.3, 1.5, 0.5},
        {-0.3, 0.5, 0.4, 0.3, 0.6, 0.5},
        {-0.05, 0.6, 0.4, 0.05, 1.3, 0.5},
        {-0.3, 0.9, 0.4, -0.05, 1, 0.5},
        {0.05, 0.9, 0.4, 0.3, 1, 0.5}
    }
}

local selections = {
    {-0.5, -0.5, -0.5, -0.4, 1.5, 0.5},
    {0.5, -0.5, -0.5, 0.4, 1.5, 0.5},
    {-0.5, -0.5, -0.5, 0.5, 1.5, -0.4},
    {-0.5, -0.5, 0.4, 0.5, 1.5, 0.5}
}

local transforms = {
    door_1_1 = "door_4_2",
    door_4_2 = "door_1_1",
    door_2_1 = "door_3_2",
    door_3_2 = "door_2_1",
    door_3_1 = "door_1_2",
    door_1_2 = "door_3_1",
    door_4_1 = "door_2_2",
    door_2_2 = "door_4_1"
}

local function xdoors_transform(pos, node, puncher)
    local x, y = node.name:find(":")
    local n = node.name:sub(x + 1)
    minetest.env:add_node(pos, {name = "xdoors:"..transforms[n]})
end

for i = 1, 4 do
    for j = 1, 2 do
        minetest.register_node("xdoors:door_"..i.."_"..j, {
            drawtype = "nodebox",
            tile_images = {"default_wood.png"},
            paramtype = "light",
            is_ground_content = true,
            groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
            drop = "xdoors:door",
            node_box = {
                type = "fixed",
                fixed = models[i]
            },
            selection_box = {
                type = "fixed",
                fixed = {
                    selections[i]
                }
            },
            on_punch = xdoors_transform
        })
    end
end

minetest.register_node("xdoors:door", {
    description = "Wooden Door",
    node_placement_prediction = "",
	inventory_image     = 'door_wood.png',
	wield_image         = 'door_wood.png',
    after_place_node = function(node_pos, placer)
        local best_distance = 1e50
        local best_number = 1
        local pos = placer:getpos()
        for i = 1, 4 do
            local box = minetest.registered_nodes["xdoors:door_"..i.."_1"].selection_box.fixed[1]
            box = {box[1] + node_pos.x, box[2] + node_pos.y, box[3] + node_pos.z, box[4] + node_pos.x, box[5] + node_pos.y, box[6] + node_pos.z}
            local center = {x = (box[1] + box[4]) / 2, y = (box[2] + box[5]) / 2, z = (box[3] + box[6]) / 2}
            local dist = math.pow(math.pow(center.x - pos.x, 2) + math.pow(center.y - pos.y, 2) + math.pow(center.z - pos.z, 2), 0.5)
            if dist < best_distance then
                best_distance = dist
                best_number = i
            end
        end
        minetest.env:add_node(node_pos, {name = "xdoors:door_"..best_number.."_1"})
    end
})

minetest.register_on_placenode(function(pos, newnode, placer)
    local b_pos = {x = pos.x, y = pos.y - 1, z = pos.z}
    local node = minetest.env:get_node(b_pos)
    if node.name:find("xdoors:door") ~= nil then
        minetest.env:remove_node(pos)
        minetest.env:add_item(pos, newnode.name)
    end
end)

minetest.register_craft({
	output = 'xdoors:door',
	recipe = {
		{ 'default:wood', 'default:wood', '' },
		{ 'default:wood', 'default:wood', '' },
		{ 'default:wood', 'default:wood', '' },
	},
})

if REMOVE_DEFAULT_DOORS then
    minetest.register_abm({
        nodenames = {"doors:door_wood_a_c", "doors:door_wood_b_c", "doors:door_wood_a_o", "doors:door_wood_b_o",
                     "doors:door_wood_right_a_c", "doors:door_wood_right_b_c", "doors:door_wood_right_a_o", "doors:door_wood_right_b_o",
                     "doors:door_wood_left_a_c", "doors:door_wood_left_b_c", "doors:door_wood_left_a_o", "doors:door_wood_left_b_o"},
        interval = 0.1,
        chance = 1,
        action = function(pos, node)
            minetest.env:remove_node(pos)
            if node.name:find("_b") ~= nil then
                minetest.env:add_item(pos, "xdoors:door")
            end
        end
    })
    minetest.register_alias("doors:door_wood_right", "xdoors:door")
    minetest.register_alias("doors:door_wood_left", "xdoors:door")
    minetest.register_alias("doors:door_wood", "xdoors:door")
end
