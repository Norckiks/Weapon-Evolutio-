-- Procedural first-person attacks. Timing is frozen at swing start.
local M={}
local function pose(x,y,z,rx,ry,rz)
 return CFrame.new(x,y,z)*CFrame.Angles(math.rad(rx),math.rad(ry),math.rad(rz))
end
local function smooth(a) return a*a*(3-2*a) end
local function easeOutBack(a) local x=a-1 return 1+2.2*x*x*x+1.2*x*x end
M.Profiles={
 Shotgun={Windup=.015,Strike=.06,Recover=.85,Pitch=.7,Wind=pose(0,0,0,0,0,0),Hit=pose(.02,.12,.35,-24,2,-3)},
 Revolver={Windup=.02,Strike=.05,Recover=.65,Pitch=.8,Wind=pose(0,0,0,0,0,0),Hit=pose(.035,.14,.3,-26,3,-5)},
 SMG={Windup=.01,Strike=.02,Recover=.08,Pitch=1.2,Wind=pose(0,0,0,0,0,0),Hit=pose(.015,.035,.12,-8,1,1)},
 Pistol={Windup=.02,Strike=.03,Recover=.23,Pitch=1,Wind=pose(0,0,0,0,0,0),Hit=pose(0,.08,.2,-16,0,0)},
 Fists={Windup=.09,Strike=.08,Recover=.23,Pitch=1,Wind=pose(.12,-.06,.16,0,18,10),Hit=pose(-.42,.12,-1.12,-5,-14,-10)},
 Pipe={Windup=.12,Strike=.08,Recover=.26,Pitch=.94,Wind=pose(.26,.17,.15,-20,25,38),Hit=pose(-.65,-.08,-.6,36,-46,-55)},
 Bat={Windup=.17,Strike=.09,Recover=.28,Pitch=.82,Wind=pose(.42,.04,.3,8,56,70),Hit=pose(-.84,.1,-.58,18,-65,-78)},
 Axe={Windup=.25,Strike=.09,Recover=.31,Pitch=.72,Wind=pose(.04,.48,.25,-65,10,12),Hit=pose(-.12,-.4,-.78,74,-8,-14)},
 Katana={Windup=.10,Strike=.07,Recover=.31,Pitch=1.22,Wind=pose(.32,.21,.08,-15,42,58),Hit=pose(-.74,-.12,-.65,28,-55,-68)},
 LimitedBlade={Windup=.14,Strike=.08,Recover=.28,Pitch=1.1,Wind=pose(-.28,.08,.26,-30,-35,-45),Hit=pose(.48,.36,-.9,-42,35,54)},
}
function M.Pulse(elapsed,sign)
	if elapsed<0 or elapsed>=.86 then return CFrame.identity,0 end
	local charge=pose(-sign*.08,.18,.2,-8,sign*5,sign*3) local hit=pose(-sign*.16,.1,-.42,-16,sign*12,sign*10)
	if elapsed<.42 then local a=elapsed/.42 return CFrame.identity:Lerp(charge,a*a*(3-2*a)),a end
	if elapsed<.5 then local a=(elapsed-.42)/.08 return charge:Lerp(hit,1-(1-a)^3),1 end
	if elapsed<.55 then local kick=math.sin((elapsed-.5)/.05*math.pi) return hit*pose(0,.025*kick,.06*kick,5*kick,0,0),1 end
	local a=math.clamp((elapsed-.55)/.31,0,1) local settle=smooth(a) return hit:Lerp(CFrame.identity,settle),1-settle
end
M.AbilityProfiles={Slam={Duration=1.12,Wind=.34,Hit=.12,WindPose=pose(-.04,.46,.12,-72,0,-6),HitPose=pose(-.08,-.28,-.55,78,0,4),Body=24},Frost={Duration=1.02,Wind=.31,Hit=.12,WindPose=pose(-.16,.2,.38,-28,-12,-18),HitPose=pose(-.12,.04,-.95,-8,4,0),Body=8},Aegis={Duration=1.15,Wind=.32,Hit=.12,WindPose=pose(0,.16,.08,-18,0,0),HitPose=pose(0,.18,-.12,-26,0,0),Body=-8},SecondSouffle={Duration=1.42,Wind=.42,Hit=.3,WindPose=pose(0,.34,.16,-42,0,0),HitPose=pose(0,.08,-.28,18,0,0),Body=12}}
function M.Ability(id,elapsed,sign)
 if id=="Pulse" then local p,w=M.Pulse(elapsed,sign) return p,w,0 end
 local d=M.AbilityProfiles[id]
 if not d or elapsed<0 or elapsed>=d.Duration then return CFrame.identity,0,0 end
 local wind,hit=d.WindPose,d.HitPose
 if sign<0 then wind=pose(-wind.X,wind.Y,wind.Z,0,0,0)*CFrame.Angles(0,-math.rad(30),-math.rad(42)) hit=pose(-hit.X,hit.Y,hit.Z,0,0,0)*CFrame.Angles(0,math.rad(38),math.rad(54)) end
	if elapsed<d.Wind then local a=elapsed/d.Wind local back=easeOutBack(a) return CFrame.identity:Lerp(wind,back),math.clamp(a,0,1),d.Body*back end
	local strikeEnd=d.Wind+d.Hit
	if elapsed<strikeEnd then local a=(elapsed-d.Wind)/d.Hit return wind:Lerp(hit,1-(1-a)^3),1,d.Body end
	local recoverStart=strikeEnd+.07
	if elapsed<recoverStart then local kick=math.sin((elapsed-strikeEnd)/.07*math.pi) return hit*pose(0,.025*kick,.055*kick,4*kick,0,0),1,d.Body end
	local a=math.clamp((elapsed-recoverStart)/(d.Duration-recoverStart),0,1) local settle=smooth(a)
	return hit:Lerp(CFrame.identity,settle),1-settle,d.Body*(1-settle)
end
-- Shared normalized timeline; the server owns its start and duration.
function M.Reload(alpha,sign,id)
 if alpha<=0 or alpha>=1 then return CFrame.identity end
 local function smooth(a) return a*a*(3-2*a) end
 local lift=alpha<.2 and smooth(alpha/.2) or alpha>.8 and smooth((1-alpha)/.2) or 1
 local insert=math.sin(math.clamp((alpha-.38)/.4,0,1)*math.pi)
 if id=="Shotgun" then
  local shell=math.sin(math.clamp((alpha-.15)/.7,0,1)*math.pi*10)
  if sign<0 then return CFrame.identity:Lerp(pose(.48,-.08,-.1,30,-20,42),lift)*pose(0,shell*.06,0,0,0,0) end
  return CFrame.identity:Lerp(pose(-.1,.15,.13,-12,-12,-35),lift)
 end
 if id=="Revolver" then
  if sign<0 then return CFrame.identity:Lerp(pose(.52,.02,-.28,38,-38,52),lift)*pose(0,insert*.1,0,0,0,0) end
  return CFrame.identity:Lerp(pose(-.13,.12,.12,-18,-15,-56),lift)
 end
 if sign<0 then return CFrame.identity:Lerp(pose(.72,-.18+insert*.22,-.15,25,-25,35),lift) end
 return CFrame.identity:Lerp(pose(-.18,.08,.22,-12,-25,-32),lift)*pose(0,-insert*.035,0,insert*3,0,0)
end
-- Offset moving first-person pieces around the cylinder pivot. No gameplay state changes.
function M.Pump(elapsed)
 if elapsed<.22 or elapsed>.65 then return 0 end
 return math.sin((elapsed-.22)/.43*math.pi)
end
function M.PartPose(id,name,alpha,ammo,elapsed)
 if id=="Shotgun" and (name=="Foreend" or name=="PumpRib") then return CFrame.new(0,0,.22*M.Pump(elapsed or -1)) end
 if id~="Revolver" then return CFrame.identity end
 if name~="Cylinder" and name~="CylinderAxle" and name~="ChamberRim" and name~="ChamberPrimer" then return CFrame.identity end
 local open=0 local turn=(6-math.clamp(ammo or 6,0,6))*math.pi/3
 if alpha and alpha>0 and alpha<1 then
  local a=math.min(alpha/.18,(1-alpha)/.18,1) open=a*a*(3-2*a)
  -- End aligned to the refilled cylinder, without a snap when the reload finishes.
  turn=turn*(1-alpha)+math.sin(alpha*math.pi)*math.pi
 end
 return CFrame.new(-.34*open,0,.1*open)*CFrame.new(0,.37,-.29)*CFrame.Angles(0,0,turn)*CFrame.new(0,-.37,.29)
end
function M.Get(id) return M.Profiles[id] or M.Profiles.Fists end
function M.Sample(id,elapsed,heavy,sign,combo)
 local p=M.Get(id)
 if elapsed<0 or elapsed>=p.Windup+p.Strike+p.Recover then return CFrame.identity,0 end
 local wind,hit=p.Wind,p.Hit
 if id=="Fists" and sign<0 then
  wind=pose(-.12,-.06,.16,0,-18,-10) hit=pose(.42,.12,-1.12,-5,14,10)
 elseif id=="Katana" and combo==2 then
  wind=pose(-.38,-.1,.16,25,-40,-52) hit=pose(.5,.26,-.7,-30,48,62)
 end
 if heavy then wind=wind*pose(0,.12,.12,-12,0,8) hit=hit*pose(0,-.08,-.18,12,0,-10) end
 if elapsed<p.Windup then local a=elapsed/p.Windup return CFrame.identity:Lerp(wind,a*a*(3-2*a)),a end
 if elapsed<p.Windup+p.Strike then local a=(elapsed-p.Windup)/p.Strike return wind:Lerp(hit,1-(1-a)^3),1 end
 local a=(elapsed-p.Windup-p.Strike)/p.Recover return hit:Lerp(CFrame.identity,a*a*(3-2*a)),1-a
end
return M
