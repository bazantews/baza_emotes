local VORPcore = exports.vorp_core:GetCore()

VORPcore.Callback.Register("BazaEmote:Comprar", function(source, callback, Valor, EmoteHash)
    local Valor = Valor
    local Hash = EmoteHash

    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local Identificador = Character.identifier
    local Money = Character.money

    local emotes = {}
    local EmoteDif = false

    local EmotesTable = MySQL.query.await('SELECT * FROM baza_emotes WHERE `identifier` = ?', { Identificador })
    if #EmotesTable > 0 then
        for k,v in pairs(EmotesTable) do
            if v.identifier == Identificador then
                emotes = json.decode(v.emotes)
                for tab, emot in pairs(emotes) do
                    if emot ~= EmoteHash then
                        EmoteDif = true
                    else
                        VORPcore.NotifyLeft(_source, "Emotes", "Você já tem este emote!", "menu_textures", "log_gang_bag",5000,"COLOR_GREEN")
                        EmoteDif = false
                        break
                    end
                end
                if EmoteDif then
                    if Money >= Valor then
                        table.insert(emotes, #emotes + 1, EmoteHash)
                        print(json.encode(emotes))
                        MySQL.query.await('UPDATE baza_emotes SET `emotes` = ? WHERE `identifier` = ?', { json.encode(emotes), Identificador })
                        VORPcore.NotifyLeft(_source, "Emotes", "Você comprou um emote!", "menu_textures", "log_gang_bag",5000,"COLOR_GREEN")
                        Character.removeCurrency(0, Valor)
                    else
                        VORPcore.NotifyLeft(_source, "Emotes", "Você não tem dinheiro suficiente!", "menu_textures", "log_gang_bag",5000,"COLOR_GREEN")
                    end
                end
            end
        end
    else
        if Money >= Valor then
            table.insert(emotes, #emotes + 1, Hash)
            MySQL.query.await('INSERT INTO baza_emotes (`identifier`, `emotes`) VALUES (?, ?)',
            { Identificador, json.encode(emotes) })
            VORPcore.NotifyLeft(_source, "Emotes", "Você comprou um Emote!", "menu_textures", "log_gang_bag",5000,"COLOR_GREEN")
            Character.removeCurrency(0, Valor)
        else
            VORPcore.NotifyLeft(_source, "Emotes", "Você não tem dinheiro suficiente!", "menu_textures", "log_gang_bag",5000,"COLOR_GREEN")
        end
    end
end)

VORPcore.Callback.Register("BazaEmote:CheckEmotes", function(source, callback)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local Identificador = Character.identifier
    local EmotesTable = MySQL.query.await('SELECT * FROM baza_emotes WHERE `identifier` = ?', { Identificador })
    local tabela = {}
    for k, v in pairs(EmotesTable) do
        tabela = json.decode(v.emotes)
    end
    callback(tabela)
end)