--scripted and created by rising phoenix
function c100001166.initial_effect(c)	
c:EnableReviveLimit()
	--spson
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(aux.FALSE)
	c:RegisterEffect(e8)
	--special summon
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_FIELD)
	e30:SetCode(EFFECT_SPSUMMON_PROC)
	e30:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e30:SetRange(LOCATION_HAND)
	e30:SetCondition(c100001166.spcon)
	c:RegisterEffect(e30)
	--cannot attack
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetOperation(c100001166.atklimit)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e12)
	local e13=e11:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
	--remove field
	local e22=Effect.CreateEffect(c)
	e22:SetOperation(c100001166.operationf)
	e22:SetHintTiming(TIMING_STANDBY_PHASE,0)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e22:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e22:SetDescription(aux.Stringid(100001166,0))
	e22:SetRange(LOCATION_MZONE)
	e22:SetCountLimit(1)
	e22:SetCondition(c100001166.lp)
	e22:SetOperation(c100001166.lpop)
	c:RegisterEffect(e22)
	--gr
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(100001166,0))
	e10:SetCategory(CATEGORY_RECOVER)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_LEAVE_FIELD)
	e10:SetCondition(c100001166.conditiongr)
	e10:SetOperation(c100001166.operationgr)
	c:RegisterEffect(e10)
end
function c100001166.damconr(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c100001166.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end
function c100001166.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c100001166.cfilter(c)
	return c:IsFaceup() and c:IsCode(100001155)
end
function c100001166.spcfilter(c)
	return c:IsSetCard(0x750) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c100001166.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100001166.cpfilter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function c100001166.lp(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN) and Duel.GetTurnPlayer()==tp
end
function c100001166.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end
function c100001166.operationgr(e,tp,eg,ep,ev,re,r,rp)
Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)*2))
end
function c100001166.conditiongr(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
