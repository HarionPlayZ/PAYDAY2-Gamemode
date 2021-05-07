-- Returns the closest player on the team relative to the entity being passed
-- @param team_id number: player team
-- @param ent entity: entity that is being calculated
-- @return player or (nil): found closest player relative to entity. if the player is not found, it will return a nil, and no other arguments will be received.
-- @return number or (nil): distance of the found player to the target entity
function pd2_helpers.GetClosestPlayerByTeamWithEntity(team_id, ent)
	assert(isnumber(team_id), 'The passed argument 1 (team_id) must be of type - number!')
	assert(IsEntity(ent), 'The passed argument 2 (ent) must be of type - Entity!')

	local valid_players = {}
	local real_players = player.GetHumans()

	for i = 1, #real_players do
		local ply = real_players[i]
		if ply:Alive() and ply:Team() == team_id then table.insert(valid_players, ply) end
	end

	if #valid_players == 0 then return end

	local dist = nil
	local closest_player = nil
	local ent_position = ent:GetPos()

	for i = 1, #valid_players do
		local ply = valid_players[i]
		local player_position = ply:GetPos()
		local dist_calculate = player_position:DistToSqr(ent_position)

		if dist == nil or dist_calculate < dist then
			closest_player = ply
			dist = dist_calculate
		end
	end

	if not closest_player then return end

	return closest_player, dist
end