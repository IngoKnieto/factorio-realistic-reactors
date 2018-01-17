data:extend({
  {
    type = "recipe-category",
    name = "steaming"
  },
  {
    type = "recipe-category",
    name = "water-cooling"
  },
  
  
  -- ITEM RECIPIES --
  --
 
 -- Nuclear Reactor
  {
    type = "recipe",
    name = "realistic-reactor",
    enabled = false,
    energy_required = 20,
    ingredients =
    {
      {"concrete", 500},
      {"steel-plate", 500},
      {"advanced-circuit", 500},
      {"copper-plate", 500},
    },
    result = "realistic-reactor"
  },
 
 -- Cooling Tower
  {
    type = "recipe",
    name = "rr-cooling-tower",
    enabled = false,
    energy_required = 20,
    ingredients =
    {
      {"concrete", 200},
      {"steel-plate", 100},
      {"pipe", 100},
      {"pump", 10}
    },
    result = "rr-cooling-tower"
  },
   
  -- OTHER RECIPIES
  --
  
  -- Cooling tower water cooling recipe
  {
    type = "recipe",
    name = "water-cooling",
    category = "water-cooling",
    enabled = true,
    hidden = true,
    energy_required = 0.5,
    ingredients =
    {
      {type="fluid", name="water", amount=500}
    },
    results =
    {
      {type="fluid", name="water", amount=480}
    },
    icon = "__base__/graphics/icons/fluid/water.png",
	icon_size = 32,
    subgroup = "fluid-recipes",
    order = "z"
  },
   {
    type = "recipe",
    name = "steam-cooling",
    category = "water-cooling",
    enabled = true,
    hidden = true,
    energy_required = 0.7,
    ingredients =
    {
      {type="fluid", name="steam", amount=300}
    },
    results =
    {
      {type="fluid", name="water", amount=50}
    },
    icon = "__base__/graphics/icons/fluid/water.png",
	icon_size = 32,
    subgroup = "fluid-recipes",
    order = "z"
  },
 -- Cooling tower steam dummy recipe
  {
    type = "recipe",
    name = "rr-cooling-tower-steam",
    category = "steaming",
    enabled = true,
    hidden = true,
    energy_required = 600,
    ingredients =
    {
      {type="fluid", name="water", amount=0.1}
    },
    results =
    {
      {type="fluid", name="water", amount=0}
    },
    icon = "__base__/graphics/icons/fluid/water.png",
	icon_size = 32,
    subgroup = "fluid-recipes",
    order = "z"
  }
  
  })
