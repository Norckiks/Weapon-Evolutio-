local C={}
C.Zones={
 {Id="City",Name="VILLE EN RUINE",Level=1,Center=Vector3.new(0,0,-120),Half=Vector3.new(200,100,150),Arrival=Vector3.new(0,4,10),Color=Color3.fromRGB(209,170,83),
  Spawns={Vector3.new(-10,4,-80),Vector3.new(10,4,-115),Vector3.new(-8,4,-155),Vector3.new(9,4,-195),Vector3.new(-5,4,-225),Vector3.new(12,4,-245)},
  Types={"Civilian","Runner","Brute"}},
 {Id="Factory",Name="USINE CONDAMNEE",Level=5,Center=Vector3.new(620,0,-120),Half=Vector3.new(145,100,150),Arrival=Vector3.new(620,4,10),Color=Color3.fromRGB(235,132,61),
  Spawns={Vector3.new(588,4,-70),Vector3.new(650,4,-90),Vector3.new(590,4,-135),Vector3.new(648,4,-155),Vector3.new(596,4,-205),Vector3.new(650,4,-230)},
  Types={"Worker","Soldier","Scrapper"}},
 {Id="Lab",Name="LABORATOIRE TOXIQUE",Level=12,Center=Vector3.new(1240,0,-120),Half=Vector3.new(145,100,150),Arrival=Vector3.new(1240,4,10),Color=Color3.fromRGB(125,224,86),
  Spawns={Vector3.new(1208,4,-70),Vector3.new(1270,4,-90),Vector3.new(1210,4,-135),Vector3.new(1275,4,-155),Vector3.new(1200,4,-205),Vector3.new(1278,4,-230)},
  Types={"Hazmat","Stalker","Abomination"}},
 {Id="Harbor",Name="PORT DES CENDRES",Level=20,Center=Vector3.new(1860,0,-120),Half=Vector3.new(145,100,150),Arrival=Vector3.new(1860,4,10),Color=Color3.fromRGB(89,177,208),
  Spawns={Vector3.new(1830,4,-70),Vector3.new(1890,4,-95),Vector3.new(1828,4,-135),Vector3.new(1892,4,-160),Vector3.new(1832,4,-205),Vector3.new(1890,4,-235)},
  Types={"Drowned","Raider","AnchorTitan"}}
}
C.Zombies={
 Civilian={AttackWindup=0.45,AttackRecovery=0.35,Name="Rodeur",Health=35,Speed=7,Damage=4,Coins=8,XP=20,Scale=1,Style="Civilian",Skin=Color3.fromRGB(112,132,84),Cloth=Color3.fromRGB(81,88,107)},
 Runner={AttackWindup=0.32,AttackRecovery=0.3,Name="Affame",Health=50,Speed=13,Damage=6,Coins=12,XP=30,Scale=0.94,Style="Runner",Skin=Color3.fromRGB(141,144,97),Cloth=Color3.fromRGB(118,63,54)},
 Brute={AttackWindup=0.7,AttackRecovery=0.45,Name="Colosse",Health=90,Speed=5,Damage=10,Coins=25,XP=60,Scale=1.35,Style="Brute",Skin=Color3.fromRGB(111,128,77),Cloth=Color3.fromRGB(62,69,59)},
 Worker={AttackWindup=0.48,AttackRecovery=0.35,Name="Ouvrier contamine",Health=120,Speed=8,Damage=10,Coins=35,XP=75,Scale=1.05,Style="Worker",Skin=Color3.fromRGB(125,133,89),Cloth=Color3.fromRGB(166,99,41)},
 Soldier={AttackWindup=0.42,AttackRecovery=0.35,Name="Soldat infecte",Health=160,Speed=10,Damage=12,Coins=50,XP=100,Scale=1.08,Style="Soldier",Skin=Color3.fromRGB(110,130,96),Cloth=Color3.fromRGB(67,83,63)},
 Scrapper={AttackWindup=0.8,AttackRecovery=0.45,Name="Broyeur de fer",Health=240,Speed=6,Damage=16,Coins=80,XP=150,Scale=1.45,Style="Scrapper",Skin=Color3.fromRGB(102,115,87),Cloth=Color3.fromRGB(93,85,69)},
 Hazmat={AttackWindup=0.5,AttackRecovery=0.35,Name="Chercheur toxique",Health=280,Speed=9,Damage=14,Coins=100,XP=180,Scale=1.05,Style="Hazmat",Skin=Color3.fromRGB(121,157,82),Cloth=Color3.fromRGB(184,173,52)},
 Stalker={AttackWindup=0.28,AttackRecovery=0.3,Name="Traqueur mutant",Health=360,Speed=15,Damage=18,Coins=150,XP=250,Scale=1.13,Style="Stalker",Skin=Color3.fromRGB(90,107,128),Cloth=Color3.fromRGB(53,58,71)},
 Abomination={AttackWindup=0.9,AttackRecovery=0.5,Name="Abomination",Health=520,Speed=6,Damage=25,Coins=240,XP=400,Scale=1.7,Style="Abomination",Skin=Color3.fromRGB(117,144,79),Cloth=Color3.fromRGB(60,72,57)},
 Drowned={AttackWindup=0.5,AttackRecovery=0.4,Name="Matelot noye",Health=650,Speed=8,Damage=24,Coins=320,XP=500,Scale=1.08,Template="Civilian",Skin=Color3.fromRGB(102,151,147),Cloth=Color3.fromRGB(57,88,110)},
 Raider={AttackWindup=0.34,AttackRecovery=0.3,Name="Ecumeur des cendres",Health=800,Speed=14,Damage=28,Coins=420,XP=650,Scale=1.04,Template="Runner",Skin=Color3.fromRGB(144,155,126),Cloth=Color3.fromRGB(148,89,55)},
 AnchorTitan={AttackWindup=1.0,AttackRecovery=0.5,Name="Titan de l'ancre",Health=1200,Speed=5,Damage=38,Coins=650,XP=1000,Scale=1.85,Template="Brute",Skin=Color3.fromRGB(111,139,144),Cloth=Color3.fromRGB(60,77,85)}
}
C.RespawnDelay=10
C.AggroRange=48
C.LeashRange=65
C.AttackRange=4.4
C.AttackCooldown=1.5
C.AttackWindup=.45
C.AttackRecovery=.35
C.AttackArc=100
C.KillCreditSeconds=20
function C.RequiredXP(level) return 80+40*(level-1) end
function C.ZoneAt(position)
 for _,zone in C.Zones do
  local d=position-zone.Center
  if math.abs(d.X)<=zone.Half.X and math.abs(d.Z)<=zone.Half.Z and position.Y>-20 and position.Y<180 then return zone end
 end
 return nil
end
return C
