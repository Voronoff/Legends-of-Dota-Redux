if spell_lab_survivor_str_survival == nil then
	spell_lab_survivor_str_survival = class({})
end

LinkLuaModifier("spell_lab_survivor_str_survival_modifier", "abilities/spell_lab/survivor/str_survival.lua", LUA_MODIFIER_MOTION_NONE)

function spell_lab_survivor_str_survival:GetIntrinsicModifierName() return "spell_lab_survivor_str_survival_modifier" end


if spell_lab_survivor_str_survival_modifier == nil then
	spell_lab_survivor_str_survival_modifier = require "abilities/spell_lab/survivor/base"
end

function spell_lab_survivor_str_survival_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function spell_lab_survivor_str_survival_modifier:GetModifierBonusStats_Strength()
if self:GetParent():PassivesDisabled() then return 0 end
return self:GetStackCount()
end
