data:extend({
  {
    type = "container",
    name = "irongen",
    icon = "__base__/graphics/icons/iron-chest.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "irongen"},
    max_health = 50,
    corpse = "small-remnants",
    open_sound = {filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65},
    close_sound = {filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7},
    resistances = {{type = "fire", percent = 90}},
	collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	fast_replaceable_group = "container",
    inventory_size = 1,
	picture = {filename = "__base__/graphics/entity/iron-chest/iron-chest.png", priority = "extra-high", width = 48, height = 34, shift = {0.2, 0}}
  }
})