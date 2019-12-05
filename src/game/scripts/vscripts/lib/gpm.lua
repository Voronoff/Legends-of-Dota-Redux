function GpmInit()
	-- Every X time all heroes get N gold
	local goldModifier = OptionManager:GetOption('goldModifier')
	local timeToBaseGPM = 0.275
	local baseGoldPerTick = 1*(goldModifier/100)

	-- Every X time all heroes get N*LEVELHERO gold (example, if the hero level is 30, it get 60 gold per minute)
	local timeAdditionalGPM = 60
	local goldPerLevelGpmInMinute = 2*(goldModifier/100)

	Timers:CreateTimer(function()
		local all_heroes = HeroList:GetAllHeroes()
		for _, hero in pairs(all_heroes) do
			if hero:IsRealHero() then
				hero:ModifyGold(baseGoldPerTick, false, 0)
			end
		end
		return timeToBaseGPM
	end)
	Timers:CreateTimer(function()
		local all_heroes = HeroList:GetAllHeroes()
		for _, hero in pairs(all_heroes) do
			if hero:IsRealHero() then
				hero:ModifyGold(hero:GetLevel() * goldPerLevelGpmInMinute, false, 0)
			end
		end
		return timeAdditionalGPM
	end)
end



