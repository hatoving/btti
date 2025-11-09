-- Miku
SMODS.Atlas {
    key = "Miku",
    path = "bttiHatsuneMiku.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Miku',
    loc_txt = {
        name = 'Hatsune Miku',
        text = {
            "{C:chips}+5{} Chips for every",
            "{C:clubs}Club{} currently in {C:attention}full deck",
            "{C:inactive}(Currently +{C:chips}#1#{C:inactive} Chips)"
        }
    },

    config = { extra = { chips = 2 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "VOCALOID", "Crypton Future Media, INC.", "hatoving" } }
        local cardCount = 0
        if G.deck and G.deck.cards then
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Clubs') then
                    cardCount = cardCount + 1
                end
            end
        end
        return {
            vars = { card.ability.extra.chips * cardCount },
        }
    end,
    rarity = 2,
    atlas = 'Miku',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local cardCount = 0
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Clubs') then
                    cardCount = cardCount + 1
                end
            end
            return {
                chips = cardCount * card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "Teto",
    path = "bttiKasaneTeto.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Teto',
    loc_txt = {
        name = 'Kasane Teto',
        text = {
            "{C:mult}+1{} Mult for every",
            "{C:hearts}Heart{} currently in {C:attention}full deck",
            "{C:inactive}(Currently +{C:mult}#1#{C:inactive} Mult)"
        }
    },

    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "UTAU", "Smith Hioka", "hatoving" } }
        local cardCount = 0
        if G.deck and G.deck.cards then
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Hearts') then
                    cardCount = cardCount + 1
                end
            end
        end
        return {
            vars = { card.ability.extra.mult * cardCount },
        }
    end,
    rarity = 2,
    atlas = 'Teto',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local cardCount = 0
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Hearts') then
                    cardCount = cardCount + 1
                end
            end
            return {
                mult = cardCount * card.ability.extra.mult
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}

SMODS.Atlas {
    key = "Neru",
    path = "bttiAkitaNeru.png",
    px = 71,
    py = 95
}
SMODS.Joker {
    key = 'Neru',
    loc_txt = {
        name = 'Akita Neru',
        text = {
            "Gain {C:attention}$0.5{} for every",
            "{C:diamonds}Diamond{} currently in {C:attention}Deck",
            "{C:inactive}(Currently {C:attention}$#1#{C:inactive})"
        }
    },

    config = { extra = { dollars = .5 } },
    loc_vars = function(self, info_queue, card)
        local combinable = G.BTTI.getCombinableJokers(card.ability.name)
        for _, line in ipairs(combinable) do
            info_queue[#info_queue + 1] = {
                key = 'bttiPossibleCombo',
                set = 'Other',
                vars = { line }
            }
        end
        info_queue[#info_queue + 1] = { key = 'bttiFromBy', set = 'Other', vars = { "VOCALOID (Derivative)", "Smith Hioka", "hatoving" } }
        local cardCount = 0
        if G.deck and G.deck.cards then
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Diamonds') then
                    cardCount = cardCount + 1
                end
            end
        end
        return {
            vars = { card.ability.extra.dollars * cardCount },
        }
    end,
    rarity = 2,
    atlas = 'Neru',
    pos = { x = 0, y = 0 },
    cost = 5,
    pools = { ["BTTI_modAddition"] = true, ["BTTI_modAddition_UNCOMMON"] = true, ["BTTI_modAddition_INTERNET"] = true },

    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,

    calculate = function(self, card, context)
        if context.joker_main then
            local cardCount = 0
            for i, pc in ipairs(G.deck.cards) do
                if pc:is_suit('Diamonds') then
                    cardCount = cardCount + 1
                end
            end
            return {
                dollars = cardCount * card.ability.extra.dollars
            }
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = false }
    end
}