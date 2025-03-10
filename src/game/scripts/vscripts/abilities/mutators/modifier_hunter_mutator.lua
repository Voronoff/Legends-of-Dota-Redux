--=======================================================================================
-- Generated by TypescriptToLua transpiler https://github.com/Perryvw/TypescriptToLua 
-- Date: Sun May 13 2018
--=======================================================================================
require("typescript_lualib")
LinkLuaModifier("modifier_day_night","abilities/mutators/modifier_hunter_mutator.lua",LUA_MODIFIER_MOTION_NONE)
modifier_hunter_mutator = {}
modifier_hunter_mutator.__index = modifier_hunter_mutator
function modifier_hunter_mutator.new(construct, ...)
    local instance = setmetatable({}, modifier_hunter_mutator)
    if construct and modifier_hunter_mutator.constructor then modifier_hunter_mutator.constructor(instance, ...) end
    return instance
end
function modifier_hunter_mutator.IsPermanent(self)
    return true
end
function modifier_hunter_mutator.IsPurgable(self)
    return false
end

function modifier_hunter_mutator.GetTexture(self)
    return "custom/modifier_hunter_mutator"
end

function modifier_hunter_mutator.OnCreated(self)
    self.daytime_hp_drain=1
    self.night_lifesteal=20
    self.night_bonus_ms = 10
    self.night_mana_regen = 1

    if IsServer() then
        self:StartIntervalThink(FrameTime())

        self:GetParent():AddNewModifier(self:GetParent(),nil,"modifier_day_night",{})
    end
end

function modifier_hunter_mutator.OnIntervalThink(self)
    self.dayTime = GameRules:IsDaytime()
    self.oldDayTime = self.oldDayTime or self.dayTime

    if self.dayTime ~= self.oldDayTime then
        if self.dayTime == false then
            Notifications:Top(self:GetParent():GetPlayerOwner(),{text="THE DAY IS OVER!",duration = 5})
        else
            Notifications:Top(self:GetParent():GetPlayerOwner(),{text="THE DAY HAS COME!",duration = 5})
        end
    end
    self.oldDayTime = self.dayTime

end

function modifier_hunter_mutator.DeclareFunctions(self)
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,  
    }
end

function modifier_hunter_mutator.GetModifierMoveSpeedBonus_Percentage(self)
   
    if self:GetParent():GetModifierStackCount("modifier_day_night",self:GetParent()) == 1 then
        return 0
    else 
        return self.night_bonus_ms
    end
end

function modifier_hunter_mutator.GetModifierHealthRegenPercentage(self)
    if self:GetParent():GetModifierStackCount("modifier_day_night",self:GetParent()) == 1 then
        return -1
    else 
        return 1
    end
end

function modifier_hunter_mutator.GetModifierTotalPercentageManaRegen(self)
    if self:GetParent():GetModifierStackCount("modifier_day_night",self:GetParent()) == 1 then
        return 0
    else 
        return 1
    end
end

function modifier_hunter_mutator.OnTakeDamage(self,kv)
    if GameRules:IsDaytime() then
        return
    end
    local damage_flags = kv.damage_flags
    
    if bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
        return 
    end
    if bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
        return 
    end

    self.night_lifesteal = self.night_lifesteal or 20
    if (self:GetParent()==kv.attacker) and kv.unit:IsAlive() then
        if not kv.unit:IsOther() and not kv.unit:IsBuilding() then
            self:GetParent():Heal((kv.damage*self.night_lifesteal)*0.01,self:GetParent())
            local p
            if not kv.inflictor then
                p = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",PATTACH_OVERHEAD_FOLLOW,self:GetParent())
            else
                p = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN, self:GetParent())
            end
            ParticleManager:ReleaseParticleIndex(p)

        end
    end
end


modifier_day_night = class({})
function modifier_day_night:IsHidden() return true end
function modifier_day_night:IsPermanent() return true end
 
function modifier_day_night:OnCreated()
    if IsServer() then
        self:StartIntervalThink(FrameTime())
    end
end

function modifier_day_night:OnIntervalThink()
    if GameRules:IsDaytime() then
        self:SetStackCount(0)
    else
        self:SetStackCount(1)
    end
end