-- Ocean Soldier Axel
local s,id=GetID()
function s.initial_effect(c)
	-- Gain LP or take damage during Standby Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.lpcon)
	e1:SetOperation(s.lpop)
	c:RegisterEffect(e1)
	-- Reveal and banish cards from opponent's Graveyard (Ignition effect)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end

function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end

function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.Recover(tp,300,REASON_EFFECT)
	else
		Duel.Damage(tp,300,REASON_EFFECT)
	end
end

function s.cfilter(c)
	return c:IsSetCard(0x75F) and not c:IsPublic()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=7000 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	local max_banish=0
	if lp<=2000 then
		max_banish=15
	elseif lp<=5000 then
		max_banish=10
	elseif lp<=7000 then
		max_banish=5
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	if #g>0 then
		local sg=g:RandomSelect(tp,math.min(#g,max_banish))
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
