--=======================================================================================
-- Generated by TypescriptToLua transpiler https://github.com/Perryvw/TypescriptToLua 
-- Date: Sun May 13 2018
--=======================================================================================
require("typescript_lualib")
--LinkLuaModifier("modifier_drop_gold_bag_mutator","",LUA_MODIFIER_MOTION_NONE)
modifier_drop_gold_bag_mutator = {}
modifier_drop_gold_bag_mutator.__index = modifier_drop_gold_bag_mutator
function modifier_drop_gold_bag_mutator.new(construct, ...)
    local instance = setmetatable({}, modifier_drop_gold_bag_mutator)
    if construct and modifier_drop_gold_bag_mutator.constructor then modifier_drop_gold_bag_mutator.constructor(instance, ...) end
    return instance
end
function modifier_drop_gold_bag_mutator.IsPermanent(self)
    return true
end
function modifier_drop_gold_bag_mutator.IsPurgable(self)
    return false
end
function modifier_drop_gold_bag_mutator.IsHidden(self)
    return true
end
function modifier_drop_gold_bag_mutator.DeclareFunctions(self)
    return {MODIFIER_EVENT_ON_DEATH}
end
function modifier_drop_gold_bag_mutator.OnDeath(self,kv)
    if self:GetParent()==kv.unit then
        local newItem = CreateItem("item_bag_of_gold",nil,nil)
        newItem:SetCurrentCharges(1000)
        local item = CreateItemOnPositionSync(self:GetParent():GetAbsOrigin(),newItem)
        item:SetModel("models/props_gameplay/gold_bag.vmdl")
    end
end
