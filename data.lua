--data.lua
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")


--START MAP GEN
function MapGen_Quadromire()
    -- Nauvis-based generation
    local map_gen_setting = table.deepcopy(data.raw.planet.gleba.map_gen_settings)

    --map_gen_setting.terrain_segmentation = "very-high"

    map_gen_setting.autoplace_controls = {
        
        ["gleba_enemy_base"] = { frequency = 1, size = 1, richness = 1},
        ["stone"] = { frequency = 2, size = 2, richness = 2},
        ["iron-ore"] = { frequency = 2, size = 0.5, richness = 2},
        ["coal"] = { frequency = 2, size = 0.5, richness = 2},
        ["copper-ore"] = { frequency = 2, size = 0.5, richness = 2},
        ["crude-oil"] = { frequency = 2, size = 2, richness = 3},
        ["trees"] = { frequency = 1, size = 1, richness = 1 },
        ["rocks"] = { frequency = 1, size = 1, richness = 1},
        ["water"] = { frequency = 1, size = 1, richness = 1 },
        ["uranium-ore"] = { frequency = 1, size = 1, richness = 1 },
    }

    map_gen_setting.autoplace_settings["entity"] =  { 
        settings =
        {
        ["iron-ore"] = {},
        ["copper-ore"] = {},
        ["stone"] = {},
        ["coal"] = {},
        ["crude-oil"] = {},
        ["uranium-ore"] = {},
        ["big-sand-rock"] = {},
        ["huge-rock"] = {},
        ["big-rock"] = {},
        ["iron-stromatolite"] = {},
        ["copper-stromatolite"] = {}
        }
    }
     

    return map_gen_setting
end
-- increse stone patch size in start area
-- data.raw["resource"]["stone"]["autoplace"]["starting_area_size"] = 5500 * (0.005 / 3)

--END MAP GEN

local nauvis = data.raw["planet"]["nauvis"]
local planet_lib = require("__PlanetsLib__.lib.planet")

local start_astroid_spawn_rate =
{
  probability_on_range_chunk =
  {
    {position = 0.1, probability = asteroid_util.nauvis_chunks, angle_when_stopped = asteroid_util.chunk_angle},
    {position = 0.9, probability = asteroid_util.fulgora_chunks, angle_when_stopped = asteroid_util.chunk_angle}
  },
  type_ratios =
  {
    {position = 0.1, ratios = asteroid_util.nauvis_ratio},
    {position = 0.9, ratios = asteroid_util.fulgora_ratio},
  }
}
local start_astroid_spawn = asteroid_util.spawn_definitions(start_astroid_spawn_rate, 0.1)


local quadromire= 
{
    type = "planet",
    name = "quadromire", 
    solar_power_in_space = nauvis.solar_power_in_space,
    icon = "__planet-quadromire__/graphics/planet-quadromire.png",
    icon_size = 512,
    label_orientation = 0.55,
    starmap_icon = "__planet-quadromire__/graphics/planet-quadromire.png",
    starmap_icon_size = 512,
    magnitude = nauvis.magnitude,
    subgroup = "planets",
    surface_properties = {
        ["solar-power"] = 100,
        ["pressure"] = nauvis.surface_properties["pressure"],
        ["magnetic-field"] = nauvis.surface_properties["magnetic-field"],
        ["day-night-cycle"] = nauvis.surface_properties["day-night-cycle"],
        ["gravity"] = 10,
    },
    map_gen_settings = MapGen_Quadromire(),
    asteroid_spawn_influence = 1,
    asteroid_spawn_definitions = start_astroid_spawn,
    pollutant_type = "pollution"
}

quadromire.orbit = {
    parent = {
        type = "space-location",
        name = "star",
    },
    distance = 21,
    orientation = 0.56
}

local quadromire_connection = {
    type = "space-connection",
    name = "nauvis-quadromire",
    from = "nauvis",
    to = "quadromire",
    subgroup = data.raw["space-connection"]["nauvis-vulcanus"].subgroup,
    length = 15000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_gleba),
  }

PlanetsLib:extend({quadromire})
PlanetsLib.borrow_music(data.raw["planet"]["nauvis"], quadromire)


data:extend{quadromire_connection}

data:extend {{
    type = "technology",
    name = "planet-discovery-quadromire",
    icons = PlanetsLib.technology_icon_constant_planet("__planet-quadromire__/graphics/planet-quadromire.png", 512),
    icon_size = 512,
    essential = true,
    localised_description = {"space-location-description.quadromire"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "quadromire",
            use_icon_overlay_constant = true
        },
    },
    prerequisites = {
        "space-science-pack",
    },
    unit = {
        count = 200,
        ingredients = {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"space-science-pack",           1}
        },
        time = 60,
    },
    order = "ea[quadromire]",
}}


APS.add_planet{name = "quadromire", filename = "__planet-quadromire__/quadromire.lua", technology = "planet-discovery-quadromire"}