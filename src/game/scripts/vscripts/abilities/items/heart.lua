item_heart_consumable = class({})

function item_heart_consumable:GetIntrinsicModifierName()
  return "modifier_item_heart_consumable"
end

function item_heart_consumable:OnSpellStart()
  self:ConsumeItem(self:GetCaster())
end

function item_heart_consumable:CastFilterResultTarget(target)
  if self:GetCaster() ~= target then
    return UF_FAIL_CUSTOM
  end
  return UF_SUCCESS
end


function item_heart_consumable:ConsumeItem(hCaster)
  
  local name = self:GetIntrinsicModifierName()
  if not self:GetCaster():HasAbility("ability_consumable_item_container") then
    local ab = self:GetCaster():AddAbility("ability_consumable_item_container")
    ab:SetLevel(1)
    ab:SetHidden(true)
  end
  local ab = self:GetCaster():FindAbilityByName("ability_consumable_item_container")
  if ab and not ab[name] then
    hCaster:RemoveItem(self)
    hCaster:RemoveModifierByName(name)
    local modifier = hCaster:AddNewModifier(hCaster,ab,name,{})
    ab[name] = true
  end
end

LinkLuaModifier("modifier_item_heart_consumable","abilities/items/heart.lua",LUA_MODIFIER_MOTION_NONE)
modifier_item_heart_consumable = class({})

function modifier_item_heart_consumable:GetTexture()
  if self:GetRemainingTime() <= 0 or self:GetRemainingTime() >= 20 then
    return "item_heart"
  else
    return "custom/item_heart_disabled"
  end
end


function modifier_item_heart_consumable:RemoveOnDeath()
  return false
end
function modifier_item_heart_consumable:IsPurgable()
  return false
end
function modifier_item_heart_consumable:IsPermanent()
  return true
end
function modifier_item_heart_consumable:IsHidden()
  return self:GetAbility().IsItem
end
function modifier_item_heart_consumable:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_heart_consumable:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
  }
  return funcs
end

function modifier_item_heart_consumable:GetModifierBonusStats_Strength()
  return self:GetAbility():GetSpecialValueFor("heart_bonus_strength")
end
function modifier_item_heart_consumable:GetModifierHealthBonus()
  return self:GetAbility():GetSpecialValueFor("heart_bonus_health")
end

function modifier_item_heart_consumable:GetModifierHealthRegenPercentage()
  if IsServer() then
    if self:GetRemainingTime() <= 0 or self:GetRemainingTime() >= 20 then
      return self:GetAbility():GetSpecialValueFor("heart_health_regen_rate")
    end
    return 0
  end
end


function modifier_item_heart_consumable:DestroyOnExpire()
  return false
end

function modifier_item_heart_consumable:OnTakeDamage(keys)
  if keys.unit == self:GetCaster() and (keys.attacker:IsHero() or keys.attacker:GetUnitName() == "npc_dota_roshan" )and self:GetCaster():IsRealHero() then
    local cooldown = self:GetAbility():GetSpecialValueFor("heart_cooldown_melee")
    if self:GetCaster():IsRangedAttacker() then
      local cooldown = self:GetAbility():GetSpecialValueFor("heart_cooldown_ranged_tooltip")
    end
    if self:GetAbility():IsItem() then
      if IsServer() then
        self:GetAbility():StartCooldown(cooldown)
      end
    end
    self:SetDuration(cooldown,true)
  end
end


