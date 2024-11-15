--Created and scripted by Rising Phoenix
local s,id=GetID()

function s.initial_effect(c)
    -- Effect 1: Discard 1 random card
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 2))
    e1:SetCategory(CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1, id)
    e1:SetCost(s.spcost)
    e1:SetCondition(s.discon1)
    e1:SetTarget(s.distg1)
    e1:SetOperation(s.disop1)
    c:RegisterEffect(e1)

    -- Effect 2: Discard 2 random cards
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 3))
    e2:SetCategory(CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1, id)
    e2:SetCost(s.spcost)
    e2:SetCondition(s.discon2)
    e2:SetTarget(s.distg2)
    e2:SetOperation(s.disop2)
    c:RegisterEffect(e2)

    -- Effect 3: Discard 3 random cards
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 4))
    e3:SetCategory(CATEGORY_HANDES)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1, id)
    e3:SetCost(s.spcost)
    e3:SetCondition(s.discon3)
    e3:SetTarget(s.distg3)
    e3:SetOperation(s.disop3)
    c:RegisterEffect(e3)

    -- Effect 4: Damage or Recover
    local e4 = Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e4:SetCategory(CATEGORY_DAMAGE + CATEGORY_RECOVER)
    e4:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCountLimit(1)
    e4:SetCondition(s.damcon)
    e4:SetTarget(s.damtg)
    e4:SetOperation(s.damop)
    c:RegisterEffect(e4)
end

-- Cost function: Reveal 1 "Set Card" in hand
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.cfilter, tp, LOCATION_HAND, 0, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
    local g = Duel.SelectMatchingCard(tp, s.cfilter, tp, LOCATION_HAND, 0, 1, 1, nil)
    Duel.ConfirmCards(1 - tp, g)
    Duel.ShuffleHand(tp)
end

-- Condition for first discard effect
function s.discon1(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetLP(tp) <= 7000 and Duel.GetFieldGroupCount(1 - tp, LOCATION_HAND, 0) >= 1
end

-- Target for first discard effect
function s.distg1(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, 1 - tp, 1)
end

-- Operation for first discard effect
function s.disop1(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND):RandomSelect(tp, 1)
    Duel.SendtoGrave(g, REASON_EFFECT + REASON_DISCARD)
end

-- Condition for second discard effect
function s.discon2(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetLP(tp) <= 5000 and Duel.GetFieldGroupCount(1 - tp, LOCATION_HAND, 0) >= 2
end

-- Target for second discard effect
function s.distg2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, 1 - tp, 2)
end

-- Operation for second discard effect
function s.disop2(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND):RandomSelect(tp, 2)
    Duel.SendtoGrave(g, REASON_EFFECT + REASON_DISCARD)
end

-- Condition for third discard effect
function s.discon3(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetLP(tp) <= 2000 and Duel.GetFieldGroupCount(1 - tp, LOCATION_HAND, 0) >= 3
end

-- Target for third discard effect
function s.distg3(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, 1 - tp, 3)
end

-- Operation for third discard effect
function s.disop3(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetFieldGroup(tp, 0, LOCATION_HAND):RandomSelect(tp, 3)
    Duel.SendtoGrave(g, REASON_EFFECT + REASON_DISCARD)
end

-- Condition for damage/recover effect
function s.damcon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp
end

-- Target for damage/recover effect
function s.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
    local op = Duel.SelectOption(tp, aux.Stringid(id, 0), aux.Stringid(id, 1))
    e:SetLabel(op)
    if op == 0 then
        e:SetCategory(CATEGORY_RECOVER)
        Duel.SetTargetPlayer(tp)
        Duel.SetTargetParam(300)
        Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 300)
    else
        e:SetCategory(CATEGORY_DAMAGE)
        Duel.SetTargetPlayer(tp)
        Duel.SetTargetParam(300)
        Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, tp, 300)
    end
end

-- Operation for damage/recover effect
function s.damop(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    if e:GetLabel() == 0 then
        Duel.Recover(p, d, REASON_EFFECT)
    else
        Duel.Damage(p, d, REASON_EFFECT)
    end
end

-- Filter function for "Set Card" in hand
function s.cfilter(c)
    return c:IsSetCard(0x75F) and not c:IsPublic()
end
