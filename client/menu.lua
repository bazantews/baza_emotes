FeatherMenu =  exports['feather-menu'].initiate()
local VORPcore = exports.vorp_core:GetCore()

local ActualPage = 0 

local function TableToString(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. TableToString(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

function OpenMenuF(Page)
	MyMenu = FeatherMenu:RegisterMenu('Baza:Emotes', {
		top = '40%',
		left = '20%',
		['720width'] = '500px',
		['1080width'] = '600px',
		['2kwidth'] = '700px',
		['4kwidth'] = '900px',
		style = {
		},
		contentslot = {
			style = {
				['height'] = '300px',
				['min-height'] = '300px'
			}
		},
		draggable = true
	})
	local MyFirstPage = MyMenu:RegisterPage('first:page')

	------ FIRST PAGE CONTENT  ------
	MyFirstPage:RegisterElement('header', {
		value = 'Emotes',
		slot = "header",
		style = {}
	})

	MyFirstPage:RegisterElement('subheader', {
		value = "Selecione Seus Emotes",
		slot = "header",
		style = {}
	})

	MyFirstPage:RegisterElement('line', {
		slot = "header",
	})

    MyFirstPage:RegisterElement('button', {
        label = Config.Buy,
        style = {
        },
    sound = {
        action = "SELECT",
        soundset = "RDRO_Character_Creator_Sounds"
        },
    }, function()
        BuyPage()
    end)

    MyFirstPage:RegisterElement('button', {
        label = Config.ConfigurarEmotes,
        style = {
        },
    sound = {
        action = "SELECT",
        soundset = "RDRO_Character_Creator_Sounds"
        },
    }, function()
        ConfigMenuEmotes()
    end)

	MyFirstPage:RegisterElement('bottomline')


	MyFirstPage:RegisterElement('line', {
		slot = "footer",
	}) 
        
    MyMenu:Open({
        cursorFocus = true,
        menuFocus = true,
        startupPage = MyFirstPage
    })
end


-------------------------------------------------------MENUS DE COMPRA----------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

local EmoteName = nil
local EmoteHash = nil
local EmotePrice = 0

function BuyPage()
    BuyMenu = FeatherMenu:RegisterMenu('Baza:BuyMenu', {
        top = '40%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
        },
        contentslot = {
            style = {
                ['height'] = '300px',
                ['min-height'] = '300px'
            }
        },
        draggable = true
    })
    local BuyPageF = BuyMenu:RegisterPage('BuyPage')

    BuyPageF:RegisterElement('header', {
        value = Config.Buy,
        slot = "header",
        style = {}
    })

    BuyPageF:RegisterElement('subheader', {
        value = "Selecione o Emote",
        slot = "header",
        style = {}
    })

    BuyPageF:RegisterElement('line', {
        slot = "header",
    })

    local ResourceName = GetCurrentResourceName()
    for k, v in pairs(Config.EmotesList) do
        BuyPageF:RegisterElement('button', {
            label = " ",
            style = {
                ['background-image'] = string.format('url("nui://baza_emotes/images/%s.png")', v.imagename),
                ['height'] = '100px',
                ['width'] = '200px'
            },
            sound = {
                action = "SELECT",
                soundset = "RDRO_Character_Creator_Sounds"
           },
        }, function()
            EmoteName = k
            EmoteHash = v.emotehash
            EmotePrice = v.price
            --print('Emote Name '..EmoteName)
            --print('Emote Name '..EmoteHash)
            --print('Emote Name '..EmotePrice)
            BuyPage2()
        end)
    end

    BuyPageF:RegisterElement('button', {
        label = 'Voltar',
        style = {
        }
    }, function()
        ActualPage = 2
        OpenMenuF(ActualPage)
    end)

    BuyMenu:Open({
        -- cursorFocus = false,
        -- menuFocus = false,
        startupPage = BuyPageF
    })
end

function BuyPage2()
    BuyMenu2 = FeatherMenu:RegisterMenu('Baza:BuyMenu2', {
        top = '40%',
        left = '20%',
        ['720width'] = '500px',
        ['1080width'] = '600px',
        ['2kwidth'] = '700px',
        ['4kwidth'] = '900px',
        style = {
        },
        contentslot = {
            style = {
                ['height'] = '300px',
                ['min-height'] = '300px'
            }
        },
        draggable = true
    })
    local BuyPage2 = BuyMenu2:RegisterPage('BuyPage2')

    BuyPage2:RegisterElement('header', {
        value = Config.Buy,
        slot = "header",
        style = {}
    })

    BuyPage2:RegisterElement('subheader', {
        value = EmoteName,
        slot = "header",
        style = {}
    })

    BuyPage2:RegisterElement('line', {
        slot = "header",
    })

    BuyPage2:RegisterElement('button', {
        label = Config.Comprar ..EmotePrice,
        style = {
            
        },
        sound = {
            action = "SELECT",
            soundset = "RDRO_Character_Creator_Sounds"
        },
        }, function()
            --print(EmotePrice)
            VORPcore.Callback.TriggerAwait("BazaEmote:Comprar", EmotePrice, EmoteHash)
    end)

    BuyPage2:RegisterElement('button', {
        label = Config.Test,
        style = {
            
        },
        sound = {
            action = "SELECT",
            soundset = "RDRO_Character_Creator_Sounds"
        },
        }, function()
            TestarEmote(EmoteHash)
    end)

    BuyPage2:RegisterElement('button', {
        label = 'Voltar',
        style = {
            
        },
        sound = {
            action = "SELECT",
            soundset = "RDRO_Character_Creator_Sounds"
        },
        }, function()
            BuyPage()    
    end)

    BuyMenu2:Open({
        -- cursorFocus = false,
        -- menuFocus = false,
        startupPage = BuyPage2
    })
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------MENU CONFIGURAR EMOTES-------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ConfigMenuEmotes()
    local emotes = VORPcore.Callback.TriggerAwait("BazaEmote:CheckEmotes") 
    if #emotes > 0 then
        ConfigMenu = FeatherMenu:RegisterMenu('Baza:EmotesConfig', {
            top = '40%',
            left = '20%',
            ['720width'] = '500px',
            ['1080width'] = '600px',
            ['2kwidth'] = '700px',
            ['4kwidth'] = '900px',
            style = {
            },
            contentslot = {
                style = {
                    ['height'] = '300px',
                    ['min-height'] = '300px'
                }
            },
            draggable = true
        })
        local MyFirstPage = ConfigMenu:RegisterPage('first:page')
        local MySecondPage = ConfigMenu:RegisterPage('second:page')

        ------ FIRST PAGE CONTENT  ------
        MyFirstPage:RegisterElement('header', {
            value = 'Emotes',
            slot = "header",
            style = {}
        })

        MyFirstPage:RegisterElement('subheader', {
            value = "Configure Seus Emotes",
            slot = "header",
            style = {}
        })

        MyFirstPage:RegisterElement('line', {
            slot = "header",
        })

        for k, v in pairs(Config.EmotesList) do
            for km, vm in pairs(emotes) do
                if v.emotehash == vm then
                    MyFirstPage:RegisterElement('button', {
                        label = k,
                        style = {
                        },
                    sound = {
                        action = "SELECT",
                        soundset = "RDRO_Character_Creator_Sounds"
                        },
                    }, function()
                        EmoteHash = vm
                        MySecondPage:RouteTo()
                    end)
                end
            end
        end

        MyFirstPage:RegisterElement('button', {
            label = 'Voltar',
            style = {
                
            },
            sound = {
                action = "SELECT",
                soundset = "RDRO_Character_Creator_Sounds"
            },
            }, function()
                OpenMenuF()    
        end)

        MyFirstPage:RegisterElement('bottomline')


        MyFirstPage:RegisterElement('line', {
            slot = "footer",
        }) 

         ------ SECOND PAGE CONTENT  ------
        MySecondPage:RegisterElement('header', {
            value = 'Selecione o Prompt',
            slot = "header",
            style = {}
        })

        MySecondPage:RegisterElement('line', {
            slot = "header",
        })

        MySecondPage:RegisterElement('line', {
            slot = "footer",
        })
        
        for pro, pt in pairs(Config.Prompts) do
            MySecondPage:RegisterElement('button', {
                label = pro,
                style = {
                },
            sound = {
                action = "SELECT",
                soundset = "RDRO_Character_Creator_Sounds"
                },
            }, function()
                RegistrarPrompt(pro, pt.prompthtk)     
                pt.emotehash = EmoteHash
                pt.configurado = true
                --print(pt.emotehash)     
            end)
        end

        MySecondPage:RegisterElement('button', {
            label = 'Voltar',
            style = {
                
            },
            sound = {
                action = "SELECT",
                soundset = "RDRO_Character_Creator_Sounds"
            },
            }, function()
                MyFirstPage:RouteTo()    
        end)
            
        ConfigMenu:Open({
            cursorFocus = true,
            menuFocus = true,
            startupPage = MyFirstPage
        })
    end
end