local C=require(script.Parent:WaitForChild("GameplayConfig"))
local V={}
function V.Build(id)
 local d=C.Weapons[id] local m=Instance.new("Model") m.Name="EquippedWeaponVisual" local pieces={}
 local function p(name,size,cf,color,shape,material)
  local x=Instance.new("Part") x.Name=name x.Size=size x.CFrame=cf x.Color=color
  x.Material=material or Enum.Material.SmoothPlastic x.Shape=shape or Enum.PartType.Block
  x.Anchored=true x.CanCollide=false x.CanTouch=false x.CanQuery=false x.CastShadow=false x.Parent=m
  table.insert(pieces,{part=x,rel=cf}) return x
 end
 if not d or id=="Fists" then return m,pieces end
 local ink=Color3.fromRGB(36,43,63) local metal=Color3.fromRGB(209,235,242)
 local gold=Color3.fromRGB(255,196,64)
 local function ring(name,y,r,color)
  return p(name,Vector3.new(.09,r,r),CFrame.new(0,y,0)*CFrame.Angles(0,0,math.pi/2),color,Enum.PartType.Cylinder,Enum.Material.Metal)
 end
 local function bolt(x,y,z)
  p("HexRivet",Vector3.new(.1,.1,.06),CFrame.new(x,y,z)*CFrame.Angles(0,0,math.pi/4),gold,nil,Enum.Material.Metal)
 end
 if not d.Firearm then
 p("Grip",Vector3.new(0.16,0.65,0.18),CFrame.identity,ink)
 for i=1,6 do p("GripWrap",Vector3.new(0.21,0.055,0.23),CFrame.new(0,-0.31+i*0.10,0)*CFrame.Angles(0,0,-.18),d.Color) end
 ring("Pommel",-.37,.26,gold)
 end
 if id=="Shotgun" then
  p("Grip",Vector3.new(.28,.62,.32),CFrame.new(0,-.04,.12)*CFrame.Angles(-.25,0,0),ink)
  p("Receiver",Vector3.new(.38,.39,.86),CFrame.new(0,.36,-.2),ink,nil,Enum.Material.Metal)
  p("ReceiverPlate",Vector3.new(.02,.22,.57),CFrame.new(.2,.38,-.19),metal,nil,Enum.Material.Metal)
  p("EjectionPort",Vector3.new(.025,.12,.23),CFrame.new(.214,.4,-.22),ink)
  p("Stock",Vector3.new(.32,.42,.75),CFrame.new(0,.17,.57)*CFrame.Angles(.16,0,0),d.Color)
  p("ButtPad",Vector3.new(.36,.49,.1),CFrame.new(0,.11,.98)*CFrame.Angles(.16,0,0),ink)
  p("Barrel",Vector3.new(1.65,.22,.22),CFrame.new(0,.5,-1.38)*CFrame.Angles(0,math.pi/2,0),metal,Enum.PartType.Cylinder,Enum.Material.Metal)
  p("MagazineTube",Vector3.new(1.34,.19,.19),CFrame.new(0,.22,-1.16)*CFrame.Angles(0,math.pi/2,0),ink,Enum.PartType.Cylinder,Enum.Material.Metal)
  p("Foreend",Vector3.new(.35,.28,.6),CFrame.new(0,.2,-1.12),d.Color)
  for i=1,5 do p("PumpRib",Vector3.new(.38,.31,.035),CFrame.new(0,.2,-.82-i*.1),ink) end
  p("Muzzle",Vector3.new(.28,.28,.1),CFrame.new(0,.5,-2.24),ink,nil,Enum.Material.Metal)
  p("Bore",Vector3.new(.16,.16,.012),CFrame.new(0,.5,-2.296),Color3.fromRGB(8,12,18))
  p("FrontSight",Vector3.new(.07,.1,.08),CFrame.new(0,.67,-2.1),gold)
  p("RearSight",Vector3.new(.25,.09,.08),CFrame.new(0,.6,.08),d.Color)
  p("TriggerGuard",Vector3.new(.1,.08,.42),CFrame.new(0,-.05,-.18),ink)
  p("GuardFront",Vector3.new(.1,.25,.08),CFrame.new(0,.04,-.39),ink)
  p("Trigger",Vector3.new(.06,.16,.06),CFrame.new(0,.08,-.18),gold)
  for i=1,3 do
   p("SpareShell",Vector3.new(.1,.27,.1),CFrame.new(-.25,.35,.1-i*.17),d.Color)
   p("ShellBrass",Vector3.new(.11,.05,.11),CFrame.new(-.25,.19,.1-i*.17),gold,nil,Enum.Material.Metal)
  end
 elseif id=="Revolver" then
  p("Grip",Vector3.new(.3,.65,.32),CFrame.new(0,-.06,.09)*CFrame.Angles(-.23,0,0),ink)
  for _,x in {-.16,.16} do
   p("WoodGrip",Vector3.new(.025,.44,.28),CFrame.new(x,-.08,.10)*CFrame.Angles(-.23,0,0),d.Color)
   p("GripMedallion",Vector3.new(.035,.1,.1),CFrame.new(x,-.02,.1),gold,Enum.PartType.Cylinder,Enum.Material.Metal)
  end
  p("Frame",Vector3.new(.27,.31,.95),CFrame.new(0,.36,-.2),ink,nil,Enum.Material.Metal)
  p("TopStrap",Vector3.new(.27,.09,.75),CFrame.new(0,.65,-.25),metal,nil,Enum.Material.Metal)
  p("Barrel",Vector3.new(.28,.28,.82),CFrame.new(0,.47,-1.02),metal,nil,Enum.Material.Metal)
  p("BarrelRib",Vector3.new(.1,.055,.83),CFrame.new(0,.64,-1.02),ink,nil,Enum.Material.Metal)
  p("Muzzle",Vector3.new(.32,.32,.11),CFrame.new(0,.47,-1.47),ink,nil,Enum.Material.Metal)
  p("Bore",Vector3.new(.15,.15,.014),CFrame.new(0,.47,-1.533),Color3.fromRGB(8,12,18),Enum.PartType.Block)
  local cylinder=CFrame.new(0,.37,-.29)*CFrame.Angles(0,math.pi/2,0)
  p("Cylinder",Vector3.new(.5,.52,.52),cylinder,metal,Enum.PartType.Cylinder,Enum.Material.Metal)
  for i=0,5 do
   local a=i*math.pi/3 local x,y=math.cos(a)*.17,.37+math.sin(a)*.17
   p("ChamberRim",Vector3.new(.025,.115,.115),CFrame.new(x,y,-.026)*CFrame.Angles(0,math.pi/2,0),gold,Enum.PartType.Cylinder,Enum.Material.Metal)
   p("ChamberPrimer",Vector3.new(.03,.046,.046),CFrame.new(x,y,-.01)*CFrame.Angles(0,math.pi/2,0),ink,Enum.PartType.Cylinder)
  end
  p("CylinderAxle",Vector3.new(.08,.08,.72),CFrame.new(0,.37,-.29),ink,nil,Enum.Material.Metal)
  p("EjectorRod",Vector3.new(.07,.07,.65),CFrame.new(.17,.23,-.83),ink,nil,Enum.Material.Metal)
  p("Hammer",Vector3.new(.16,.2,.14),CFrame.new(0,.60,.24)*CFrame.Angles(-.35,0,0),gold,nil,Enum.Material.Metal)
  p("TriggerGuard",Vector3.new(.11,.08,.45),CFrame.new(0,-.05,-.25),ink)
  p("GuardFront",Vector3.new(.11,.27,.08),CFrame.new(0,.04,-.48),ink)
  p("Trigger",Vector3.new(.06,.16,.06),CFrame.new(0,.09,-.2)*CFrame.Angles(-.25,0,0),gold)
  p("RearSight",Vector3.new(.26,.08,.09),CFrame.new(0,.72,.08),d.Color)
  p("FrontSight",Vector3.new(.07,.1,.08),CFrame.new(0,.72,-1.35),d.Color)
 elseif id=="SMG" then
  p("Grip",Vector3.new(.28,.65,.3),CFrame.new(0,-.03,.12)*CFrame.Angles(-.15,0,0),ink)
  p("Receiver",Vector3.new(.4,.38,1.2),CFrame.new(0,.37,-.27),ink,nil,Enum.Material.Metal)
  p("UpperRail",Vector3.new(.28,.1,1.05),CFrame.new(0,.61,-.3),metal,nil,Enum.Material.Metal)
  p("Handguard",Vector3.new(.36,.32,.55),CFrame.new(0,.32,-.93),d.Color)
  p("Barrel",Vector3.new(.14,.14,.46),CFrame.new(0,.4,-1.38),metal,nil,Enum.Material.Metal)
  p("Muzzle",Vector3.new(.22,.22,.2),CFrame.new(0,.4,-1.62),ink,nil,Enum.Material.Metal)
  p("Bore",Vector3.new(.1,.1,.012),CFrame.new(0,.4,-1.727),Color3.fromRGB(8,12,18))
  p("Magazine",Vector3.new(.24,.68,.3),CFrame.new(0,-.2,-.43)*CFrame.Angles(.12,0,0),metal,nil,Enum.Material.Metal)
  p("MagazineBase",Vector3.new(.29,.09,.35),CFrame.new(0,-.56,-.47),d.Color)
  p("StockBeam",Vector3.new(.12,.12,.6),CFrame.new(0,.35,.6),metal,nil,Enum.Material.Metal)
  p("StockPad",Vector3.new(.3,.5,.12),CFrame.new(0,.18,.93),ink)
  p("RearSight",Vector3.new(.25,.12,.08),CFrame.new(0,.72,.12),d.Color)
  p("FrontSight",Vector3.new(.08,.12,.08),CFrame.new(0,.72,-.76),d.Color)
  p("TriggerGuard",Vector3.new(.1,.08,.38),CFrame.new(0,-.04,-.14),ink)
  p("Trigger",Vector3.new(.06,.18,.06),CFrame.new(0,.06,-.12),gold)
  for i=1,4 do
   p("CoolingVent",Vector3.new(.37,.045,.055),CFrame.new(0,.34,-.71-i*.1),ink)
   p("GripRidge",Vector3.new(.3,.035,.31),CFrame.new(0,-.23+i*.09,.12),d.Color)
  end
 elseif id=="Pistol" then
  p("Grip",Vector3.new(.29,.62,.31),CFrame.new(0,-.02,.03)*CFrame.Angles(math.rad(-12),0,0),ink)
  for _,x in {-.153,.153} do
   p("GripPanel",Vector3.new(.018,.4,.23),CFrame.new(x,-.04,.035)*CFrame.Angles(math.rad(-12),0,0),d.Color)
   for i=1,4 do p("GripTexture",Vector3.new(.023,.025,.23),CFrame.new(x,-.23+i*.08,.035)*CFrame.Angles(math.rad(-12),0,0),ink) end
  end
  p("Magazine",Vector3.new(.26,.47,.25),CFrame.new(0,-.18,.03),metal,nil,Enum.Material.Metal)
  p("MagazineBase",Vector3.new(.34,.09,.36),CFrame.new(0,-.43,.03),d.Color)
  p("Receiver",Vector3.new(.36,.28,.92),CFrame.new(0,.35,-.28),ink,nil,Enum.Material.Metal)
  p("Slide",Vector3.new(.32,.18,.95),CFrame.new(0,.56,-.3),metal,nil,Enum.Material.Metal)
  p("Muzzle",Vector3.new(.22,.22,.12),CFrame.new(0,.4,-.81),ink,nil,Enum.Material.Metal)
  p("Bore",Vector3.new(.1,.1,.015),CFrame.new(0,.4,-.877),Color3.fromRGB(8,12,18))
  p("RearSight",Vector3.new(.26,.09,.09),CFrame.new(0,.69,.08),d.Color)
  p("FrontSight",Vector3.new(.07,.09,.09),CFrame.new(0,.69,-.7),d.Color)
  p("TriggerGuard",Vector3.new(.12,.09,.48),CFrame.new(0,-.04,-.31),ink)
  p("GuardFront",Vector3.new(.12,.28,.08),CFrame.new(0,.08,-.51),ink)
  p("Trigger",Vector3.new(.07,.18,.06),CFrame.new(0,.09,-.25)*CFrame.Angles(math.rad(-18),0,0),gold,nil,Enum.Material.Metal)
  p("EjectionPort",Vector3.new(.012,.1,.21),CFrame.new(.167,.56,-.24),ink)
  p("SlideAccent",Vector3.new(.014,.035,.38),CFrame.new(-.168,.56,-.36),d.Color)
  for i=1,4 do p("SlideGroove",Vector3.new(.34,.12,.035),CFrame.new(0,.56,.09-i*.07),ink) end
 elseif id=="Pipe" then
  p("Pipe",Vector3.new(0.2,1.9,0.2),CFrame.new(0,0.9,0),d.Color,nil,Enum.Material.Metal)
  p("Elbow",Vector3.new(0.55,0.22,0.22),CFrame.new(0.17,1.8,0),metal,nil,Enum.Material.Metal)
  for _,y in {.38,1.5,1.7} do ring("IndustrialCollar",y,.32,ink) end
  p("PipeMouth",Vector3.new(.045,.16,.16),CFrame.new(.46,1.8,0),ink,Enum.PartType.Cylinder)
  p("ValveStem",Vector3.new(.45,.09,.09),CFrame.new(.16,1.25,0),gold)
  p("ValveWheel",Vector3.new(.07,.42,.42),CFrame.new(.4,1.25,0),Color3.fromRGB(244,100,81),Enum.PartType.Cylinder)
  bolt(.445,1.25,0)
 elseif id=="Bat" then
  p("WoodBarrel",Vector3.new(0.33,1.55,0.33),CFrame.new(0,1,0),d.Color)
  for i=1,3 do p("Spike",Vector3.new(0.75,0.07,0.07),CFrame.new(0,0.9+i*0.24,0)*CFrame.Angles(0,math.rad(i*50),0),metal,nil,Enum.Material.Metal) end
  ring("EndCap",1.79,.39,ink)
  for _,y in {.65,1.46} do ring("ReinforcedBand",y,.4,metal) end
  for i=1,3 do p("WoodGrain",Vector3.new(.025,.66,.018),CFrame.new((i-2)*.09,1.03,-.174)*CFrame.Angles(0,0,.08*i),Color3.fromRGB(112,67,43)) end
  p("WarningStripe",Vector3.new(.35,.13,.35),CFrame.new(0,1.63,0),gold)
 elseif id=="Axe" then
  p("Shaft",Vector3.new(0.17,1.9,0.18),CFrame.new(0,0.8,0),Color3.fromRGB(155,111,69))
  p("AxeHead",Vector3.new(0.95,0.55,0.19),CFrame.new(0.22,1.55,0)*CFrame.Angles(0,0,0.15),d.Color,nil,Enum.Material.Metal)
  p("Edge",Vector3.new(0.13,0.62,0.21),CFrame.new(0.72,1.55,0)*CFrame.Angles(0,0,0.15),metal,nil,Enum.Material.Metal)
  p("HeadReinforcement",Vector3.new(.2,.64,.25),CFrame.new(.07,1.55,0),ink,nil,Enum.Material.Metal)
  for _,z in {-.145,.145} do bolt(.07,1.38,z) bolt(.07,1.7,z) end
  p("RescuePick",Vector3.new(.34,.15,.16),CFrame.new(-.4,1.7,0)*CFrame.Angles(0,0,-.25),metal,nil,Enum.Material.Metal)
  for i=1,3 do p("SafetyGrip",Vector3.new(.2,.11,.21),CFrame.new(0,.55+i*.2,0),ink) end
 else
  p("Guard",Vector3.new(0.65,0.1,0.38),CFrame.new(0,0.37,0),d.Color,nil,Enum.Material.Metal)
  p("Blade",Vector3.new(0.18,2.2,0.09),CFrame.new(0,1.5,0),id=="LimitedBlade" and d.Color or metal,nil,id=="LimitedBlade" and Enum.Material.Neon or Enum.Material.Metal)
  p("BladeEdge",Vector3.new(0.035,2.2,0.1),CFrame.new(0.11,1.5,0),Color3.fromRGB(241,255,246),nil,id=="LimitedBlade" and Enum.Material.Neon or Enum.Material.Metal)
  ring("GuardInlay",.4,.35,gold)
  p("BladeSpine",Vector3.new(.055,2.15,.13),CFrame.new(-.11,1.48,0),ink,nil,Enum.Material.Metal)
  p("AngledTip",Vector3.new(.14,.28,.09),CFrame.new(.025,2.66,0)*CFrame.Angles(0,0,-.27),metal,nil,Enum.Material.Metal)
  if id=="LimitedBlade" then
   for i=1,5 do p("NovaRune",Vector3.new(.12,.12,.11),CFrame.new(0,.65+i*.32,0)*CFrame.Angles(0,0,math.pi/4),Color3.fromRGB(230,197,255),nil,Enum.Material.Neon) end
   for _,sign in {-1,1} do p("NovaWing",Vector3.new(.16,.48,.15),CFrame.new(sign*.33,.52,0)*CFrame.Angles(0,0,-sign*.55),d.Color,nil,Enum.Material.Neon) end
  else
   for i=1,4 do p("BladeEtching",Vector3.new(.09,.025,.012),CFrame.new(0,.65+i*.12,-.052),d.Color,nil,Enum.Material.Neon) end
  end
 end
 m.PrimaryPart=pieces[1].part return m,pieces
end
return V
