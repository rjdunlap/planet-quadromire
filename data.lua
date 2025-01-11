--data.lua
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")


--START MAP GEN
function MapGen_Quadromire()
    -- Nauvis-based generation
    local map_gen_setting = table.deepcopy(data.raw.planet.gleba.map_gen_settings)

    --map_gen_setting.terrain_segmentation = "very-high"

    map_gen_setting.autoplace_controls = {
        
        ["enemy-base"] = { frequency = 1, size = 1, richness = 1},
        ["stone"] = { frequency = 2, size = 2, richness = 2},
        ["iron-ore"] = { frequency = 2, size = 0.5, richness = 2},
        ["coal"] = { frequency = 2, size = 0.5, richness = 2},
        ["copper-ore"] = { frequency = 2, size = 0.5, richness = 2},
        ["crude-oil"] = { frequency = 2, size = 2, richness = 3},
        ["trees"] = { frequency = 1, size = 1, richness = 1 },
        ["rocks"] = { frequency = 1, size = 1, richness = 1},
        ["water"] = { frequency = 1, size = 1, richness = 1 },
    }

    map_gen_setting.autoplace_settings["entity"] =  { 
        settings =
        {
        ["iron-ore"] = {},
        ["copper-ore"] = {},
        ["stone"] = {},
        ["coal"] = {},
        ["crude-oil"] = {},
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
    surface_properties = {
        ["solar-power"] = 100,
        ["pressure"] = nauvis.surface_properties["pressure"],
        ["magnetic-field"] = nauvis.surface_properties["magnetic-field"],
        ["day-night-cycle"] = nauvis.surface_properties["day-night-cycle"],
    },
    map_gen_settings = MapGen_Quadromire()
}

quadromire.orbit = {
    parent = {
        type = "space-location",
        name = "star",
    },
    distance = 1,
    orientation = 0.69
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

data:extend{quadromire_connection}

data:extend {{
    type = "technology",
    name = "planet-discovery-quadromire",
    icons = util.technology_icon_constant_planet("__planet-quadromire__/graphics/planet-quadromire.png"),
    icon_size = 256,
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