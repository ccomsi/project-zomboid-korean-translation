--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISUnloadBulletsFromMagazine = ISBaseTimedAction:derive("ISUnloadBulletsFromMagazine")

function ISUnloadBulletsFromMagazine:isValid()
	if isClient() and self.magazine then
		return self.character:getInventory():containsID(self.magazine:getID())
	else
		return self.character:getInventory():contains(self.magazine)
	end
end

function ISUnloadBulletsFromMagazine:start()
	if isClient() and self.magazine then
		self.magazine = self.character:getInventory():getItemById(self.magazine:getID())
	end
	self.magazine:setJobType(getText("ContextMenu_UnloadMagazine"))
	self.ammoCountStart = self.magazine:getCurrentAmmoCount()
	if self.ammoCountStart == 0 then
		self:forceComplete()
		return
	end
	self.magazine:setJobDelta(0.0)
	self:setOverrideHandModels(nil, "GunMagazine")
	self:setActionAnim(CharacterActionAnims.RemoveBullets)
	self:initVars()
end

function ISUnloadBulletsFromMagazine:update()
	self.magazine:setJobDelta((self.ammoCountStart - self.magazine:getCurrentAmmoCount()) / self.ammoCountStart)
	if self.unloadFinished then
		self.magazine:setCurrentAmmoCount(0)
		self:forceComplete()
		return
	end
	self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function ISUnloadBulletsFromMagazine:initVars()
	ISReloadWeaponAction.setReloadSpeed(self.character, false)
end

function ISUnloadBulletsFromMagazine:serverStop()
	self.netAction:forceComplete()
end

function ISUnloadBulletsFromMagazine:serverStart()
	self:initVars()
	emulateAnimEvent(self.netAction, 500, "RemoveBullet", nil)
	emulateAnimEvent(self.netAction, 550, "unloadFinished", nil)
end

function ISUnloadBulletsFromMagazine:getDuration()
	return -1
end

function ISUnloadBulletsFromMagazine:complete()
	return true
end

function ISUnloadBulletsFromMagazine:animEvent(event, parameter)
	if event == 'RemoveBulletSound' then
		if self.magazine:getCurrentAmmoCount() <= 0 then
			-- Fix for looping animation events arriving after loading finished.
			-- That's why 'PlaySound' isn't used instead.
			return
		end
		self.character:playSound(parameter)
	elseif event == 'RemoveBullet' then
		if self.magazine:getCurrentAmmoCount() <= 0 then
			return
		end
		if not isClient() then
			local newBullet = instanceItem(self.magazine:getAmmoType())
			self.character:getInventory():AddItem(newBullet)
			self.magazine:setCurrentAmmoCount(self.magazine:getCurrentAmmoCount() - 1)
			sendAddItemToContainer(self.character:getInventory(), newBullet)
			syncItemFields(self.character, self.magazine)
		end
		self.unloadFinished = false
	elseif event == 'unloadFinished' then
		if self.magazine:getCurrentAmmoCount() <= 0 then
			self.unloadFinished = true
			if isServer() then
				self.netAction:forceComplete()
			end
		end
	end
end

function ISUnloadBulletsFromMagazine:stop()
	self.magazine:setJobDelta(0.0)
	ISBaseTimedAction.stop(self)
end

function ISUnloadBulletsFromMagazine:perform()
	self.magazine:setJobDelta(0.0)
	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self)
end

function ISUnloadBulletsFromMagazine:new(character, magazine)
	local o = ISBaseTimedAction.new(self, character)
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = o:getDuration()
	o.magazine = magazine
	o.useProgressBar = false
	return o
end
