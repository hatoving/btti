SMODS.Keybind{
	key = 'imrich',
	key_pressed = 'm',
    held_keys = {'lctrl'}, -- other key(s) that need to be held

    action = function(self)
        G.GAME.dollars = 1000000
        sendInfoMessage("money set to 1 million", "CustomKeybinds")
    end,
}

SMODS.Atlas {
	-- Key for code to find it with
	key = "bttiJokers",
	-- The name of the file, for the code to pull the atlas from
	path = "bttiJokers.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

-- Jonker
SMODS.Joker {
	key = 'bttiJonker',
	loc_txt = {
		name = 'Jonker',
		text = {
			"{C:mult}+#1#{} Mult",
            "1 in 10 chance to steal {C:attention}$1-5{}"
		}
	},

	config = { extra = { mult = 10, odds = 2 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = { card.ability.extra.mult, card.ability.extra.money },
        }
	end,
	rarity = 1,
	atlas = 'bttiJokers',
	pos = { x = 0, y = 0 },
	cost = 0,

    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,

	calculate = function(self, card, context)
		if context.joker_main then
            if pseudorandom('bttiJonker') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local rand = math.random(-7, -2)
                return {
                    dollars = rand,
                    mult_mod = card.ability.extra.mult,
                    message = "i'm da jonker baybee!"
                }
            else
                return {
                    mult_mod = card.ability.extra.mult,
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
                }
            end
		end
        if context.main_scoring and context.cardarea == G.play then
            return {
                
            }
        end
	end,
    in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end
}