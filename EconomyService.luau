local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local MarketplaceService=game:GetService("MarketplaceService")
local C=require(ReplicatedStorage:WaitForChild("GameplayConfig"))
local P=require(script.Parent:WaitForChild("ProgressionService"))
local Visuals=require(ReplicatedStorage:WaitForChild("WeaponVisuals"))
local Contracts=require(ReplicatedStorage:WaitForChild("QuickContracts"))
local Expeditions=require(ReplicatedStorage:WaitForChild("Expeditions"))
local Zones=require(script.Parent:WaitForChild("ZoneService"))
local action=ReplicatedStorage.Remotes:WaitForChild("GameAction")
local state=ReplicatedStorage.Remotes:WaitForChild("GameState")
local E={} local profiles={} local requests={} local started=false local rng=Random.new()
local chains={}
local Crates=require(ReplicatedStorage:WaitForChild("CrateCatalog"))
local cratePolicy={} local crateAt={}
local function clearChain(p)
 chains[p]=nil
 p:SetAttribute("KillChain",0) p:SetAttribute("KillChainUntil",0)
end
local function advanceChain(p)
 local character=p.Character
 local humanoid=character and character:FindFirstChildOfClass("Humanoid")
 if not humanoid or humanoid.Health<=0 or p:GetAttribute("HasStarted")~=true then return end
 local now=workspace:GetServerTimeNow()
 local previous=chains[p]
 local count=previous and previous.Character==character and previous.Until>now and previous.Count+1 or 1
 local current={Count=count,Until=now+C.KillChain.Window,Character=character}
 chains[p]=current
 p:SetAttribute("KillChainUntil",current.Until) p:SetAttribute("KillChain",count)
 p:SetAttribute("BestKillChain",math.max(p:GetAttribute("BestKillChain") or 0,count))
 task.delay(C.KillChain.Window,function()
  if p.Parent and chains[p]==current then clearChain(p) end
 end)
end
local function n(value,max)
 if typeof(value)~="number" or value~=value or math.abs(value)==math.huge then return 0 end
 return math.clamp(math.floor(value),0,max)
end
local function map(value) return typeof(value)=="table" and value or {} end
local function day() return math.floor(os.time()/86400) end
local function daily(m)
 if typeof(m.Daily)~="table" or m.Daily.Day~=day() then m.Daily={Day=day(),Seconds=0,Kills=0,Claimed={},Missions={}} end
 local d=m.Daily d.Seconds=n(d.Seconds,86400) d.Kills=n(d.Kills,1000000) d.Claimed=map(d.Claimed) d.Missions=map(d.Missions)
 return d
end
local function profile(p)
 local m=profiles[p] if m then daily(m) return m end
 m=P.GetMeta(p) if not m then return nil end
 m.HealthLevel=n(m.HealthLevel,C.Upgrades.Health.Max) m.SpeedLevel=n(m.SpeedLevel,C.Upgrades.Speed.Max)
 m.Weapons=map(m.Weapons) m.Weapons.Fists=true
 for id,v in m.Weapons do if not C.Weapons[id] or v~=true then m.Weapons[id]=nil end end
 if not C.Weapons[m.EquippedWeapon] or not m.Weapons[m.EquippedWeapon] then m.EquippedWeapon="Fists" end
 m.Fragments=map(m.Fragments) m.Pets=map(m.Pets)
 for id in m.Fragments do if not C.Pets[id] or id=="Buddy" then m.Fragments[id]=nil else m.Fragments[id]=n(m.Fragments[id],1000000) end end
 for id in m.Pets do if not C.Pets[id] then m.Pets[id]=nil else m.Pets[id]=n(m.Pets[id],100000) end end
 if not C.Pets[m.EquippedPet] or (m.Pets[m.EquippedPet] or 0)<1 then m.EquippedPet="" end
 m.XPBoostUntil=n(m.XPBoostUntil,4000000000) m.CoinBoostUntil=n(m.CoinBoostUntil,4000000000)
 m.Receipts=map(m.Receipts) daily(m) profiles[p]=m return m
end
local function weaponModel(p,m)
 local char=p.Character local hand=char and (char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm"))
 if not hand then return end
 if char:GetAttribute("VisualWeaponId")==m.EquippedWeapon then return end
 local old=char:FindFirstChild("EquippedWeaponVisual") if old then old:Destroy() end
 char:SetAttribute("VisualWeaponId",m.EquippedWeapon)
 if m.EquippedWeapon=="Fists" then return end
 local model,pieces=Visuals.Build(m.EquippedWeapon)
 for _,item in pieces do
  local v=item.part v.Anchored=false v.Massless=true
  local grip=C.Weapons[m.EquippedWeapon].Firearm and CFrame.new(0,-.15,-.08)*CFrame.Angles(-math.pi/2,0,0) or CFrame.new(0,-0.5,-0.15)*CFrame.Angles(0,0,math.rad(180))
  v.CFrame=hand.CFrame*grip*item.rel
  local weld=Instance.new("WeldConstraint") weld.Part0=hand weld.Part1=v weld.Parent=v
 end
 model.Parent=char
end
function E.Refresh(p)
 local m=profile(p) if not m then return end
 local pet=C.Pets[m.EquippedPet] local xp=1+(pet and pet.XP or 0) local coins=1+(pet and pet.Coins or 0)
 if m.XPBoostUntil>os.time() then xp*=2 end if m.CoinBoostUntil>os.time() then coins*=2 end
 p:SetAttribute("XPMultiplier",xp) p:SetAttribute("CoinsMultiplier",coins)
 p:SetAttribute("EquippedPet",m.EquippedPet) p:SetAttribute("EquippedWeapon",m.EquippedWeapon)
 local speedBonus=pet and pet.Speed or 0
 p:SetAttribute("BaseWalkSpeed",(16+m.SpeedLevel*C.Upgrades.Speed.Step)*(1+speedBonus))
 p:SetAttribute("SprintWalkSpeed",(26+m.SpeedLevel*C.Upgrades.Speed.Step)*(1+speedBonus))
 local h=p.Character and p.Character:FindFirstChildOfClass("Humanoid")
 if h and h.Health>0 then
  local max=100+m.HealthLevel*C.Upgrades.Health.Step
  if h.MaxHealth~=max then local diff=max-h.MaxHealth h.MaxHealth=max h.Health=math.clamp(h.Health+diff,1,max) end
 end
 weaponModel(p,m)
end
function E.Send(p,note,open)
 local m=profile(p) if not m then return end
 local contract=Contracts.Ensure(m)
 Expeditions.Ensure(m)
 local ls=p:FindFirstChild("leaderstats") if not ls then return end
 state:FireClient(p,{Kind="State",Note=note,Open=open,Data={CratesAllowed=cratePolicy[p]==true,Contract=contract,Expeditions=m.Expeditions,HealthLevel=m.HealthLevel,SpeedLevel=m.SpeedLevel,Weapons=m.Weapons,EquippedWeapon=m.EquippedWeapon,Fragments=m.Fragments,Pets=m.Pets,EquippedPet=m.EquippedPet,XPBoostUntil=m.XPBoostUntil,CoinBoostUntil=m.CoinBoostUntil,Daily=m.Daily,Coins=ls.Coins.Value,Level=ls.Level.Value,CoinsMultiplier=p:GetAttribute("CoinsMultiplier") or 1,XPMultiplier=p:GetAttribute("XPMultiplier") or 1,HasStarted=p:GetAttribute("HasStarted")==true}})
end
local function nearShop(p,id)
 local r=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
 return r and (r.Position-C.Shops[id]).Magnitude<=20
end
local function award(p,m,reward)
 if reward.Kind=="Coins" then P.AddRewards(p,reward.Amount,0,reward.Name)
 elseif reward.Kind=="XP" then P.AddRewards(p,0,reward.Amount,reward.Name)
 elseif reward.Kind=="XPBoost" then m.XPBoostUntil=math.max(os.time(),m.XPBoostUntil)+reward.Amount
 elseif reward.Kind=="CoinBoost" then m.CoinBoostUntil=math.max(os.time(),m.CoinBoostUntil)+reward.Amount
 elseif reward.Kind=="Pet" then m.Pets[reward.Id]=(m.Pets[reward.Id] or 0)+reward.Amount if m.EquippedPet=="" then m.EquippedPet=reward.Id end
 elseif reward.Kind=="Fragment" then m.Fragments[reward.Id]=(m.Fragments[reward.Id] or 0)+reward.Amount end
end
function E.OnZombieKill(p,id)
 local m=profile(p) if not m or not C.Pets[id] or id=="Buddy" then return end
 advanceChain(p)
 m.Daily.Kills+=1
 local expeditionZone=Expeditions.ZoneForSpecies(id)
 if expeditionZone and Zones.CanAccess(p,expeditionZone) then Expeditions.OnKill(m,id) end
 local note
 if rng:NextInteger(1,3)==1 then m.Fragments[id]=(m.Fragments[id] or 0)+1 note="+1 fragment : "..C.Pets[id].Name.." ("..m.Fragments[id].."/3)" end
 local completed=Contracts.OnKill(m,id)
 if completed then
  P.AddRewards(p,completed.Coins,completed.XP,"Contrat express")
  note="Contrat termine ! +"..completed.Coins.." pieces / +"..completed.XP.." XP"..(note and " · "..note or "")
 end
 E.Send(p,note)
end
function E.Handle(p,verb,id)
 if typeof(verb)~="string" or #verb>32 then return end
 if verb=="MenuState" then if typeof(id)=="boolean" then p:SetAttribute("InGameMenu",id) end return end
 local now=os.clock() if now-(requests[p] or -100)<0.12 then return end requests[p]=now
 local m=profile(p) if not m or not p:GetAttribute("ProgressReady") then return end
 if verb=="Sync" then E.Send(p) return end
 if verb=="Start" then p:SetAttribute("HasStarted",true) p:SetAttribute("InGameMenu",false) E.Send(p,"CTRL : dash · 3 fragments identiques = 1 pet") return end
 if not p:GetAttribute("HasStarted") then return end
 if typeof(id)~="string" or #id>64 then return end
 local ls=p.leaderstats local note local changed=false
 if verb=="OpenCrate" then
  local function reject(message) state:FireClient(p,{Kind="CrateError",Note=message}) E.Send(p) end
  local def=Crates.Definitions[id] if not def then reject("Caisse inconnue.") return end
  if cratePolicy[p]~=true then reject("Caisses indisponibles pour ce compte ou verification en cours. Les achats directs restent disponibles.") return end
  if now-(crateAt[p] or -100)<4 then reject("Attends avant d'ouvrir une autre caisse.") return end
  if ls.Level.Value<def.Level then reject("Niveau "..def.Level.." requis.") return end
  if ls.Coins.Value<def.Cost then reject("Pas assez de pieces.") return end
  if def.Kind=="Pet" then for _,item in def.Items do if (m.Pets[item.Id] or 0)>=100000 then reject("Inventaire de pets plein.") return end end end
  -- No yield between the debit, server roll and award.
  local item=Crates.Roll(def,rng) local refund=0
  ls.Coins.Value-=def.Cost crateAt[p]=now
  if def.Kind=="Weapon" then
   if m.Weapons[item.Id] then refund=Crates.Refund(item.Id) ls.Coins.Value+=refund else m.Weapons[item.Id]=true end
  else m.Pets[item.Id]=(m.Pets[item.Id] or 0)+1 end
  E.Refresh(p) task.spawn(P.Save,p,false)
  state:FireClient(p,{Kind="CrateResult",CrateId=id,Id=item.Id,Rarity=item.Rarity,Refund=refund})
  E.Send(p) return
 end
 if verb=="Upgrade" then
  local def=C.Upgrades[id] if not def then return end
  local key=id=="Health" and "HealthLevel" or "SpeedLevel" local lv=m[key]
  if lv>=def.Max then E.Send(p,"Amelioration au maximum !") return end
  local cost=C.UpgradeCost(id,lv) if ls.Coins.Value<cost then E.Send(p,"Pas assez de pieces.") return end
  ls.Coins.Value-=cost m[key]+=1 changed=true note=def.Name.." amelioree !"
 elseif verb=="BuyWeapon" then
  local def=C.Weapons[id] if not def or def.Premium or m.Weapons[id] then return end
  if ls.Level.Value<def.Level then E.Send(p,"Niveau "..def.Level.." requis.") return end
  if ls.Coins.Value<def.Cost then E.Send(p,"Pas assez de pieces.") return end
  ls.Coins.Value-=def.Cost m.Weapons[id]=true m.EquippedWeapon=id changed=true note=def.Name.." achetee et equipee !"
 elseif verb=="EquipWeapon" then
  if not C.Weapons[id] or not m.Weapons[id] then return end m.EquippedWeapon=id changed=true note=C.Weapons[id].Name.." equipee"
 elseif verb=="Fuse" then
  if not C.Pets[id] or id=="Buddy" then return end
  if (m.Fragments[id] or 0)<3 then E.Send(p,"Il faut 3 fragments du meme zombie.") return end
  m.Fragments[id]-=3 m.Pets[id]=(m.Pets[id] or 0)+1
  if m.EquippedPet=="" then m.EquippedPet=id end changed=true note="Fusion reussie : "..C.Pets[id].Name.." !"
 elseif verb=="EquipPet" then
  if id~="" and (not C.Pets[id] or (m.Pets[id] or 0)<1) then return end
  m.EquippedPet=id changed=true note=id=="" and "Pet range" or C.Pets[id].Name.." t'accompagne !"
 elseif verb=="ClaimTime" then
  local i=tonumber(id) local reward=i and C.TimeRewards[i] if not reward or i%1~=0 then return end
  id=tostring(i)
  if m.Daily.Claimed[id] then return end
  if m.Daily.Seconds<reward.Seconds then E.Send(p,"Cette recompense n'est pas encore debloquee.") return end
  m.Daily.Claimed[id]=true award(p,m,reward) changed=true note=reward.Name.." recupere !"
 elseif verb=="ClaimMission" then
  local i=tonumber(id) local reward=i and C.Missions[i] if not reward or i%1~=0 then return end
  id=tostring(i)
  if m.Daily.Missions[id] or m.Daily.Kills<reward.Kills then return end
  m.Daily.Missions[id]=true P.AddRewards(p,reward.Coins,reward.XP,"Mission de chasse") changed=true note="Mission terminee !"
 elseif verb=="ClaimExpedition" then
  local zone,step=Expeditions.Parse(id)
  if not zone or not Zones.CanAccess(p,zone) then return end
  local reward=Expeditions.Claim(m,zone.Id,step) if not reward then return end
  if not P.AddRewards(p,reward.Coins,reward.XP,"Dossier d'expedition") then m.Expeditions[zone.Id].Claimed=step-1 return end
  changed=true note="Expedition terminee ! +"..reward.Coins.." pieces / +"..reward.XP.." XP"
 elseif verb=="Robux" then
  if not C.MonetizationEnabled then E.Send(p,"Achats Robux desactives pour le moment.") return end
  for _,product in C.Products do if product.Key==id and product.ProductId>0 then
   pcall(function() MarketplaceService:PromptProductPurchase(p,product.ProductId) end) return
  end end
  if id=="LimitedBlade" and C.LimitedOffer.GamePassId>0 and C.LimitedOffer.SaleEndsAt>os.time() and not m.Weapons.LimitedBlade then
   pcall(function() MarketplaceService:PromptGamePassPurchase(p,C.LimitedOffer.GamePassId) end) return
  end
 else return end
 if changed then E.Refresh(p) task.spawn(P.Save,p,false) end
 E.Send(p,note)
end
function E.Init()
 if started then return end started=true P.Init()
 require(script.Parent:WaitForChild("AdminService")).Init(E)
 local function added(p)
  p:SetAttribute("HasStarted",false) p:SetAttribute("InGameMenu",true)
  p:SetAttribute("BestKillChain",0) clearChain(p)
  task.spawn(function()
   local ok,policy=pcall(function() return game:GetService("PolicyService"):GetPolicyInfoForPlayerAsync(p) end)
   if p.Parent then cratePolicy[p]=ok and typeof(policy)=="table" and policy.ArePaidRandomItemsRestricted==false E.Send(p) end
  end)
  local function characterAdded(character)
   clearChain(p)
   local humanoid=character:WaitForChild("Humanoid",10)
   if humanoid and character==p.Character then
    humanoid.Died:Once(function() if p.Character==character then clearChain(p) end end)
   end
   task.wait(0.2) E.Refresh(p)
  end
  p.CharacterAdded:Connect(characterAdded)
  if p.Character then task.spawn(characterAdded,p.Character) end
  task.spawn(function()
   while p.Parent and not p:GetAttribute("ProgressReady") do task.wait(0.1) end
   if not p.Parent then return end E.Refresh(p) E.Send(p)
   if C.LimitedOffer.GamePassId>0 then
    local ok,owns=pcall(function() return MarketplaceService:UserOwnsGamePassAsync(p.UserId,C.LimitedOffer.GamePassId) end)
    if ok and owns and p.Parent then local m=profile(p) if m then m.Weapons.LimitedBlade=true E.Refresh(p) E.Send(p) end end
   end
  end)
 end
 Players.PlayerAdded:Connect(added) for _,p in Players:GetPlayers() do added(p) end
 Players.PlayerRemoving:Connect(function(p) profiles[p]=nil requests[p]=nil chains[p]=nil cratePolicy[p]=nil crateAt[p]=nil end)
 action.OnServerEvent:Connect(E.Handle)
 MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p,id,purchased)
  if not purchased or id~=C.LimitedOffer.GamePassId then return end
  local ok,owns=pcall(function() return MarketplaceService:UserOwnsGamePassAsync(p.UserId,id) end)
  if ok and owns then local m=profile(p) if m then m.Weapons.LimitedBlade=true m.EquippedWeapon="LimitedBlade" E.Refresh(p) E.Send(p,"Lame Nova debloquee !") task.spawn(P.Save,p,false) end end
 end)
 MarketplaceService.ProcessReceipt=function(receipt)
  if not C.MonetizationEnabled then return Enum.ProductPurchaseDecision.NotProcessedYet end
  local p=Players:GetPlayerByUserId(receipt.PlayerId) if not p or not profile(p) then return Enum.ProductPurchaseDecision.NotProcessedYet end
  local product for _,v in C.Products do if v.ProductId>0 and v.ProductId==receipt.ProductId then product=v break end end
  if not product then return Enum.ProductPurchaseDecision.NotProcessedYet end
  local ok,granted=pcall(function() return P.GrantReceipt(p,tostring(receipt.PurchaseId),function()
   P.AddRewards(p,product.Kind=="Coins" and product.Amount or 0,product.Kind=="XP" and product.Amount or 0,product.Name)
  end) end)
  if ok and granted then E.Send(p,"Achat recu : "..product.Name) return Enum.ProductPurchaseDecision.PurchaseGranted end
  return Enum.ProductPurchaseDecision.NotProcessedYet
 end
 local shops=workspace:FindFirstChild("RefugeShops")
 if shops then for _,v in shops:GetDescendants() do if v:IsA("ProximityPrompt") then
  v.Triggered:Connect(function(p) local page=v:GetAttribute("ShopPage") if C.Shops[page] and nearShop(p,page) then E.Send(p,nil,page) end end)
 end end end
 task.spawn(function()
  local last=os.clock() local tick=0
  while true do
   task.wait(1) local now=os.clock() local dt=math.min(60,now-last) last=now tick+=1
   for _,p in Players:GetPlayers() do
    local m=profile(p)
    if m then
     if p:GetAttribute("HasStarted")==true then m.Daily.Seconds+=dt end
     E.Refresh(p) if tick%2==0 then E.Send(p) end
    end
   end
  end
 end)
end
return E
