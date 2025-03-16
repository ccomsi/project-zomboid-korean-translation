--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISRemoveHeadFromAnimal = ISBaseTimedAction:derive("ISRemoveHeadFromAnimal");

function ISRemoveHeadFromAnimal:isValid()
	return self.body ~= nil and not self.body:getModData()["headless"];
end

function ISRemoveHeadFromAnimal:waitToStart()
	if self.hook then
		self.character:faceThisObject(self.hook)
	elseif self.body and self.body:isExistInTheWorld() then
		self.character:faceThisObject(self.body)
	end
	return self.character:shouldBeTurning()
end

function ISRemoveHeadFromAnimal:update()
	if self.hook then
		self.character:faceThisObject(self.hook)
	elseif self.body and self.body:isExistInTheWorld() then
		self.character:faceThisObject(self.body)
	end

	-- update the hook UI
	if self.luaHook then
		self.luaHook.doingAction = true;
		self.luaHook.actionText = getText("IGUI_Animal_RemovingHead");
		self.luaHook:updateProgressBar(self:getJobDelta());
	end
end

function ISRemoveHeadFromAnimal:start()
	self:setActionAnim("Loot")
	--self.character:SetVariable("LootPosition", "Low")
	self.character:reportEvent("EventLootItem")
end

function ISRemoveHeadFromAnimal:stop()
	self.luaHook.doingAction = false;

    ISBaseTimedAction.stop(self);
end

function ISRemoveHeadFromAnimal:perform()
	self.luaHook.doingAction = false;

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISRemoveHeadFromAnimal:complete()
	self.luaHook.doingAction = false;

	-- add possible blood on character
	local bloodNb = ZombRand(22 - (self.perkLevel * 2));

	-- if animal still had blood in it, add lots more
	local bloodGround = 0;
	if self.body:getModData()["BloodQty"] > 0 then
		bloodNb = bloodNb + self.body:getModData()["BloodQty"] * 2
		bloodGround = self.body:getModData()["BloodQty"] * 2;
	end

	for i=0,bloodNb do
		self.character:addBlood(nil, true, false, false);
	end

	for i=0,bloodGround do
		addBloodSplat(self.hook:getSquare(), 2, ZombRandFloat(-0.3, 0.3), ZombRandFloat(-0.3, 0.3))
	end

	-- if the animal is rotten you don't get a head but a skull
	local head = ButcheringUtil.getHead(self.body:getTypeAndBreed());
	local skull = ButcheringUtil.getSkull(self.body:getTypeAndBreed());
	if head and self.body:getModData()["head"] then
		local headItem = instanceItem(head);
		if self.body:getModData()["animalRotStage"] > 0 then
			headItem:setAge(ZombRand(headItem:getOffAgeMax() + 3, headItem:getOffAgeMax() * 1.5));
		end
		self.character:getInventory():AddItem(headItem);
	elseif skull then
		local skullItem = self.character:getInventory():AddItem(skull);
	end

	addXp(self.character, Perks.Butchering, self.xp);
	self.body:getModData()["head"] = nil;
	self.body:getModData()["headless"] = true;
	self.hook:getAnimal():getModData()["headless"] = true;
	-- don't try and change the model on the fly it makes things weiiiird, so i'm recreating stuff
	self.luaHook:resetCorpse();
	self.luaHook:updateCorpseDatas();

	return true
end

function ISRemoveHeadFromAnimal:getDuration()
	if self.character:isTimedActionInstant() then
		return 1
	end
	return 250 - (self.perkLevel * 10);
end

function ISRemoveHeadFromAnimal:new(character, body, hook, luaHook)
	local o = ISBaseTimedAction.new(self, character)
	o.body = body;
	o.hook = hook;
	o.luaHook = luaHook;
	o.animalDef = ButcheringUtil.getAnimalDef(body:getTypeAndBreed())
	o.perkLevel = character:getPerkLevel(Perks.Butchering);
	o.xp = o.animalDef.xpPerItem;
	o.maxTime = o:getDuration()
	return o;
end
