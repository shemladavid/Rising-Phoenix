--Created and scripted by Rising Phoenix
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Activate Counter Traps from hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_HAND,0)
    e2:SetTarget(s.handtg)
    c:RegisterEffect(e2)
    --Change Code
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_CHANGE_CODE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetValue(56433456)
    c:RegisterEffect(e3)
    --To Hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,0))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(s.thtg)
    e4:SetOperation(s.thop)
    c:RegisterEffect(e4)
    --Avoid Battle Damage
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e5:SetRange(LOCATION_FZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(s.extg)
    e5:SetCondition(s.con)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    --No Damage
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CHANGE_DAMAGE)
    e6:SetRange(LOCATION_FZONE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(1,0)
    e6:SetCondition(s.con)
    e6:SetValue(s.damval)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    c:RegisterEffect(e7)
    --Indestructible
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e8:SetRange(LOCATION_FZONE)
    e8:SetTargetRange(LOCATION_MZONE,0)
    e8:SetTarget(s.indtg)
    e8:SetValue(1)
    e8:SetCondition(s.con)
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e9)
    --Send Cards to Deck
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(id,1))
    e10:SetCategory(CATEGORY_TODECK)
    e10:SetType(EFFECT_TYPE_IGNITION)
    e10:SetRange(LOCATION_SZONE)
    e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e10:SetCountLimit(1)
    e10:SetTarget(s.tdtg)
    e10:SetOperation(s.tdop)
    c:RegisterEffect(e10)
    --Discard Random Card
    local e11=Effect.CreateEffect(c)
    e11:SetCategory(CATEGORY_HANDES)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e11:SetCode(EVENT_CHAINING)
    e11:SetRange(LOCATION_FZONE)
    e11:SetCondition(s.discon)
    e11:SetOperation(s.disop)
    c:RegisterEffect(e11)
end

function s.con(e)
    return true
end
function s.indtg(e,c)
    return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelBelow(4)
end
function s.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetOwnerPlayer() then return 0 else return val end
end
function s.extg(e,c)
    return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.handtg(e,c)
    return c:IsType(TYPE_COUNTER)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
end
function s.thfilter(c)
    return (c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()) or (c:IsType(TYPE_COUNTER) and c:IsAbleToHand())
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
    Duel.ConfirmDecktop(tp,3)
    local g=Duel.GetDecktopGroup(tp,3)
    if g:IsExists(s.thfilter,1,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:FilterSelect(tp,s.thfilter,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
        Duel.ShuffleHand(tp)
    end
    Duel.ShuffleDeck(tp)
end
function s.tdfilter(c,e)
    return (c:IsRace(RACE_FAIRY) or c:IsType(TYPE_COUNTER)) and c:IsAbleToDeck() and (not e or c:IsCanBeEffectTarget(e))
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tdfilter(chkc,e) end
    if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,99,nil,e)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,#tg,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tg=Duel.GetTargetCards(e)
    if not tg or #tg==0 then return end
    if Duel.SendtoDeck(tg,nil,SEQ_DECKTOP,REASON_EFFECT)==0 then return end
    local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
    if ct>0 then Duel.SortDecktop(tp,tp,ct) end
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsActiveType(TYPE_COUNTER) and rp==tp
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if #g>0 then
        local sg=g:RandomSelect(tp,1)
        Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
    end
end