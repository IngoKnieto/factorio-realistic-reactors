data:extend({
  
  --Nuclear Reactor
  {
    type = "item",
    name = "realistic-reactor",
    icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
	--icon  = "__base__/graphics/icons/nuclear-reactor.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "f[nuclear-energy]-a[reactor]",
    place_result = "realistic-reactor",
    stack_size = 10
  },
    --Nuclear Reactor start version
  {
    type = "item",
    name = "realistic-reactor-start",
    icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
	--icon  = "__base__/graphics/icons/nuclear-reactor.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "f[nuclear-energy]-a[reactor]",
    place_result = "realistic-reactor-start",
    stack_size = 10
  },
    --Nuclear Reactor bonus 2 version
  {
    type = "item",
    name = "realistic-reactor-2",
    icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "f[nuclear-energy]-a[reactor]",
    place_result = "realistic-reactor-2",
    stack_size = 10
  },
      --Nuclear Reactor bonus 3 version
  {
    type = "item",
    name = "realistic-reactor-3",
    icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "f[nuclear-energy]-a[reactor]",
    place_result = "realistic-reactor-3",
    stack_size = 10
  },
      --Nuclear Reactor bonus 4 version
  {
    type = "item",
    name = "realistic-reactor-4",
    icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "f[nuclear-energy]-a[reactor]",
    place_result = "realistic-reactor-4",
    stack_size = 10
  },

  -- Cooling Tower
  {
    type = "item",
    name = "cooling-tower",
    icon = "__RealisticReactors__/graphics/icons/cooling-tower.png",
	icon_size = 32,
    flags = {"goes-to-quickbar"},
    subgroup = "energy",
    order = "b[steam-power]-d[cooling-tower]",
    place_result = "cooling-tower",
    stack_size = 10
  }
 })