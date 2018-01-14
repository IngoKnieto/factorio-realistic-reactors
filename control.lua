WRITE_LOG = false
-- ONLY ENABLE LOGGING IF YOU KNOW WHAT YOU ARE DOING! 
-- IT WILL HAVE AN EFFECT ON GAME PERFORMANCE AND MAY PRODUCE A LARGE LOG FILE
-- the log file is created here: %appdata%\factorio\script-output\RealisticReactors.log
TICKS_PER_UPDATE = 15 
-- each reactor and cooling tower gets updated once every 15 ticks (60 ticks = 1 s)
CHANGE_MULTIPLIER = 0.2 
-- used to multiply the temperature change 
-- CHANGE_MULTIPLIER and TICKS_PER_UPDATE work together and are balanced: 
-- 0.2 CHANGE_MULTIPLIER = 15 TICKS_PER_UPDATE
REACTOR_MASS = 4000 
-- used to calculate temperature changes when emergency cooling is used
-- the mass is an estimate best guess based on many tries and errors 
REACTOR_SCRAM_DURATION = 180
-- the duration of the scram state of the reactor in seconds
REACTOR_STARTING_DURATION = 30
-- the duration of the starting state of the reactor in seconds


---------------------------------
-- REACTOR STATES AND EFFECTS
---------------------------------
-- STOPPED
	-- effects: 
	--		reactor core will slowly cool down to environment temperature
	--		reactor core is not active	
	--		reactor core can be mined
	-- behaviour:
	--		changes the state to STARTING if it has a fuel cell and the start signal, and has no scram signal
-- STARTING
	-- effects:
	--		power output = 250 %		
	-- behaviour:
	--		changes the state to SCRAMED if scram signal is applied
	--		changes the state to RUNNING if reactor starting time > 30 s and it has no scram signal
-- RUNNING
	-- effects: 
	--		power output = 100%
	--		produces bonus power output for every other connected running reactor (+25% for each reactor, max. 4 connected reactors) 
	-- behaviour:
	--		changes state to STOPPED if there is no fuel any more
	--		changes the state to SCRAMED if scram signal is applied
-- SCRAMED
	-- effects:
	--		reactor core is not active
	--		power output = 0%, but decay heat is produced (1° / s)
	-- behaviour:
	-- 		changes state to STOPPED if reactor scram time > 120 s
---------------------------------

-- other variables declaration
REACTOR_ENTITY_NAME = "realistic-reactor"
REACTOR_ENTITY_NAME_START = "realistic-reactor-start"
REACTOR_ENTITY_NAME_2 = "realistic-reactor-2"
REACTOR_ENTITY_NAME_3 = "realistic-reactor-3"
REACTOR_ENTITY_NAME_4 = "realistic-reactor-4"
INTERFACE_ENTITY_NAME = "realistic-reactor-interface"
BOILER_ENTITY_NAME = "realistic-reactor-eccs"
TOWER_ENTITY_NAME = "cooling-tower"
STEAM_ENTITY_NAME = "cooling-tower-steam"
HEAT_PIPE_ENTITY_NAME = "heat-pipe"
SIGNAL_CORE_TEMP = {type="virtual", name="signal-reactor-core-temp"}
SIGNAL_STATE_STOPPED = {type="virtual", name="signal-state-stopped"}
SIGNAL_STATE_STARTING = {type="virtual", name="signal-state-starting"}
SIGNAL_STATE_RUNNING = {type="virtual", name="signal-state-running"}
SIGNAL_STATE_SCRAMED = {type="virtual", name="signal-state-scramed"}
SIGNAL_CONTROL_START = {type="virtual", name="signal-control-start"}
SIGNAL_CONTROL_SCRAM = {type="virtual", name="signal-control-scram"}
SIGNAL_COOLANT_AMOUNT = {type="virtual", name="signal-coolant-amount"}
SIGNAL_COOLANT_TEMP = {type="virtual", name="signal-coolant-temperature"}
SIGNAL_URANIUM_FUEL_CELLS = {type="virtual", name="signal-uranium-fuel-cells"}
SIGNAL_USED_URANIUM_FUEL_CELLS = {type="virtual", name="signal-used-uranium-fuel-cells"}
SIGNAL_NEIGHBOUR_BONUS  = {type="virtual", name="signal-neighbour-bonus"}



-- INITIALIZE MOD

function init_global()
  global = global or {}
  -- global.reactors stores the reactor and its parts(core, circuit interface, eccs)
  global.reactors = global.reactors or {}
  -- global.towers stores the cooling tower and the steam maker entity
  global.towers = global.towers or {}
  -- used to store values during build_connected_reactors_list
  global.connected_reactors = {}
  global.all_heat_pipes = {}
  
  game.write_file("RealisticReactors.log"," ") -- this line cleans the log file on game start
  logging("----------------------------------------------------------------------------")
  logging("Realistic Reactors Mod initialized")
  logging("---")
  logging("This is the log file of the Realistic Reactors mod. If you want to get rid of it, set WRITE_LOG = false in the control.lua file (line 1) of the mod.")
  logging("Please note, that this file is deleted and recreated, every time you restart the game.")
  logging("----------------------------------------------------------------------------")
end

script.on_init(init_global)


-- UPDATE FUNCTIONS

-- runs the update functions every x ticks
script.on_event(defines.events.on_tick, function(event)
	if table_length(global.reactors) > 0 then
	-- run events only when a reactor exists
	
		-- registered tick for update event of connected reactors list
		if event.tick == global.tick_update_connected_reactors then
			logging("---------------------------------------------------------------")
			logging("Updating connected reactors list")
			logging("Tick: " .. event.tick)
			logging("---------------------------------------------------------------")
			for i,reactor in pairs(global.reactors) do
				build_connected_reactors_list(reactor)
			end			
			logging("")
		end
	
		-- regular update cycle
		if event.tick % TICKS_PER_UPDATE == 0 then
			logging("---------------------------------------------------------------")
			logging("Starting update cycle. Tick: " .. event.tick)
			logging("---------------------------------------------------------------")
			
			---[[
			logging("--------------------------------")
			logging("Debugging global.reactors")
			logging("--------------------------------")
			for i,r in pairs(global.reactors) do
				logging("Reactor number " .. i)			
				logging("- reactor.id: " .. r.id)
				logging("- reactor.core_id: " .. r.core_id)
				logging("- reactor.core.unit_number: " .. r.core.unit_number)
				logging("- reactor.interface.unit_number: " .. r.interface.unit_number)
				logging("- reactor.eccs.unit_number: " .. r.eccs.unit_number)
				logging("- reactor model: " .. r.core.name)
				logging("- reactor state: " .. r.state)
				
				--[[
				logging("DEBUGGING: " .. table_length(r.connected_neighbour_IDs))
				if table_length(r.connected_neighbour_IDs) > 0 then
				logging("- connected reactors:")
				
					for i,id in pairs(r.connected_neighbour_IDs) do
						logging("-- ID: " .. id)
					end						
				end
				]]
			end
			--]]		
			
			-- every update cycle (default: 15 ticks)
			-- 		calculate temperature changes
			logging("--------------------------------")
			logging("Updating reactor temperature")
			logging("--------------------------------")
			for i,_ in pairs(global.reactors) do
				update_reactor_temperature(i,event)
			end			
			
			-- every 4 update cycles (default: 60 ticks = 1 second)
			-- 		check for changed reactor states 
			--		reset cooling tower steam recipe
			if event.tick % (TICKS_PER_UPDATE * 4) == 0 then
			
				logging("--------------------------------")
				logging("Updating reactor states")
				logging("--------------------------------")
				for i,_ in pairs(global.reactors) do
					update_reactor_states(i,event)
				end
				
				for i,_ in pairs(global.towers) do
					update_cooling_tower(i)
				end				
				
			end
			
			logging("")
		end -- update event
	
	end 
end)

-- registers event for update_connected_reactors list 
function register_update_connected_reactors_event(tick)
	logging("---")
	logging("Registered event update_connected_reactors on tick: " .. tick + 300)
	logging("---")
	global.tick_update_connected_reactors = tick + 300
end



-- FUNCTIONS FOR ADDING AND REMOVING BUILDINGS
do

-- functions for all game building/removing events 
do
script.on_event(defines.events.on_built_entity, function(event)
	if event.created_entity.name == REACTOR_ENTITY_NAME then
		add_reactor(event)
	elseif event.created_entity.name == TOWER_ENTITY_NAME then
		add_cooling_tower(event.created_entity)
	elseif event.created_entity.name == HEAT_PIPE_ENTITY_NAME then
		-- register event for updating list of connected reactors
		register_update_connected_reactors_event(event.tick)
	end
end)
script.on_event(defines.events.on_robot_built_entity, function(event)
	if event.created_entity.name == REACTOR_ENTITY_NAME then
		add_reactor(event)
	elseif event.created_entity.name == TOWER_ENTITY_NAME then
		add_cooling_tower(event.created_entity)
	elseif event.created_entity.name == HEAT_PIPE_ENTITY_NAME then
		-- register event for updating list of connected reactors
		register_update_connected_reactors_event(event.tick)
	end
end)
script.on_event(defines.events.on_pre_player_mined_item, function(event)
	if event.entity.name == REACTOR_ENTITY_NAME then
		remove_reactor(event)
	elseif event.entity.name == TOWER_ENTITY_NAME then
		remove_cooling_tower(event.entity)
	elseif event.entity.name == HEAT_PIPE_ENTITY_NAME then
		-- register event for updating list of connected reactors
		register_update_connected_reactors_event(event.tick)	
	end
end)
script.on_event(defines.events.on_robot_pre_mined, function(event)
	if event.entity.name == REACTOR_ENTITY_NAME then
		remove_reactor(event)
	elseif event.entity.name == TOWER_ENTITY_NAME then
		remove_cooling_tower(event.entity)
	elseif event.entity.name == HEAT_PIPE_ENTITY_NAME then
		-- register event for updating list of connected reactors
		register_update_connected_reactors_event(event.tick)	
	end
end)
script.on_event(defines.events.on_entity_died, function(event)
  if event.entity.name == REACTOR_ENTITY_NAME 
	or event.entity.name == REACTOR_ENTITY_NAME_START
	or event.entity.name == REACTOR_ENTITY_NAME_2
	or event.entity.name == REACTOR_ENTITY_NAME_3
	or event.entity.name == REACTOR_ENTITY_NAME_4 then
		remove_reactor(event)
  elseif event.entity.name == TOWER_ENTITY_NAME then
		remove_cooling_tower(event.entity)
  elseif event.entity.name == HEAT_PIPE_ENTITY_NAME then
		-- register event for updating list of connected reactors
		register_update_connected_reactors_event(event.tick)		
  end
end)

end

-- adds circuit interface and eccs to the reactor core when it is build
function add_reactor(event)
	reactor_core = event.created_entity
	--reactor is actually the reactor core
	
	logging("---------------------------------------------------------------")
    logging("Adding new reactor")
	logging("Reactor core ID: " .. reactor_core.unit_number)
	
	--add the circuit interface
	local interface = reactor_core.surface.create_entity
	{
		name = INTERFACE_ENTITY_NAME,
		position = {reactor_core.position.x, reactor_core.position.y + 1},
		force = reactor_core.force
	}
	interface.operable = false 
	interface.destructible = false 
	
	logging("Reactor ID: " .. interface.unit_number)
	logging("Reactor core ID: " .. reactor_core.unit_number)
	
	--add the eccs
	local eccs = reactor_core.surface.create_entity
	{
		name = BOILER_ENTITY_NAME,
		position = reactor_core.position,
		force = reactor_core.force
	}
	eccs.operable = false 
	eccs.destructible = false
	
	-- reactor is not active when it is build (state=stopped)
	reactor_core.active=false
	
	table.insert(global.reactors,
	{
		id = interface.unit_number,
		core_id = reactor_core.unit_number,
		core = reactor_core,
		interface = interface,
		eccs = eccs,
		position = reactor_core.position,
		unit_number = interface.unit_number,
		state = "stopped",
		state_active_since = event.tick,
		connected_neighbours_IDs = {},
		control = interface.get_or_create_control_behavior(),
		signals =
		{
		  parameters =
		  {
			["core_temperature"] = {signal=SIGNAL_CORE_TEMP, count=0, index=1},
			["state_stopped"] = {signal=SIGNAL_STATE_STOPPED, count=1, index=2},
			["state_starting"] = {signal=SIGNAL_STATE_STARTING, count=0, index=3},
			["state_running"] = {signal=SIGNAL_STATE_RUNNING, count=0, index=4},
			["state_scramed"] = {signal=SIGNAL_STATE_SCRAMED, count=0, index=5},
			["coolant-amount"] = {signal=SIGNAL_COOLANT_AMOUNT, count=0, index=6},
			["coolant-temperature"] = {signal=SIGNAL_COOLANT_TEMP, count=0, index=7},
			["uranium-fuel-cells"] = {signal=SIGNAL_URANIUM_FUEL_CELLS, count=0, index=8},
			["used-uranium-fuel-cells"] = {signal=SIGNAL_USED_URANIUM_FUEL_CELLS, count=0, index=9},
			["neighbour-bonus"] = {signal=SIGNAL_NEIGHBOUR_BONUS, count=0, index=10}
		  }
		}
	})
	
	logging("-> reactor successfully added")
	logging("")
	
	-- register event for updating list of connected reactors
	register_update_connected_reactors_event(event.tick)
	
end

-- removes other reactor parts when its reactor core is removed
function remove_reactor(event)
	
	dead_reactor_core = event.entity

	logging("---------------------------------------------------------------")
	logging("Removing reactor")
	logging("Reactor core ID: " .. dead_reactor_core.unit_number)
	
	for i,reactor in pairs(global.reactors) do
		if reactor.core_id == dead_reactor_core.unit_number then
			logging("Found reactor, ID: " .. reactor.id)
			logging("-> removing circuit interface and eccs")
			reactor.interface.destroy() -- remove circuit interface
			reactor.eccs.destroy() -- remove eccs
			
			if reactor.state == "stopped" then
				-- nothing, reactor is not working
			else
				-- working reactor destroyed, causing meltdown
				logging("-> working reactor destroyed, meltdown caused")
				--do the environment damage
				local surface = game.surfaces['nauvis']
				surface.create_entity({
					name="medium-explosion",
					position=dead_reactor_core.position
				})
				surface.create_entity({
					name="fallout-cloud",
					position=dead_reactor_core.position
				})					
			end				
			logging("-> removing global table entry")
			table.remove(global.reactors, i) -- remove table entry so we stop updating this reactor
			
		end
	end 
  
	logging("--> reactor successfully removed")
	logging("")
	
	-- register event for updating list of connected reactors
	register_update_connected_reactors_event(event.tick)
	
end

-- adds the steam entity to the cooling tower when it is build
function add_cooling_tower(tower)
-- the steam entity makes happy clouds when the tower is active
-- this is needed because the cooling tower is an electric furnace, and only burner furnaces can produce smoke
  logging("---------------------------------------------------------------")
  logging("Adding new cooling tower with ID: " .. tower.unit_number)
  local steam = tower.surface.create_entity
  {
    name = STEAM_ENTITY_NAME,
    position = tower.position,
    force = tower.force
  }
  steam.operable = false -- disable opening the happy cloud maker's GUI
  steam.destructible = false -- it can't be destroyed (we remove it when the cooling tower dies)
  steam.get_fuel_inventory().insert({name="solid-fuel", count=50}) -- at 1 watt, this is enough fuel to run for 39 years, should suffice
  steam.fluidbox[1] = {name="water", amount=1} -- water for dummy steam puff recipe
  steam.active = false -- start inactive
  table.insert(global.towers,
  {
    id = tower.unit_number,
    entity = tower,
    steam = steam
  })
  logging("-> tower successfully added")
  logging("")
end

-- removes the steam entity when its cooling tower is removed 
function remove_cooling_tower(dead_tower)
logging("---------------------------------------------------------------")
logging("Removing cooling tower ID: " .. dead_tower.unit_number)
  for i,tower in pairs(global.towers) do
    if tower.id == dead_tower.unit_number then
      logging("-> found tower, removing it and all its parts")
	  tower.steam.destroy() -- remove happy cloud maker
      table.remove(global.towers, i) -- remove table entry so we stop trying to update this tower
    end
  end
logging("-> tower successfully removed")
logging("")
end

end


-- FUNCTIONS FOR REACTOR STATE CONTROL AND REACTOR CORE REPLACEMENT
do

-- updates and changes the reactor state
function update_reactor_states(index, update_event)
	logging("---")
	
	-- load the reactor
	local reactor = global.reactors[index]
	logging("Updating reactor ID: " .. reactor.id)
	logging("Reactor core ID: " .. reactor.core_id)
	logging("Reactor model: " .. reactor.core.name)
	logging("Reactor state: " .. reactor.state)
	local running_time = math.ceil((update_event.tick - reactor.state_active_since)/60)
	logging("-> state active for (s): " .. running_time) 
	
		
	-- get control signals
	logging("Checking circuit network signals")
	local signal_start = false
	local signal_scram = false
	local green_network = reactor.control.get_circuit_network(defines.wire_type.green)
	if green_network then
		logging("-> Found green circuit network. Network ID: " .. green_network.network_id)
		if green_network.get_signal(SIGNAL_CONTROL_START) > 0 then
			signal_start = true
			logging("--> found green START signal")
		end
		if green_network.get_signal(SIGNAL_CONTROL_SCRAM) > 0 then
			signal_scram = true
			logging("--> found green SCRAM signal")
		end		
	end
	local red_network = reactor.control.get_circuit_network(defines.wire_type.red)
	if red_network then
		logging("-> Found red circuit network. Network ID: " .. red_network.network_id)
		if red_network.get_signal(SIGNAL_CONTROL_START) > 0 then
			signal_start = true
			logging("--> found red START signal")
		end
		if red_network.get_signal(SIGNAL_CONTROL_SCRAM) > 0 then
			signal_scram = true
			logging("--> found red SCRAM signal")
		end		
	end	
	
	-- check for changed states
	logging("Checking for changed reactor state")
	local state_changed = false
	if reactor.state == "stopped" then
		
		if reactor.core.get_fuel_inventory().is_empty() == false
		  and signal_start == true
		  and signal_scram == false then
			state_changed = true
			change_reactor_state("starting", reactor, update_event)
		end	
		
	elseif reactor.state == "starting" then
		
		if signal_scram == true then
			state_changed = true
			change_reactor_state("scramed", reactor, update_event)
		elseif running_time > REACTOR_STARTING_DURATION then
			state_changed = true
			change_reactor_state("running", reactor, update_event)
		end
	
	elseif reactor.state == "running" then
		
		if signal_scram == true then
			state_changed = true
			change_reactor_state("starting", reactor, update_event)
		elseif reactor.core.get_fuel_inventory().is_empty() == true and reactor.core.burner.heat == 0 then
			state_changed = true
			change_reactor_state("stopped", reactor, update_event)
		end		
	
	elseif reactor.state == "scramed" then
		
		if running_time > REACTOR_SCRAM_DURATION then
			state_changed = true
			change_reactor_state("stopped", reactor, update_event)			
		end
		
	end	
	
	if state_changed == false then
		logging("-> reactor state unchanged")
	end
	

	--update reactor signals
	if reactor.state  == "starting" then
		reactor.signals.parameters["state_starting"].count = REACTOR_STARTING_DURATION - running_time + 1
	end
	
	if reactor.state  == "scramed" then
		reactor.signals.parameters["state_scramed"].count = REACTOR_SCRAM_DURATION - running_time + 1
	end	
	
	-- replace reactor with neighbour bonus version
	if reactor.state == "running" then
		
		logging("Upgrade running reactor if it has other connected running reactors")
		local neighbours = 0
		for i,rid in pairs(reactor.connected_neighbours_IDs) do
			--logging("- connected reactor ID: " .. rid)
			neighbours = neighbours + 1
		end
		logging("Number of connected reactors: " .. neighbours)		
		
		if neighbours <= 1 then
			logging("-> no other reactor connected")
			reactor.signals.parameters["neighbour-bonus"].count = neighbours
		else
			-- check connected reactors:
			-- how many are connected
			-- and how many of them are running
			local reactor_bonus = 1
			
			for i,id in pairs(reactor.connected_neighbours_IDs) do
				logging("- checking connected reactor ID: " .. id)
				
				if id == reactor.id then
					-- same reactor, do nothing
					logging("-> this is the current reactor")					
				else
					-- found another reactor, check if it is running
					for i,global_reactor in pairs(global.reactors) do
						if global_reactor.id == id then
							logging("-> loaded connected reactor ID: " .. global_reactor.id)
							if global_reactor.state == "running" then
								reactor_bonus = reactor_bonus +1
								logging("--> reactor is running, bonus: " .. reactor_bonus)
							else
								logging("--> reactor is not running, no bonus")
							end
						end
					end
				end
			end
			
			logging("Reactor bonus level: " .. reactor_bonus)
			
			-- update reactor bonus signal
			reactor.signals.parameters["neighbour-bonus"].count = reactor_bonus
			
			-- replace running reactor with its bonus version
			if reactor_bonus == 1 then
				if reactor.core.name ~= REACTOR_ENTITY_NAME then
					logging("-> Building regular reactor (level 1)")
					replace_reactor(reactor,REACTOR_ENTITY_NAME)
				else
					logging("-> Reactor level 1 already build")
				end
			elseif reactor_bonus == 2 then
				if reactor.core.name ~= REACTOR_ENTITY_NAME_2 then
					logging("-> Building reactor level 2")
					replace_reactor(reactor,REACTOR_ENTITY_NAME_2)
				else
					logging("-> Reactor level 2 already build")					
				end
			elseif reactor_bonus == 3 then
				if reactor.core.name ~= REACTOR_ENTITY_NAME_3 then
					logging("-> Building reactor level 3")
					replace_reactor(reactor,REACTOR_ENTITY_NAME_3)
				else
					logging("-> Reactor level 3 already build")					
				end
			elseif reactor_bonus == 4 then
				if reactor.core.name ~= REACTOR_ENTITY_NAME_4 then
					logging("-> Building reactor level 4")
					replace_reactor(reactor,REACTOR_ENTITY_NAME_4)
				else
					logging("-> Reactor level 4 already build")					
				end
			end
			
		end
	
	else
		-- reactor is not running
		reactor.signals.parameters["neighbour-bonus"].count = 0
	end

end

-- changes reactor state
function change_reactor_state(new_state, reactor, update_event)
	
	logging("-> changing reactor state to: " .. new_state)
	reactor.state = new_state
	reactor.state_active_since = update_event.tick
	
	-- update reactor state signal
	if reactor.state == "stopped" then
		reactor.signals.parameters["state_stopped"].count = 1
		reactor.signals.parameters["state_starting"].count = 0
		reactor.signals.parameters["state_running"].count = 0
		reactor.signals.parameters["state_scramed"].count = 0
		-- regular reactor
		replace_reactor(reactor,"realistic-reactor")
	elseif reactor.state == "starting" then
		reactor.signals.parameters["state_stopped"].count = 0
		reactor.signals.parameters["state_starting"].count = 1
		reactor.signals.parameters["state_running"].count = 0
		reactor.signals.parameters["state_scramed"].count = 0	
		-- starting reactor
		replace_reactor(reactor,"realistic-reactor-start")
		
	elseif reactor.state == "running" then	
		reactor.signals.parameters["state_stopped"].count = 0
		reactor.signals.parameters["state_starting"].count = 0
		reactor.signals.parameters["state_running"].count = 1
		reactor.signals.parameters["state_scramed"].count = 0
		-- regular reactor
		replace_reactor(reactor,"realistic-reactor")
	elseif reactor.state == "scramed" then	
		reactor.signals.parameters["state_stopped"].count = 0
		reactor.signals.parameters["state_starting"].count = 0
		reactor.signals.parameters["state_running"].count = 0
		reactor.signals.parameters["state_scramed"].count = 1	
		-- regular reactor
		replace_reactor(reactor,"realistic-reactor")
	end
	
end

-- replaces the reactor core entity with another one
function replace_reactor(reactor, new_reactor_entity_name)
	-- realistic-reactor
	-- 100 % power, 100 % fuel efficiency
	-- realistic-reactor-start
	-- 250 % power, 100 % fuel efficiency
	-- realistic-reactor-2
	-- realistic-reactor-3
	-- realistic-reactor-4
	
	logging("Replacing reactor with model: " .. new_reactor_entity_name)
		
	-- get table entry index for reactor to be replaced
	local table_index
	for i,table_reactor in pairs(global.reactors) do
		if table_reactor.id == reactor.id then
			table_index = i
		end
	end
	logging("- old reactor ID: " .. reactor.id)
	logging("- old reactor core ID: " .. reactor.core_id)
	
	-- create new reactor core
	new_reactor_core = reactor.core.surface.create_entity
	{
		name = new_reactor_entity_name,
		position = reactor.core.position,
		force = reactor.core.force		
	}
	logging("- new reactor core ID: " .. new_reactor_core.unit_number)
	
	-- copy everything from old core to new core 
	new_reactor_core.copy_settings(reactor.core) --(what is this actually copying???)
	new_reactor_core.temperature = reactor.core.temperature
	logging("-> updated temperature: " .. new_reactor_core.temperature)
	
	-- transfer burner heat and remaining fuel in burner
	if reactor.state == "stopped" or reactor.state == "scramed" then
		-- do nothing (don't transfer burner heat to a stopped reactor)
		logging("-> burner settings not transferred, state: stopped")
	else
		-- transfer current burner settings
		if reactor.core.burner.heat > 0 then
			new_reactor_core.burner.currently_burning = game.item_prototypes["uranium-fuel-cell"]
			new_reactor_core.burner.heat = reactor.core.burner.heat
			logging("-> updated burner heat: " .. new_reactor_core.burner.heat)
			new_reactor_core.burner.remaining_burning_fuel = reactor.core.burner.remaining_burning_fuel
			logging("-> updated burner remaining_burning_fuel: " .. new_reactor_core.burner.remaining_burning_fuel)
		else
			logging("-> burner settings not transferred, empty")
		end			
	end
	
	-- set minable and active
	if reactor.state == "stopped" then
		new_reactor_core.active = false
		new_reactor_core.minable = true
	elseif reactor.state == "scramed" then
		new_reactor_core.active = false
		new_reactor_core.minable = false	
	else
		new_reactor_core.active = true
		new_reactor_core.minable = false	
	end
	
	-- transfer fuel cells and empty fuel cells
	if reactor.core.get_fuel_inventory().is_empty() == false then
		local fuel = reactor.core.get_fuel_inventory().find_item_stack("uranium-fuel-cell")
		logging("-> moved fuel cells, count: " .. new_reactor_core.get_fuel_inventory().insert(fuel))
	else
		logging("-> no fuel cells moved")
	end
	if reactor.core.get_burnt_result_inventory().is_empty() == false then
		local usedfuel = reactor.core.get_burnt_result_inventory().find_item_stack("used-up-uranium-fuel-cell")
		logging("-> moved used fuel cells, count: " .. new_reactor_core.get_burnt_result_inventory().insert(usedfuel))
	else
		logging("-> no used fuel cells moved")
	end

	-- remove table entry
	table.remove(global.reactors, table_index)
	-- destroy old core
	reactor.core.destroy()
	-- store new core
	reactor.core = new_reactor_core
	--update reactor core id with new core unit_number
	reactor.core_id = new_reactor_core.unit_number
	-- save new table entry
	table.insert(global.reactors, reactor)
	
	logging("-> reactor replaced")
	logging("- new reactor ID: " .. reactor.id)
	logging("- new reactor core ID: " .. reactor.core_id)
end

end


-- FUNCTIONS FOR REACTOR TEMPERATURE CHANGES
do

-- updates reactor core temperature
function update_reactor_temperature(index, update_event)
	logging("---")

	-- load the reactor
	local reactor = global.reactors[index]
	logging("Updating reactor ID: " .. reactor.id)
	logging("Reactor core ID: " .. reactor.core_id)
	logging("Reactor core temperature: " .. reactor.core.temperature)
	

	-- do environment cooling if state is stopped
	if reactor.state == "stopped" then
		if reactor.core.temperature > 15 then
			logging("Reactor state is stopped, apply cooling by the environment")
			
			--[[
			local Tmix_env = ((reactor.core.temperature * REACTOR_MASS) + (15 * 10000)) / (REACTOR_MASS + 10000)
			logging("Tmix_env: " .. Tmix_env)
			local Tdelta_reactor_env = reactor.core.temperature - Tmix_env	
			logging("Tdelta_reactor_env: " .. Tdelta_reactor_env)
			local Tchange_reactor_env = (Tdelta_reactor_env * CHANGE_MULTIPLIER * 0.1)
			logging("-> Tchange_reactor_env: " .. Tchange_reactor_env)
			if (reactor.core.temperature - Tchange_reactor_env) > 15 then
				reactor.core.temperature = reactor.core.temperature - Tchange_reactor_env
			else
				reactor.core.temperature = 15
			end
			]]
			
			if reactor.core.temperature > 15.125 then
				reactor.core.temperature = reactor.core.temperature - 0.125
			else
				reactor.core.temperature = 15
			end
						
			logging("Reactor core temperature after environment cooling: " .. reactor.core.temperature)
		end
	end
	
	-- do decay heat effect if state is scramed
	if reactor.state == "scramed" then
		logging("Reactor state is scramed, apply decay heat effect:")
		reactor.core.temperature = reactor.core.temperature + 0.25
		logging("Reactor core temperature after heat decay effect: " .. reactor.core.temperature)
	end
	
 	-- check fluid level in eccs and do cooling
	logging("Applying ECCS cooling effect")
	if reactor.eccs.fluidbox[1] == nil then
		--do nothing, no coolant
		logging("-> eccs empty")
		
		--reset the coolant fluid signals
		reactor.signals.parameters["coolant-amount"].count = 0
		reactor.signals.parameters["coolant-temperature"].count = 0			
		
	else
		local fluid = reactor.eccs.fluidbox[1]
		logging("- CHANGE_MULTIPLIER: " .. CHANGE_MULTIPLIER)
		logging("- Reactor mass: " .. REACTOR_MASS)
		logging("- Reactor temperature: " .. reactor.core.temperature)
		logging("- Fluid amount: " .. fluid.amount)
		logging("- Fluid temperature: " .. fluid.temperature)
		
		if fluid.amount < 100 then
			--do nothing, not enough coolant
			logging("-> not enough fluid in eccs")
			
			--update the coolant fluid signals
			reactor.signals.parameters["coolant-amount"].count = fluid.amount
			reactor.signals.parameters["coolant-temperature"].count = fluid.temperature			
			
		else
			
			--calculate the mixing temperature with richmann's mixing rule
			local Tmix = ((reactor.core.temperature * REACTOR_MASS) + (fluid.amount * fluid.temperature)) / (REACTOR_MASS + fluid.amount)
			logging("Tmix: " .. Tmix)
			
			-- check which is hotter and cool/heat accordingly
			local Tdelta_reactor = reactor.core.temperature - Tmix
			local Tdelta_fluid = fluid.temperature - Tmix
			logging("Tdelta_reactor: " .. Tdelta_reactor)
			logging("Tdelta_fluid: " .. Tdelta_fluid)
			
			if Tdelta_reactor > Tdelta_fluid then
				-- reactor is hotter than fluid (that is how it should be)
				logging("-> cooling reactor, heating fluid")
				
				local Tchange_reactor = (Tdelta_reactor * CHANGE_MULTIPLIER)
				local Tchange_fluid = (Tdelta_fluid * CHANGE_MULTIPLIER)
				logging("-> Tchange_reactor: " .. Tchange_reactor)
				logging("-> Tchange_fluid: " .. Tchange_fluid)
				
				if fluid.temperature - Tchange_fluid > 100 then
					-- resulting fluid would be too hot (max 100°, set by game), reduce cooling amount
					logging("--> fluid too hot, cooling with reduced efficiency")
					
					--reduce both temperature changes by the same factor, so that resulting fluid is = 100°
					efficiency_factor = (100 - fluid.temperature) / (Tdelta_fluid * CHANGE_MULTIPLIER * -1)
					
					logging("--> efficiency_factor: " .. efficiency_factor)
					logging("--> new Tchange_reactor: " .. Tchange_reactor * efficiency_factor)
					logging("--> new Tchange_fluid: " .. Tchange_fluid * efficiency_factor)
					
					--cool the reactor core
					reactor.core.temperature = reactor.core.temperature - (Tchange_reactor * efficiency_factor)
					--heat the fluid
					fluid.temperature = fluid.temperature - (Tchange_fluid * efficiency_factor)
					
				else
					logging("--> cooling with maximum efficiency")
					--cool the reactor core
					reactor.core.temperature = reactor.core.temperature - Tchange_reactor
					--heat the fluid
					fluid.temperature = fluid.temperature - Tchange_fluid						
				end			
				
			else
				-- fluid is hotter than reactor (it's possible to heat the reactor with a hot fluid)
				logging("-> heating reactor, cooling fluid")
				
				local Tchange_reactor = (Tdelta_reactor * CHANGE_MULTIPLIER)
				local Tchange_fluid = (Tdelta_fluid * CHANGE_MULTIPLIER)
				logging("-> Tchange_reactor: " .. Tchange_reactor)
				logging("-> Tchange_fluid: " .. Tchange_fluid)
				
				if reactor.core.temperature - Tchange_reactor > 100 then
					--do nothing, reactor is already 100°
					-- this is necessary, because theoretically it would be possible to heat the reactor with steam to 1000°, thus causing the meltdown
					logging("--> no change, reactor too hot")
				else
					--heat the reactor core
					reactor.core.temperature = reactor.core.temperature - Tchange_reactor
					--cool the fluid
					fluid.temperature = fluid.temperature - Tchange_fluid					
				end
				
			end
			
			logging("-> Reactor temperature: " .. reactor.core.temperature)
			logging("-> Fluid temperature: " .. fluid.temperature)
			
			--update the coolant fluid signals
			reactor.signals.parameters["coolant-amount"].count = fluid.amount
			reactor.signals.parameters["coolant-temperature"].count = fluid.temperature
			
			--save the fluid back to the eccs
			reactor.eccs.fluidbox[1] = fluid

		end -- not enough coolant
	end --empty eccs
	
	-- update reactor signals
	reactor.signals.parameters["core_temperature"].count = reactor.core.temperature
	
	-- get amount of fuel cells and set signal
	if reactor.core.get_fuel_inventory().is_empty() == true then
		reactor.signals.parameters["uranium-fuel-cells"].count = 0
	else
		reactor.signals.parameters["uranium-fuel-cells"].count = reactor.core.get_fuel_inventory().get_item_count("uranium-fuel-cell")
	end

	-- get amount of used fuel cells and set signal
	if reactor.core.get_burnt_result_inventory().is_empty() == true then
		reactor.signals.parameters["used-uranium-fuel-cells"].count = 0
	else
		reactor.signals.parameters["used-uranium-fuel-cells"].count = reactor.core.get_burnt_result_inventory().get_item_count("used-up-uranium-fuel-cell")
	end		
	
	-- start nuclear meltdown
	if reactor.core.temperature > 998 then
		logging("Core temperature > 998°, MELTDOWN")

		-- destroy the reactor core (will trigger meltdown)
		reactor.core.damage(1000,game.forces.neutral)		
		
	else
		-- show updated signals on interface
		reactor.control.parameters = reactor.signals
	end
	  
end

end


-- FUNCTIONS FOR BUILDING THE LIST OF CONNECTED REACTORS
do

-- updates reactor.connected_neighbours_IDs with the IDs of the current connected reactors
function build_connected_reactors_list(reactor)
	-- find reactor neighbours
	logging("Reactor.id: " .. reactor.id)
	logging("Reactor.core_id: " .. reactor.core_id)
	logging("Reactor position. X: " .. reactor.position.x .. " Y: " .. reactor.position.y)
	local surface = game.surfaces['nauvis']
	local hp_neighbour_entities_ew
	local hp_neighbour_entities_n
	local table_of_heat_pipes_to_check
	
	-- reset global table
	global.connected_reactors = {}	
	global.all_heat_pipes = {}
	-- reset connected_neighbours_IDs and insert own id
	-- (a reactor is always connected with itself)
	reactor.connected_neighbours_IDs = {}
	table.insert(reactor.connected_neighbours_IDs,reactor.id)	
	
	-- load all heat pipes
	global.all_heat_pipes = surface.find_entities_filtered{name='heat-pipe'}
	-- table empty check
	if next(global.all_heat_pipes) == nil then
		logging("-> no heat pipes on map, skipping check")
		--goto end_function
	else
	
		-- find all heat pipes next to reactor
		hp_neighbour_entities_ew = surface.find_entities_filtered{area = {{reactor.position.x-2,reactor.position.y-1},{reactor.position.x+2,reactor.position.y}}, name='heat-pipe'} --east and west
		hp_neighbour_entities_n = surface.find_entities_filtered{area = {{reactor.position.x-1,reactor.position.y-2},{reactor.position.x+1,reactor.position.y-2}}, name='heat-pipe'} -- north
		table_of_heat_pipes_to_check = union_tables(hp_neighbour_entities_ew,hp_neighbour_entities_n)
		
		-- loop through all 7 start heat pipes 
		logging("Checking connected heat pipes")
		if next(table_of_heat_pipes_to_check) == nil then
			logging("-> no heat pipes connected")
		else
			for i,hp in ipairs(table_of_heat_pipes_to_check) do
				logging("- checking heat pipe, ID: " .. hp.unit_number .. " X:" .. hp.position.x .. " Y:" .. hp.position.y)
				
				-- load connected reactors
				local connected_reactors = get_connected_reactors(hp)
				for i,connected_reactor in pairs(connected_reactors) do
					-- check if connected reactor is already in global list
					local is_in_list = false
					for i,list_reactor in pairs(global.connected_reactors) do
						if connected_reactor.id == list_reactor.id then
							-- reactor is already in list
							is_in_list = true
						end
					end
					-- if not add it to list
					if is_in_list == false then
						table.insert(global.connected_reactors,connected_reactor)
						logging("--> found NEW connected reactor, ID: " .. connected_reactor.id)
					end
				end			
				
				-- load connected heat pipes
				local connected_heat_pipes = get_connected_heat_pipes(hp)
				for i,connected_heat_pipe in pairs(connected_heat_pipes) do
					-- check if heat pipe is already in list
					local is_in_list2 = false
					for i,list_heat_pipe in pairs(table_of_heat_pipes_to_check) do
						if connected_heat_pipe.unit_number == list_heat_pipe.unit_number then
							is_in_list2 = true
						end
					end
					-- if not add it to list
					if is_in_list2 == false then
						table.insert(table_of_heat_pipes_to_check,connected_heat_pipe)
						--logging("--> found NEW connected heat pipe, ID: " .. connected_heat_pipe.unit_number)
					end
				end
				
						
			end -- for
			
			-- add connected reactors to list
			reactor.connected_neighbours_IDs = {}
			for i,connected_reactor in pairs(global.connected_reactors) do
				table.insert(reactor.connected_neighbours_IDs,connected_reactor.id)
			end		
			
		end -- no heat pipes connected to reactor
	end -- no heat pipes on map
	
	
	logging("Connected reactors (including self)")
	for k,rid in pairs(reactor.connected_neighbours_IDs) do
		logging("- ID: " .. rid)
	end		
	logging("---")
end

-- returns the connected reactors as array or nil
function get_connected_reactors(heat_pipe)
	local hp = heat_pipe
	local result = {}
	
	for i,reactor in pairs(global.reactors) do
		-- pipes on west reactor side
		if reactor.position.x - 2 == hp.position.x then
			if reactor.position.y == hp.position.y or reactor.position.y - 1 == hp.position.y then
				--logging("--> connected to reactor, ID: " .. reactor.id)
				table.insert(result, reactor)
			end
		end
		-- pipes on east reactor side
		if reactor.position.x + 2 == hp.position.x then
			if reactor.position.y == hp.position.y or reactor.position.y - 1 == hp.position.y then
				--logging("--> connected to reactor, ID: " .. reactor.id)
				table.insert(result, reactor)
			end		
		end		
		-- pipes on north reactor side
		if reactor.position.y - 2 == hp.position.y then
			if reactor.position.x - 1 == hp.position.x
			   or reactor.position.x == hp.position.x
			   or reactor.position.x + 1 == hp.position.x then
					--logging("--> connected to reactor, ID: " .. reactor.id)
					table.insert(result, reactor)
			end
		end		
	end -- for
	
	return result
end

-- returns the connected heat pipes as array or nil
function get_connected_heat_pipes(heat_pipe)
	local hp = heat_pipe
	local result = {}	
	
	for i,hplist in pairs(global.all_heat_pipes) do
		
		if hp.position.x == hplist.position.x then
			if hp.position.y == hplist.position.y + 1 or hp.position.y == hplist.position.y - 1 then
				--logging("--> connected to heat pipe, ID: " .. hplist.unit_number)
				table.insert(result, hplist)
			end
		end
		
		if hp.position.y == hplist.position.y then
			if hp.position.x == hplist.position.x + 1 or hp.position.x == hplist.position.x - 1 then
				--logging("--> connected to heat pipe, ID: " .. hplist.unit_number)
				table.insert(result, hplist)
			end
		end		
		
	end
	
	
	return result
end

end


-- FUNCTIONS FOR COOLING TOWER
do

-- resets the cooling tower steam producing crafting process
function update_cooling_tower(index)
  local tower = global.towers[index]
  if tower and tower.entity.valid then
    -- only show steam puffs if cooling tower is actively working and not backed up
    tower.steam.active = tower.entity.is_crafting() and tower.entity.crafting_progress < 1 
    -- reset steam puff crafting progress so it never actually finishes
	tower.steam.crafting_progress = 0.1 
  end
end

end


-- HELPER FUNCTIONS
do

-- writes a message into the log file
function logging(message)
  	if WRITE_LOG == true then
		game.write_file("RealisticReactors.log","\r\n[" .. game.tick .. "] " .. message,true)
	end
end

-- merges two tables
function union_tables(t1, t2)

   for i,v in ipairs(t2) do
      table.insert(t1, v)
   end 

   return t1
end


function table_length(tbl)
	if tbl == nil then
		return 0
	else
		local count = 0
		for _ in pairs(tbl) do
			count = count + 1
		end
		return count	
	end
end


end






