BLUE_BACKGROUND = "__base__/graphics/icons/signal/shape_square.png"
RED_BACKGROUND = "__RealisticReactors__/graphics/icons/signal_red_background.png"
GREEN_BACKGROUND = "__RealisticReactors__/graphics/icons/signal_green_background.png"
YELLOW_BACKGROUND = "__RealisticReactors__/graphics/icons/signal_yellow_background.png"
GREY_BACKGROUND = "__RealisticReactors__/graphics/icons/signal_grey_background.png"
ORANGE_BACKGROUND = "__RealisticReactors__/graphics/icons/signal_orange_background.png"

data:extend({
{
	type = "item-subgroup",
	name = "reactor-signals",
	group = "signals",
	order = "f"
},

-- signal-reactor-core-temp
{
	type = "virtual-signal",
	name = "signal-reactor-core-temp",
	icons =
	{
	  {icon = BLUE_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_core_temp.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-a"
},

-- signal-state-stopped
{
	type = "virtual-signal",
	name = "signal-state-stopped",
	icons =
	{
	  {icon = GREY_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_state.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-f"
},

-- signal-state-starting
{
	type = "virtual-signal",
	name = "signal-state-starting",
	icons =
	{
	  {icon = YELLOW_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_state.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-g"
},

-- signal-state-running
{
	type = "virtual-signal",
	name = "signal-state-running",
	icons =
	{
	  {icon = GREEN_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_state.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-h"
},

-- signal-state-scramed
{
	type = "virtual-signal",
	name = "signal-state-scramed",
	icons =
	{
	  {icon = RED_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_state.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-i"
},

-- signal-control-start
{
	type = "virtual-signal",
	name = "signal-control-start",
	icons =
	{
	  {icon = ORANGE_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_control_start.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-j"
},

-- signal-control-scram
{
	type = "virtual-signal",
	name = "signal-control-scram",
	icons =
	{
	  {icon = ORANGE_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_control_scram.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-k"
},

-- signal-coolant-amount"
{
	type = "virtual-signal",
	name = "signal-coolant-amount",
	icons =
	{
	  {icon = BLUE_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_coolant_amount.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-b"
},

-- signal-coolant-temperature
{
	type = "virtual-signal",
	name = "signal-coolant-temperature",
	icons =
	{
	  {icon = BLUE_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_coolant_temperature.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-c"
},

-- signal-uranium-fuel-cells
{
	type = "virtual-signal",
	name = "signal-uranium-fuel-cells",
	icons =
	{
	  {icon = BLUE_BACKGROUND},
	  {icon = "__base__/graphics/icons/uranium-fuel-cell.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-d"
},

-- signal-used-uranium-fuel-cells
{
	type = "virtual-signal",
	name = "signal-used-uranium-fuel-cells",
	icons =
	{
	  {icon = BLUE_BACKGROUND},
	  {icon = "__base__/graphics/icons/used-up-uranium-fuel-cell.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-e"
},

-- signal-reactor-neighbour-bonus
{
	type = "virtual-signal",
	name = "signal-neighbour-bonus",
	icons =
	{
	  {icon = BLUE_BACKGROUND},
	  {icon = "__RealisticReactors__/graphics/icons/signal_bonus.png"}
	},
	icon_size = 32,
	subgroup = "reactor-signals",
	order = "a-f"
},

})