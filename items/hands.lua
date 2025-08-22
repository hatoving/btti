SMODS.PokerHand {
    key = "Bisexual",
    loc_txt = {
        name = 'Bisexual',
        description = {
            "Straight but {C:bisexual}better{}"
        }
    },
    prefix_config = {
        key = { mod = false }
    },
    above_hand = "Straight",
    visible = false,
    mult = 12,
    chips = 200,
    l_mult = 3,
    l_chips = 30,
    example = {
        { 'D_J', true },
        { 'C_T', true },
        { 'C_9', true },
        { 'S_8', true },
        { 'H_7', true }
    },
    evaluate = function(parts, hand)
        if G.jokers then
            if G.jokers.cards then
                if next(SMODS.find_card("j_btti_BlueBen8")) then
                    return parts._straight
                end
            end
        end
        return {}
    end
}

SMODS.PokerHand {
    key = "BisexualFlush",
    loc_txt = {
        name = 'Bisexual Flush',
        description = {
            "Straight Flush but {C:bisexual}better{}"
        }
    },
    prefix_config = {
        key = { mod = false }
    },
    above_hand = "Straight Flush",
    visible = false,
    mult = 300,
    chips = 16,
    l_mult = 3,
    l_chips = 35,
    example = {
        { 'H_A', true },
        { 'H_K', true },
        { 'H_T', true },
        { 'H_5', true },
        { 'H_4', true }
    },
    evaluate = function(parts, hand)
        if not next(parts._straight) or not next(parts._flush) then return end
        if G.jokers then
            if G.jokers.cards then
                if next(SMODS.find_card("j_btti_BlueBen8")) then
                    return { SMODS.merge_lists(parts._straight, parts._flush) } 
                end
            end
        end
        return {}
    end
}

-- Horse
SMODS.PokerHand {
    key = "HighHorse",
    loc_txt = {
        name = 'High Horse',
        description = {
            "Consists of one Horse Card",
            "(and optionally, Stone Cards)"
        }
    },
    prefix_config = {
        key = { mod = false }
    },
    visible = false,
    mult = 3,
    chips = 30,
    l_mult = 2,
    l_chips = 20,
    example = {
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_stone" },
    },
    evaluate = function(parts, hand)
        return parts.btti_highhorse_base
    end
}

SMODS.PokerHand {
    key = "TwoHorse",
    loc_txt = {
        name = 'Two Horse',
        description = {
            "Consist of two Horse Cards",
            "(and optionally, Stone Cards)"
        }
    },
    prefix_config = {
        key = { mod = false }
    },
    visible = false,
    mult = 4,
    chips = 45,
    l_mult = 2,
    l_chips = 20,
    example = {
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_stone" },
    },
    evaluate = function(parts, hand)
        return parts.btti_twohorse_base
    end
}

SMODS.PokerHand {
    key = "ThreeHorse",
    loc_txt = {
        name = 'Three Horse',
        description = {
            "Consist of three Horse Cards",
            "(and optionally, Stone Cards)"
        }
    },
    prefix_config = {
        key = { mod = false }
    },
    visible = false,
    mult = 8,
    chips = 60,
    l_mult = 2,
    l_chips = 20,
    example = {
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_stone" },
    },
    evaluate = function(parts, hand)
        return parts.btti_threehorse_base
    end
}

SMODS.PokerHand {
    key = "FourHorsemen",
    loc_txt = {
        name = 'Four Horsemen',
        description = {
            "Consist of four Horse Cards",
            "(and optionally one Stone Card)"
        }
    },
    prefix_config = {
        key = { mod = false }
    },
    visible = false,
    mult = 14,
    chips = 130,
    l_mult = 2,
    l_chips = 20,
    example = {
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_stone" },
    },
    evaluate = function(parts, hand)
        return parts.btti_fourhorse_base
    end
}


SMODS.PokerHand {
    key = "FullHorse",
    loc_txt = {
        name = 'Full Horse',
        description = {
            "Consist of five Horse Cards",
        }
    },
    prefix_config = {
        key = { mod = false }
    },
    visible = false,
    mult = 20,
    chips = 300,
    l_mult = 2,
    l_chips = 20,
    example = {
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
        { 'S_2', true, enhancement ="m_btti_horseCard" },
    },
    evaluate = function(parts, hand)
        return parts.btti_fivehorse_base
    end
}

SMODS.PokerHandPart {
    key = 'highhorse_base',
    func = function(hand)
        local ret = {}
        local horsies = 0
        local anyOther = 0
        for i = 1, #hand do
            local v = hand[i].base.value
            if v then
                if hand[i].ability.name == "m_btti_horseCard" and not hand[i]:is_face() then
                    horsies = horsies + 1
                    table.insert(ret, hand[i])
                elseif hand[i].ability.name == "Stone Card" and not hand[i]:is_face() then
                    table.insert(ret, hand[i])
                else
                    anyOther = anyOther + 1
                end
            end
        end
        if anyOther <= 0 then
            if horsies == 1 then
                return { ret }
            end
        end
        return {}
    end
}
SMODS.PokerHandPart {
    key = 'twohorse_base',
    func = function(hand)
        local ret = {}
        local horsies = 0
        local anyOther = 0
        for i = 1, #hand do
            local v = hand[i].base.value
            if v then
                if hand[i].ability.name == "m_btti_horseCard" and not hand[i]:is_face() then
                    horsies = horsies + 1
                    table.insert(ret, hand[i])
                elseif hand[i].ability.name == "Stone Card" and not hand[i]:is_face() then
                    table.insert(ret, hand[i])
                else
                    anyOther = anyOther + 1
                end
            end
        end
        if anyOther <= 0 then
            if horsies == 2 then
                return { ret }
            end
        end
        return {}
    end
}

SMODS.PokerHandPart {
    key = 'threehorse_base',
    func = function(hand)
        local ret = {}
        local horsies = 0
        local anyOther = 0
        for i = 1, #hand do
            local v = hand[i].base.value
            if v then
                if hand[i].ability.name == "m_btti_horseCard" and not hand[i]:is_face() then
                    horsies = horsies + 1
                    table.insert(ret, hand[i])
                elseif hand[i].ability.name == "Stone Card" and not hand[i]:is_face() then
                    table.insert(ret, hand[i])
                else
                    anyOther = anyOther + 1
                end
            end
        end
        if anyOther <= 0 then
            if horsies == 3 then
                return { ret }
            end
        end
        return {}
    end
}


SMODS.PokerHandPart {
    key = 'fourhorse_base',
    func = function(hand)
        local ret = {}
        local horsies = 0
        local anyOther = 0
        for i = 1, #hand do
            local v = hand[i].base.value
            if v then
                if hand[i].ability.name == "m_btti_horseCard" and not hand[i]:is_face() then
                    horsies = horsies + 1
                    table.insert(ret, hand[i])
                elseif hand[i].ability.name == "Stone Card" and not hand[i]:is_face() then
                    table.insert(ret, hand[i])
                else
                    anyOther = anyOther + 1
                end
            end
        end
        if anyOther <= 0 then
            if horsies == 4 then
                return { ret }
            end
        end
        return {}
    end
}

SMODS.PokerHandPart {
    key = 'fivehorse_base',
    func = function(hand)
        local ret = {}
        local horsies = 0
        local anyOther = 0
        for i = 1, #hand do
            local v = hand[i].base.value
            if v then
                if hand[i].ability.name == "m_btti_horseCard" and not hand[i]:is_face() then
                    horsies = horsies + 1
                    table.insert(ret, hand[i])
                else
                    anyOther = anyOther + 1
                end
            end
        end
        if anyOther <= 0 then
            if horsies == 5 then
                return { ret }
            end
        end
        return {}
    end
}
