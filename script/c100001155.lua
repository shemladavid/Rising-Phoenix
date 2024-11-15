 --Created and coded by Rising Phoenix
local s,id=GetID()
function s.initial_effect(c)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e10=Effect.CreateEffect(c)
	e10:SetOperation(s.actb)
	e10:SetCost(s.descost)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e10:SetRange(LOCATION_DECK)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e10)
	--acthand
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e20:SetRange(LOCATION_HAND)
	e20:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e20:SetOperation(s.actb)
	e20:SetCost(s.descost)
	e20:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e20)
	--actgrave
	local e30=Effect.CreateEffect(c)
	e30:SetOperation(s.actb)
	e30:SetCost(s.descost)
	e30:SetRange(LOCATION_GRAVE)
	e30:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e30:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e30)
	--actremoved
	local e40=Effect.CreateEffect(c)
	e40:SetOperation(s.actb)
	e40:SetCost(s.descost)
	e40:SetRange(LOCATION_REMOVED)
	e40:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e40:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e40:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e40)
	--Unnafected by other cards' effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	--Immune for all cards
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetValue(s.eefilter)
	c:RegisterEffect(e3)
	--add to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
	--cannot set
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_MSET)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_ONFIELD)
	e10:SetValue(s.actset)
	e10:SetTargetRange(1,0)
	e10:SetTarget(aux.TRUE)
	c:RegisterEffect(e10)
	local e12=e10:Clone()
	e12:SetValue(s.actset)
	e12:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e12)
	local e13=e10:Clone()
	e13:SetValue(s.actset)
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e13:SetTarget(s.sumlimit)
	c:RegisterEffect(e13)
	--cannot sp
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetRange(LOCATION_ONFIELD)
	e14:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetTargetRange(1,0)
	e14:SetTarget(s.spslimit)
	c:RegisterEffect(e14)
	--cannot ns
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_FIELD)
	e15:SetRange(LOCATION_ONFIELD)
	e15:SetCode(EFFECT_CANNOT_SUMMON)
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetTargetRange(1,0)
	e15:SetTarget(s.spslimit)
	c:RegisterEffect(e15)
end
function s.actset(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsSetCard(0x750) and not rc:IsImmuneToEffect(e)
end
function s.spslimit(e,c)
	return not c:IsSetCard(0x750)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)~=0
end
function s.efun(e,ep,tp)
	return ep==tp
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.eefilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.actb(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetActivateEffect():IsActivatable(tp) end
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,REASON_EFFECT,true)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100001155)==0 end
	Duel.RegisterFlagEffect(tp,100001155,0,0,0)
end
function s.thfilter(c)
	return c:IsSetCard(0x750) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end