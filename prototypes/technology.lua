data:extend({

  {
    type = "technology",
    name = "realistic-reactors",
    icon = "__RealisticReactors__/graphics/technology/realistic-reactors.png",
    icon_size = 64,
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "realistic-reactor"
      },	  
      {
        type = "unlock-recipe",
        recipe = "cooling-tower"
      }
    },
    prerequisites = {"nuclear-power","circuit-network"},
    unit =
    {
      count = 1,
      ingredients =
      {
        {"science-pack-1", 1}
      },
      time = 15
    },
    order = "a-h-d"
  }
})

