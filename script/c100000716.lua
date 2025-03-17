--scripted and created by rising phoenix
local s,id=GetID()
function s.initial_effect(c)	
	c:EnableReviveLimit()
	-- Fusion Summon using 3 "Sky Army" monsters
    Fusion.AddProcMixN(c, true, true, aux.FilterBoolFunction(Card.IsFusionSetCard, 0x764), 3)
    --Alt. Special Summon procedure
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.hspcon)
	e0:SetTarget(s.hsptg)
	e0:SetOperation(s.hspop)
	c:RegisterEffect(e0)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(s.condition)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--special summon from deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(s.condition22)
	e4:SetTarget(s.target22)
	e4:SetOperation(s.operation22)
	c:RegisterEffect(e4)
end
-- Change the filter so it only checks for Continuous Trap cards (no cost requirement)
function s.ctrapfilter(c)
	return c:IsContinuousTrap()
end

-- Updated condition: Only look in the hand for 3 Continuous Trap cards.
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.ctrapfilter, tp, LOCATION_HAND, 0, nil)
	return #g>=3 and Duel.GetLocationCountFromEx(tp, tp) > 0
end

-- Updated target function: Select 3 Continuous Trap cards from your hand to reveal.
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.ctrapfilter, tp, LOCATION_HAND, 0, nil)
	local rg=aux.SelectUnselectGroup(g, e, tp, 3, 3, nil, 1, tp, HINTMSG_CONFIRM)
	if rg then
		rg:KeepAlive()
		e:SetLabelObject(rg)
		return true
	end
	return false
end

-- Updated operation: Reveal the selected cards to your opponent and then shuffle your hand.
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=e:GetLabelObject()
	if not rg then return end
	Duel.ConfirmCards(1-tp, rg)
	Duel.ShuffleHand(tp)
	rg:DeleteGroup()
end
function s.filter22(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsControler(tp) and c:IsSetCard(0x764) and c:IsType(TYPE_TRAP+TYPE_CONTINUOUS)
end
function s.condition22(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter22,1,nil,tp) and Duel.GetTurnPlayer()==tp
end
function s.target22(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.operation22(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x764)  and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not (c:IsCode(100000716) or c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then end
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end	
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP+TYPE_CONTINUOUS) and re:GetHandler():IsSetCard(0x764)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end