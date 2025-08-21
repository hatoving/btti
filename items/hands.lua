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
        return parts._straight
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
                else
                    return {}
                end
            end
        end
    end
}
