--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

ISNaturalFloor = ISBuildingObject:derive("ISNaturalFloor");

--************************************************************************--
--** ISNaturalFloor:new
--**
--************************************************************************--
function ISNaturalFloor:create(x, y, z, north, sprite)
    showDebugInfoInChat("Cursor Create \'ISNaturalFloor\' "..tostring(x)..", "..tostring(y)..", "..tostring(z)..", "..tostring(north)..", "..tostring(sprite))
	self.sq = getWorld():getCell():getGridSquare(x, y, z);
	local floor = self.sq:getFloor()
	local spriteNames = floor:getModData().shovelledSprites or ISNaturalFloor.getFloorSpriteNames(self.sq)
	self.javaObject = self.sq:addFloor(sprite);
	self.javaObject:getModData().shovelled = nil
	self.javaObject:getModData().pouredFloor = self:getFloorType(self.item);
	if spriteNames and #spriteNames > 0 then
		self.javaObject:getModData().shovelledSprites = copyTable(spriteNames)
	end
	self.javaObject:transmitCompleteItemToClients()
	self.item:UseAndSync()
	-- bag is empty, we'll try to find another one
	local playerInv = self.character:getInventory()
	if not playerInv:containsRecursive(self.item) then
		self.item = playerInv:getFirstTypeRecurse(self.item:getFullType())
	end
	if not isServer() then
		-- refresh backpacks to show equipped empty dirt bags
		getPlayerInventory(self.character:getPlayerNum()):refreshBackpacks();
		getPlayerLoot(self.character:getPlayerNum()):refreshBackpacks();
	end
end

function ISNaturalFloor:new(sprite, northSprite, item, character)
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o:init();
	o:setSprite(sprite);
	o:setNorthSprite(northSprite);
	o.item = item;
	o.itemType = item:getFullType()
    o.character = character;
    o.player = character:getPlayerNum()
    o.noNeedHammer = true;
    o.actionAnim = CharacterActionAnims.Pour;
	o.floorType = o:getFloorType(item);
	o.craftingBank = "DropSoilFromDirtBag";
	if o.floorType == "gravel" then
		o.craftingBank = "DropSoilFromGravelBag";
	elseif o.floorType == "sand" then
		o.craftingBank = "DropSoilFromSandBag";
	end
    showDebugInfoInChat("Cursor New \'ISNaturalFloor\'")
	return o;
end

function ISNaturalFloor:isValid(square)
	local playerInv = self.character:getInventory()
	if CFarmingSystem.instance:getLuaObjectOnSquare(square) then
		return false
	end
	if square and square:getProperties() then
		local props = square:getProperties();
		if props:Is(IsoFlagType.water) then
			return false;
		end
	end
	if square then
		local squareFloor = square:getFloor();
		if squareFloor and squareFloor:hasModData() and squareFloor:getModData().pouredFloor and squareFloor:getModData().pouredFloor == self.floorType then
			return false;
		end
	end

	if self.item ~= nil and square ~= nil and square:getFloor() ~= nil then
		if playerInv:containsRecursive(self.item) then
			return true
		else
			self.item = playerInv:getFirstTypeRecurse(self.itemType)
			return self.item ~= nil
		end
	end
	return false
end

function ISNaturalFloor:render(x, y, z, square)
	ISBuildingObject.render(self, x, y, z, square)

	local hc = getCore():getGoodHighlitedColor()
	if not self:isValid(square) then
		hc = getCore():getBadHighlitedColor()
	end
	self:getFloorCursorSprite():RenderGhostTileColor(x, y, z, hc:getR(), hc:getG(), hc:getB(), 0.8)
end

function ISNaturalFloor:walkTo(x, y, z)
	if ISBuildingObject.walkTo(self, x, y, z) then
		ISWorldObjectContextMenu.transferIfNeeded(self.character, self.item)
		return true
	end
	return false
end

function ISNaturalFloor:getFloorType(item)
	if not item then
		return "none";
	end
	if item:getFullType()=="Base.Gravelbag" then
		return "gravel";
	elseif item:getFullType()=="Base.Dirtbag" then
		return "dirt";
	elseif item:getFullType()=="Base.Sandbag" then
		return "sand";
	elseif item:getFullType()=="Base.Claybag" then
    	return "clay";
    end
end

function ISNaturalFloor.getFloorSpriteNames(square)
	local sprites = {}
	local floor = square:getFloor()
	if floor then
		local sprite = floor:getSprite()
		if sprite and sprite:getName() then
			table.insert(sprites, sprite:getName())
			local attached = floor:getAttachedAnimSprite()
			if attached then
				for i=1,attached:size() do
					sprite = attached:get(i-1):getParentSprite()
					if sprite and sprite:getName() then
						table.insert(sprites, sprite:getName())
					end
				end
			end
		end
	end
	return sprites
end

