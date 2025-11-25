--
-- OPie Masque
-- Enables Masque to skin Opie Rings
--
-- Copyright 2022 - 2024 SimGuy
-- Copyright 2013 - 2018 Phanx
--
-- Use of this source code is governed by an MIT-style
-- license that can be found in the LICENSE file or at
-- https://opensource.org/licenses/MIT.
--

local SPECIAL_COLOR_ALPHA = 0.75
-- 0 = invisible, 1 = fully visible, lower it if your skin is ugly

------------------------------------------------------------------------

assert(OPie and OPie.UI, "OPie not found")

local Masque = LibStub("Masque", true)
assert(Masque, "Masque not found")

local group
local prototype = {}
local STATE_USABLE, STATE_NOMANA, STATE_NORANGE, STATE_UNUSABLE = 0, 1, 2, 3

local _, _, _, ver = GetBuildInfo()

function prototype:SetIcon(texture, _)
	-- 2nd argument aspect is not used in our implementation
	self.Icon:SetTexture(texture)
end

function prototype:SetIconAtlas(atlas, _)
	-- 2nd argument aspect is not used in our implementation
	self.Icon:SetAtlas(atlas)
end

function prototype:SetIconTexCoord(a, b, c, d, e, f, g, h)
	if not a or not b or not c or not d then return end -- Broker plugins???
	self.Icon:SetTexCoord(a, b, c, d, e, f, g, h)
end

function prototype:SetIconVertexColor(r, g, b)
	if r == 0.5 and g == 0.5 and b == 0.5 then return end -- don't darken icons on cooldown
	self.icon_r, self.icon_g, self.icon_b = r, g, b
	if self.ustate == STATE_USABLE then
		self.Icon:SetVertexColor(r, g, b)
	end
end

function prototype:SetUsable(usable, _, cd, nomana, norange)
	-- 2nd argument usableCharge is not used in this implementation
	local state = usable and STATE_USABLE or (norange and STATE_NORANGE or (nomana and STATE_NOMANA or STATE_UNUSABLE))
	if state == self.ustate then return end
	self.ustate = state
	if state == STATE_NORANGE then
		self.Icon:SetVertexColor(0.8, 0.1, 0.1)
	elseif state == STATE_NOMANA then
		self.Icon:SetVertexColor(0.5, 0.5, 1)
	elseif state == STATE_UNUSABLE and not cd then -- don't black it out while on cooldown
		self.Icon:SetVertexColor(0.4, 0.4, 0.4)
	else
		self.Icon:SetVertexColor(self.icon_r or 1, self.icon_g or 1, self.icon_b or 1)
	end
end

function prototype:SetDominantColor(r, g, b)
	self.Border:SetShown(2.85 > (r + g + b)) -- don't override skin color if it's white
	self.Border:SetVertexColor(r, g, b)
	self.Border:SetAlpha(SPECIAL_COLOR_ALPHA)

	-- Color the Blizzard Cooldown Text
	local cdtext = select(1, self.Cooldown:GetRegions())
	if cdtext and cdtext.SetTextColor then
		cdtext:SetTextColor(r, g, b)
	end

	for i = 1, #self.GlowTextures do
		self.GlowTextures[i]:SetVertexColor(r, g, b)
	end
end

function prototype:SetOverlayIcon(texture, w, h, ...) -- not entirely sure what this is for
	if not texture then
		self.OverlayIcon:Hide()
	else
		self.OverlayIcon:SetTexture(texture)
		self.OverlayIcon:SetSize(w, h)
		if ... then
			self.OverlayIcon:SetTexCoord(...)
		end
		self.OverlayIcon:Show()
	end
end

function prototype:SetCount(count)
	self.Count:SetText(count or "")
end

local displaySubs = {
	["ALT%-"]      = "a",
	["CTRL%-"]     = "c",
	["SHIFT%-"]    = "s", -- fr, it: "m"
	["BUTTON"]     = "m", -- fr: souris, it: mouse
	["MOUSEWHEEL"] = "w", -- fr: molette, it: rotellina
	["NUMPAD"]     = "n",
	["PLUS"]       = "+",
	["MINUS"]      = "-",
	["MULTIPLY"]   = "*",
	["DIVIDE"]     = "/",
	["DECIMAL"]    = ".",
}
function prototype:SetBinding(text)
	if not text then
		return self.HotKey:SetText("")
	end
	for k, v in pairs(displaySubs) do
		text = gsub(text, k, v)
	end
	self.HotKey:SetText(text)
end

function prototype:SetCooldown(remain, duration, usable)
	local cdtext = select(1, self.Cooldown:GetRegions())
	local r, g, b
	if cdtext:GetObjectType() ~= "FontString" then
		cdtext = nil
	else
		r, g, b = cdtext:GetTextColor()
	end

	if duration and remain and duration > 0 and remain > 0 then
		local start = GetTime() + remain - duration
		-- TODO: detect and show loss of control ?
		if usable then
			-- show recharge time
			self.Cooldown:SetDrawEdge(true)
			self.Cooldown:SetDrawSwipe(false)
		else
			-- show cooldown time
			self.Cooldown:SetDrawEdge(true)
			self.Cooldown:SetDrawSwipe(true)
			self.Cooldown:SetSwipeColor(0, 0, 0, 0.8)
		end
		self.Cooldown:SetCooldown(start, duration)
		self.Cooldown:Show()
		-- Blizzard code just forces the cooldown visible so hide it by making it transparent
		if cdtext then
			if ((usable and not self.RechargeTextShown) or (not usable and not self.CooldownTextShown)) then
				cdtext:SetTextColor(r, g, b, 0)
			else
				cdtext:SetTextColor(r, g, b, 1)
			end
		end
	else
		-- Revert the transparency of the text when cooldown is over
		if cdtext then
			cdtext:SetTextColor(r, g, b, 1)
		end
		self.Cooldown:Hide()
	end
end

function prototype:SetCooldownTextShown(cooldownShown, rechargeShown)
	-- If the Blizzard option Action Bars > Show Numbers for Cooldowns is
	-- disabled, you won't get anything regardless of what's set here
	self.CooldownTextShown, self.RechargeTextShown = cooldownShown, rechargeShown
end

function prototype:SetOverlayIconVertexColor(...)
	self.OverlayIcon:SetVertexColor(...)
end

function prototype:SetHighlighted(highlight)
	self[highlight and "LockHighlight" or "UnlockHighlight"](self)
end

function prototype:SetActive(active)
	self:SetChecked(active)
end

function prototype:SetOuterGlow(shown)
--	if shown then
--		print("GLOW!", self.Icon:GetTexture()) -- IS THIS EVEN USED?
--	end
	for i = 1, #self.GlowTextures do
		self.GlowTextures[i]:SetShown(shown)
	end
end

function prototype:SetEquipState(inBags, isEquipped)
	if isEquipped then
		self.Flash:SetVertexColor(0.1, 0.9, 0.15)
		self.Flash:Show()
	elseif inBags then
		self.Flash:SetVertexColor(1, 0.9, 0.2)
		self.Flash:Show()
	else
		self.Flash:Hide()
	end
end

local id = 0

function prototype:SetQualityOverlay(quality)
	if not self.ProfessionQualityOverlayFrame then
		return
	end
	if quality ~= 0 then
		self.ProfessionQualityOverlayFrame.Texture:SetAtlas("Professions-Icon-Quality-Tier" .. quality .. "-Inv", true)
		self.ProfessionQualityOverlayFrame:Show()
	else
		self.ProfessionQualityOverlayFrame:Hide()
	end
end

local function CreateIndicator(name, parent, size, _)
	-- 4th argument ghost is not used for our implementation
	id = id + 1
	name = name or "OPieSliceButton"..id
	parent = parent or UIParent
	size = size or 36

	local button = CreateFrame("CheckButton", name, parent, "ActionButtonTemplate")
	button:SetSize(size, size)
	button:EnableMouse(false)

	button.Border        = _G[name .. "Border"] -- highlight
	button.Cooldown      = _G[name .. "Cooldown"]
	button.Count         = _G[name .. "Count"]
	button.Flash         = _G[name .. "Flash"] -- inner glow / checked
	button.HotKey        = _G[name .. "HotKey"]
	button.Icon          = _G[name .. "Icon"]
	button.NormalTexture = _G[name .. "NormalTexture"] -- border

	-- Overlay icon
	button.OverlayIcon = button:CreateTexture(nil, "ARTWORK", nil, 1)
	button.OverlayIcon:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 4, 4)

	-- Profession Overlay icon
	-- template was renamed and generalized in 11.2.7
	if ver >= 110207 then
		button.ProfessionQualityOverlayFrame = CreateFrame("Frame", nil, button, "ActionButtonTextureOverlayTemplate")
		button.ProfessionQualityOverlayFrame:SetPoint("TOPLEFT", 14, -14)
        -- template was added in 10.0.0
	elseif ver >= 100000 then
		button.ProfessionQualityOverlayFrame = CreateFrame("Frame", nil, button, "ActionButtonProfessionOverlayTemplate")
		button.ProfessionQualityOverlayFrame:SetPoint("TOPLEFT", 14, -14)
	end

	-- Outer glow (doesn't seem to do anything?)
	button.GlowTextures = {}
	for i = 1, 4 do
		local glow = button:CreateTexture(nil, "BACKGROUND", nil, -8)
		glow:SetSize(size, size)
		glow:SetTexture("Interface\\AddOns\\OPie\\gfx\\oglow")
		glow:Hide()
		button.GlowTextures[i] = glow
	end
	button.GlowTextures[1]:SetPoint("CENTER", button, "TOPLEFT")
	button.GlowTextures[1]:SetTexCoord(0, 1, 0, 1)
	button.GlowTextures[2]:SetPoint("CENTER", button, "TOPRIGHT")
	button.GlowTextures[2]:SetTexCoord(1, 0, 0, 1)
	button.GlowTextures[3]:SetPoint("CENTER", button, "BOTTOMRIGHT")
	button.GlowTextures[3]:SetTexCoord(1, 0, 1, 0)
	button.GlowTextures[4]:SetPoint("CENTER", button, "BOTTOMLEFT")
	button.GlowTextures[4]:SetTexCoord(0, 1, 1, 0)

	for k, v in pairs(prototype) do
		button[k] = v
	end

	-- Let Masque skin it
	if not group then
		group = Masque:Group("OPie")
	end
	group:AddButton(button)

	return button
end

local function onParentAlphaChanged(button, alpha)
	button:SetAlpha(alpha)
end

local OPieParams = {
	name="Masque",
	apiLevel=3,
	CreateIndicator=CreateIndicator,
	supportsCooldownNumbers=true,
	supportsShortLabels=false,
	onParentAlphaChanged=onParentAlphaChanged,
}

OPie.UI:RegisterIndicatorConstructor("masque", OPieParams)
