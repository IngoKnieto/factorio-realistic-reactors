empty_sprite =
{
  filename = "__core__/graphics/empty.png",
  priority = "extra-high",
  frame_count = 1,
  width = 1,
  height = 1
}

interface_led =
{
  filename = "__base__/graphics/entity/combinator/activity-leds/decider-combinator-LED-S.png",
  width = 12,
  height = 12,
  frame_count = 1,
  --shift = {-0.28125, -0.34375}
  shift = {-0.15, -0.29}
}

interface_connection =
{
  shadow =
  {
    red = {0.796875, 0.5},
    green = {0.203125, 0.5},
  },
  wire =
  {
    red = {0.296875, 0.0625},
    green = {-0.296875, 0.0625},
  }
}

-- Nuclear reactor
reactor =
  {
    type = "reactor",
    name = "realistic-reactor",
	icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1.5, result = "realistic-reactor"},
    max_health = 500,
    corpse = "big-remnants",
    consumption = "80MW",
    neighbour_bonus = 1,
    burner =
    {
      fuel_category = "nuclear",
      effectivity = 2,
      fuel_inventory_size = 1,
      burnt_inventory_size = 1
    },
    --collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
    --selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	collision_box = {{-1.4, -1.4}, {1.4, 0.7}},
    selection_box = {{-1.5, -1.5}, {1.5, 0.5}},

	working_sound =
	{
		sound = { filename = "__RealisticReactors__/sound/reactor-active.ogg", volume = 0.6 },
		idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		apparent_volume = 1.5
	},
	
    picture =
    {
      layers =
      {
        {
		  filename = "__RealisticReactors__/graphics/entity/nuclear-reactor.png",
          width = 140,
          height = 160,
          shift = {0.6875, -0.59375}
        }
      }
    },

    working_light_picture =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-workinglight.png",
      width = 140,
      height = 160,
      shift = {0.6875, -0.59375},
	  priority = "extra-high",
      blend_mode = "additive"
    },
    light = {intensity = 1, size = 9.9, shift = {0.0, 0.0}, color = {r = 0.0, g = 0.5, b = 0.0}},

    heat_buffer =
    {
      max_temperature = 1000,
      specific_heat = "5MJ",
      max_transfer = "10GW",
      connections =
      {
        {
          position = {1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {0, -1.5},
          direction = defines.direction.north
        },
        {
          position = {-1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {1, -1},
          direction = defines.direction.east
        },
        {
          position = {1, 0},
          direction = defines.direction.east
        },
        {
          position = {-1.5, 0},
          direction = defines.direction.west
        },
        {
          position = {-1.5, -1},
          direction = defines.direction.west
        }
      }
    },

    connection_patches_connected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12
      }
    },

    connection_patches_disconnected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12,
        y = 32
      }
    },

	pipe_covers = pipecoverspictures(),
	
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
    meltdown_action = nil
   
  }

reactor_start =
  {
    type = "reactor",
    name = "realistic-reactor-start",
	icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1.5, result = "realistic-reactor"},
    max_health = 500,
    corpse = "big-remnants",
    consumption = "200MW",
    neighbour_bonus = 1,
    burner =
    {
      fuel_category = "nuclear",
      effectivity = 2,
      fuel_inventory_size = 1,
      burnt_inventory_size = 1
    },
    --collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
    --selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	collision_box = {{-1.4, -1.4}, {1.4, 0.7}},
    selection_box = {{-1.5, -1.5}, {1.5, 0.5}},

	working_sound =
	{
		sound = { filename = "__RealisticReactors__/sound/reactor-active.ogg", volume = 0.6 },
		idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		apparent_volume = 1.5
	},
	
    picture =
    {
      layers =
      {
        {
		  filename = "__RealisticReactors__/graphics/entity/nuclear-reactor.png",
          width = 140,
          height = 160,
          shift = {0.6875, -0.59375}
        }
      }
    },

    working_light_picture =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-workinglight.png",
      width = 140,
      height = 160,
      shift = {0.6875, -0.59375},
	  priority = "extra-high",
      blend_mode = "additive"
    },
    light = {intensity = 2, size = 9.9, shift = {0.0, 0.0}, color = {r = 1.0, g = 0.5, b = 0.0}},

    heat_buffer =
    {
      max_temperature = 1000,
      specific_heat = "5MJ",
      max_transfer = "10GW",
      connections =
      {
        {
          position = {1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {0, -1.5},
          direction = defines.direction.north
        },
        {
          position = {-1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {1, -1},
          direction = defines.direction.east
        },
        {
          position = {1, 0},
          direction = defines.direction.east
        },
        {
          position = {-1.5, 0},
          direction = defines.direction.west
        },
        {
          position = {-1.5, -1},
          direction = defines.direction.west
        }
      }
    },

    connection_patches_connected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12
      }
    },

    connection_patches_disconnected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12,
        y = 32
      }
    },

	pipe_covers = pipecoverspictures(),
	
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
    meltdown_action = nil
   
  }
 
 reactor_2 =
  {
    type = "reactor",
    name = "realistic-reactor-2",
	icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1.5, result = "realistic-reactor"},
    max_health = 500,
    corpse = "big-remnants",
    consumption = "100MW",
    neighbour_bonus = 1,
    burner =
    {
      fuel_category = "nuclear",
      effectivity = 2.5,
      fuel_inventory_size = 1,
      burnt_inventory_size = 1
    },
    --collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
    --selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	collision_box = {{-1.4, -1.4}, {1.4, 0.7}},
    selection_box = {{-1.5, -1.5}, {1.5, 0.5}},

	working_sound =
	{
		sound = { filename = "__RealisticReactors__/sound/reactor-active.ogg", volume = 0.6 },
		idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		apparent_volume = 1.5
	},
	
    picture =
    {
      layers =
      {
        {
		  filename = "__RealisticReactors__/graphics/entity/nuclear-reactor.png",
          width = 140,
          height = 160,
          shift = {0.6875, -0.59375}
        }
      }
    },

    working_light_picture =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-workinglight.png",
      width = 140,
      height = 160,
      shift = {0.6875, -0.59375},
	  priority = "extra-high",
      blend_mode = "additive"
    },
    light = {intensity = 1, size = 9.9, shift = {0.0, 0.0}, color = {r = 0.0, g = 0.5, b = 0.0}},

    heat_buffer =
    {
      max_temperature = 1000,
      specific_heat = "5MJ",
      max_transfer = "10GW",
      connections =
      {
        {
          position = {1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {0, -1.5},
          direction = defines.direction.north
        },
        {
          position = {-1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {1, -1},
          direction = defines.direction.east
        },
        {
          position = {1, 0},
          direction = defines.direction.east
        },
        {
          position = {-1.5, 0},
          direction = defines.direction.west
        },
        {
          position = {-1.5, -1},
          direction = defines.direction.west
        }
      }
    },

    connection_patches_connected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12
      }
    },

    connection_patches_disconnected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12,
        y = 32
      }
    },

	pipe_covers = pipecoverspictures(),
	
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
    meltdown_action = nil
   
  }
   
  reactor_3 =
  {
    type = "reactor",
    name = "realistic-reactor-3",
	icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1.5, result = "realistic-reactor"},
    max_health = 500,
    corpse = "big-remnants",
    consumption = "120MW",
    neighbour_bonus = 1,
    burner =
    {
      fuel_category = "nuclear",
      effectivity = 3,
      fuel_inventory_size = 1,
      burnt_inventory_size = 1
    },
    --collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
    --selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	collision_box = {{-1.4, -1.4}, {1.4, 0.7}},
    selection_box = {{-1.5, -1.5}, {1.5, 0.5}},

	working_sound =
	{
		sound = { filename = "__RealisticReactors__/sound/reactor-active.ogg", volume = 0.6 },
		idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		apparent_volume = 1.5
	},
	
    picture =
    {
      layers =
      {
        {
		  filename = "__RealisticReactors__/graphics/entity/nuclear-reactor.png",
          width = 140,
          height = 160,
          shift = {0.6875, -0.59375}
        }
      }
    },

    working_light_picture =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-workinglight.png",
      width = 140,
      height = 160,
      shift = {0.6875, -0.59375},
	  priority = "extra-high",
      blend_mode = "additive"
    },
    light = {intensity = 1, size = 9.9, shift = {0.0, 0.0}, color = {r = 0.0, g = 0.5, b = 0.0}},

    heat_buffer =
    {
      max_temperature = 1000,
      specific_heat = "5MJ",
      max_transfer = "10GW",
      connections =
      {
        {
          position = {1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {0, -1.5},
          direction = defines.direction.north
        },
        {
          position = {-1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {1, -1},
          direction = defines.direction.east
        },
        {
          position = {1, 0},
          direction = defines.direction.east
        },
        {
          position = {-1.5, 0},
          direction = defines.direction.west
        },
        {
          position = {-1.5, -1},
          direction = defines.direction.west
        }
      }
    },

    connection_patches_connected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12
      }
    },

    connection_patches_disconnected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12,
        y = 32
      }
    },

	pipe_covers = pipecoverspictures(),
	
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
    meltdown_action = nil
   
  }
  
  reactor_4 =
  {
    type = "reactor",
    name = "realistic-reactor-4",
	icon = "__RealisticReactors__/graphics/icons/nuclear-reactor.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1.5, result = "realistic-reactor"},
    max_health = 500,
    corpse = "big-remnants",
    consumption = "140MW",
    neighbour_bonus = 1,
    burner =
    {
      fuel_category = "nuclear",
      effectivity = 3.5,
      fuel_inventory_size = 1,
      burnt_inventory_size = 1
    },
    --collision_box = {{-2.2, -2.2}, {2.2, 2.2}},
    --selection_box = {{-2.5, -2.5}, {2.5, 2.5}},
	collision_box = {{-1.4, -1.4}, {1.4, 0.7}},
    selection_box = {{-1.5, -1.5}, {1.5, 0.5}},

	working_sound =
	{
		sound = { filename = "__RealisticReactors__/sound/reactor-active.ogg", volume = 0.6 },
		idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
		apparent_volume = 1.5
	},
	
    picture =
    {
      layers =
      {
        {
		  filename = "__RealisticReactors__/graphics/entity/nuclear-reactor.png",
          width = 140,
          height = 160,
          shift = {0.6875, -0.59375}
        }
      }
    },

    working_light_picture =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-workinglight.png",
      width = 140,
      height = 160,
      shift = {0.6875, -0.59375},
	  priority = "extra-high",
      blend_mode = "additive"
    },
    light = {intensity = 1, size = 9.9, shift = {0.0, 0.0}, color = {r = 0.0, g = 0.5, b = 0.0}},

    heat_buffer =
    {
      max_temperature = 1000,
      specific_heat = "5MJ",
      max_transfer = "10GW",
      connections =
      {
        {
          position = {1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {0, -1.5},
          direction = defines.direction.north
        },
        {
          position = {-1, -1.5},
          direction = defines.direction.north
        },
        {
          position = {1, -1},
          direction = defines.direction.east
        },
        {
          position = {1, 0},
          direction = defines.direction.east
        },
        {
          position = {-1.5, 0},
          direction = defines.direction.west
        },
        {
          position = {-1.5, -1},
          direction = defines.direction.west
        }
      }
    },

    connection_patches_connected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12
      }
    },

    connection_patches_disconnected =
    {
      sheet =
      {
        filename = "__RealisticReactors__/graphics/entity/reactor-connect-patches-empty.png",
        width = 32,
        height = 32,
        variation_count = 12,
        y = 32
      }
    },

	pipe_covers = pipecoverspictures(),
	
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65},
    meltdown_action = nil
   
  }
 
-- Interface entity for nuclear reactor
reactor_interface =
{
  type = "constant-combinator",
  name = "realistic-reactor-interface",
  icon = reactor.icon,
  icon_size = reactor.icon_size,
  flags = {"player-creation", "not-deconstructable"},
  max_health = reactor.max_health,
  collision_box = {{-1.4, -0.25}, {1.4, 0.4}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  item_slot_count = 10,
  sprites =
  {
    north =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-interface.png",
      priority = "high",
      frame_count = 1,
      width = 32,
      height = 32
    },
    east =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-interface.png",
      priority = "high",
      frame_count = 1,
      width = 32,
      height = 32
    },
    south =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-interface.png",
      priority = "high",
      frame_count = 1,
      width = 32,
      height = 32
    },
    west =
    {
      filename = "__RealisticReactors__/graphics/entity/nuclear-reactor-interface.png",
      priority = "high",
      frame_count = 1,
      width = 32,
      height = 32
    }
  },
  activity_led_sprites =
  {
    north = interface_led,
    east = interface_led,
    south = interface_led,
    west = interface_led
  },
  activity_led_light =
  {
    intensity = 0.8,
    size = 1,
  },
  activity_led_light_offsets =
  {
    interface_led.shift,
    interface_led.shift,
    interface_led.shift,
    interface_led.shift
  },
  circuit_wire_connection_points =
  {
    interface_connection,
    interface_connection,
    interface_connection,
    interface_connection
  },
  circuit_wire_max_distance = 7.5,
  order = "z"
}

reactor_eccs =
{
  type = "storage-tank",
  name = "realistic-reactor-eccs",
  icon = reactor.icon,
  icon_size = reactor.icon_size,
  flags = {"not-blueprintable", "not-deconstructable"},
  max_health = reactor.max_health,
  collision_mask = {"ghost-layer"},
  collision_box = {{-1.3, -1.3}, {1.3, 1.3}},
  selection_box = {{-1.5,-1.5},{1.5,1.5}},
  fluid_box =
  {
    base_area = 50,
    pipe_covers = pipecoverspictures(),
    pipe_connections =
    {
      --{position = {-2, -1}},
      {position = {-2, 1}},
      --{position = {-1, -2}},
      {position = {-1, 2}},
      --{position = {1, -2}},
      {position = {1, 2}},
      --{position = {2, -1}},
      {position = {2, 1}}
    }
  },
  window_bounding_box = {{-0.1,-0.1}, {0.1,0.1}},
  pictures =
  {
    picture =
    {
      north = empty_sprite,
      east = empty_sprite,
      south = empty_sprite,
      west = empty_sprite
    },
    fluid_background = empty_sprite,
    window_background = empty_sprite,
    flow_sprite = empty_sprite,
	gas_flow = empty_sprite
  },
  flow_length_in_ticks = 360,
  circuit_wire_connection_points = reactor_interface.circuit_wire_connection_points,
  circuit_wire_max_distance = 0,
  order = "z"
}

-- Cooling tower
cooling_tower =
{
  type = "furnace",
  name = "rr-cooling-tower",
  icon = "__RealisticReactors__/graphics/icons/cooling-tower.png",
  icon_size = 32,
  flags = {"placeable-neutral", "placeable-player", "player-creation"},
  minable = {hardness = 0.2, mining_time = 0.5, result = "rr-cooling-tower"},
  max_health = 500,
  corpse = "medium-remnants",
  resistances =
  {
    {
      type = "fire",
      percent = 70
    }
  },
  collision_box = {{-1.3, -1.3}, {1.3, 1.3}},
  selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
  drawing_box = {{-1.5, -3}, {1.5, 1.5}},
  fluid_boxes =
  {
    {
      production_type = "input",
      base_area = 25,
      base_level = -1,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        {position = {-2, -1}},
        {position = {-2, 1}},
        {position = {-1, -2}},
        {position = {-1, 2}}
      }
    },
    {
      production_type = "output",
      base_area = 25,
      base_level = 1,
      pipe_covers = pipecoverspictures(),
      pipe_connections =
      {
        {position = {1, -2}},
        {position = {1, 2}},
        {position = {2, -1}},
        {position = {2, 1}}
      }
    }
  },
  source_inventory_size = 0,
  result_inventory_size = 0,
  crafting_categories = {"water-cooling"},
  energy_usage = "120kW",
  crafting_speed = 1,
  energy_source =
  {
    type = "electric",
    usage_priority = "primary-input",
    emissions = 0,
  },
  animation =
  {
    filename = "__RealisticReactors__/graphics/entity/cooling-tower.png",
    width = 140,
    height = 160,
    frame_count = 1,
    shift = {0.6875, -0.59375}
  }
}

-- Steam creator for cooling tower
cooling_tower_steam =
{
  type = "furnace",
  name = "rr-cooling-tower-steam",
  icon = cooling_tower.icon,
  icon_size = 32,
  flags = {"not-blueprintable", "not-deconstructable"},
  max_health = cooling_tower.max_health,
  collision_mask = {"ghost-layer"},
  collision_box = {{-0.5,-0.5},{0.5,0.5}},
  selection_box = {{-0.5,-0.5},{0.5,0.5}},
  fluid_boxes =
  {
    {
      production_type = "input",
      base_area = 0.1,
      pipe_connections = { }
    },
    {
      production_type = "output",
      base_area = 0,
      pipe_connections = { }
    }
  },
  source_inventory_size = 0,
  result_inventory_size = 0,
  crafting_categories = {"steaming"},
  energy_usage = "1W",
  crafting_speed = 1,
  energy_source =
  {
    type = "burner",
    effectivity = 1,
    fuel_inventory_size = 1,
    emissions = 0,
    light_flicker =
    {
      minimum_intensity = 0,
      maximum_intensity = 0
    },
    smoke =
    {
      {
        name = "turbine-smoke",
		type = "trivial-smoke",
        deviation = {0.1, 0.1},
        frequency = 10,
        position = {0.0, -2.25},
        starting_vertical_speed = 0.00,
        starting_frame_deviation = 60,
		color = {r = 0.8, g = 0.8, b = 0.8, a = 0.1},
		duration = 150,
		spread_duration = 100,
		fade_away_duration = 100,
		start_scale = 1.25,
		end_scale = 2.0,
		affected_by_wind = true
      }
    }
  },
  animation = empty_sprite
}

fallout_cloud =
{
	type = "smoke-with-trigger",
	name = "fallout-cloud",
	flags = {"not-on-map"},
	show_when_smoke_off = true,
	animation =
	{
		filename = "__base__/graphics/entity/cloud/cloud-45-frames.png",
		flags = { "compressed" },
		priority = "low",
		width = 256,
		height = 256,
		frame_count = 45,
		animation_speed = 0.1,
		line_length = 7,
		scale = 6,
	},
	slow_down_factor = 0,
	affected_by_wind = true,
	cyclic = true,
	duration = 60 * 80,
	fade_away_duration = 4 * 60,
	spread_duration = 50,
	color = { r = 1, g = 1, b = 1},
	action =
	{
		type = "direct",
		action_delivery =
		{
			type = "instant",
			target_effects =
			{
				type = "nested-result",
				action =
				{
					type = "area",
					radius = 20,
					entity_flags = {"breaths-air"},
					action_delivery =
					{
						type = "instant",
						target_effects =
						{
						type = "damage",
						damage = { amount = 1, type = "poison"}
						}
					}
				}
			}
		}
	},
	action_cooldown = 30
}

data:extend({ 
  reactor,
  reactor_interface,
  reactor_eccs,
  reactor_start,
  reactor_2,
  reactor_3,
  reactor_4,
  cooling_tower,
  cooling_tower_steam,
  fallout_cloud
})