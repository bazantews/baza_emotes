-------------------------------------------------------------------------------------------------------------------
---------------------------------------------------PROMPT AREA-----------------------------------------------------

local PromptGroup1 = GetRandomIntInRange(0, 0xffffff) 
local PromptConfigured = false

function RegistrarPrompt(str, key)
	local stri = str
	local key = key
	prompt = PromptRegisterBegin()
	PromptSetControlAction(prompt, key) -- add to config
	stri = CreateVarString(10, 'LITERAL_STRING', stri)
	PromptSetText(prompt, stri)
	PromptSetEnabled(prompt, 1)
	PromptSetVisible(prompt, 1)
	PromptSetStandardMode(prompt, 1)
    PromptSetHoldMode(prompt, 2000)
	PromptSetGroup(prompt, PromptGroup1, 0)
	PromptRegisterEnd(prompt)
	for k, v in pairs(Config.Prompts) do
		if k == str then
			v.prompt = prompt
		end
	end
	PromptConfigured = true
end	

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------MAIN AREA---------------------------------------------------------
local ShowPrompt = false
local playingemote = false

Citizen.CreateThread(function()
    while true do Wait(10)
		if IsControlPressed(0, 0x4BC9DABB) then
			ShowPrompt = not ShowPrompt
			--print('Ativado')
		end
		if PromptConfigured then
			if ShowPrompt then
				--print('Aiming')
				if not playingemote then
					local label = CreateVarString(10, 'LITERAL_STRING', "Emotes")
					PromptSetActiveGroupThisFrame(PromptGroup1, label)
					for k, v in pairs(Config.Prompts) do
						if v.configurado then
							--print(v.configurado)
							if Citizen.InvokeNative(0xE0F65F0640EF0617, v.prompt) then
								playingemote = true
								--print(v.emotehash)
								local emote_category = 0
								Citizen.InvokeNative(0xB31A277C1AC7B7FF,PlayerPedId(),emote_category,2,GetHashKey(v.emotehash),0,0,0,0,0)  -- FULL BODY EMOTE
								Wait(2000)
								playingemote = false
							end
						end
					end
				end
			end
		end
   end
end)

RegisterCommand('smo', function(source,args)
	OpenMenuF()
end)

function TestarEmote(EmoteHash)
	local Hash = EmoteHash
	Citizen.InvokeNative(0xB31A277C1AC7B7FF, PlayerPedId(), 0, 2, GetHashKey(Hash), 0, 0, 0, 0 ,0)
end