local C={}
C.HeadshotMultiplier=1.5
C.KillChain={Window=8}
C.Dash={Cooldown=3.5,Cost=25,Speed=65,Duration=0.18}
C.Pulse={Level=5,Cost=30,Cooldown=14,Range=14,Damage=20,Stun=.7,Knockback=38,MaxTargets=12}
C.Abilities={Slam={Name="Frappe tellurique",Key="E",Level=8,Cost=34,Cooldown=12,Range=10,Damage=34,Stun=1.1,Knockback=54,MaxTargets=8,Shape="Circle",Color=Color3.fromRGB(255,174,73)},Frost={Name="Lance cryo",Key="R",Level=12,Cost=32,Cooldown=18,Range=70,Width=4.5,Damage=30,Stun=1.7,Knockback=12,MaxTargets=1,Shape="Beam",Color=Color3.fromRGB(93,220,255)},Aegis={Name="Égide astrale",Key="H",Level=16,Cost=30,Cooldown=24,Duration=3.2,Color=Color3.fromRGB(184,133,255)},SecondSouffle={Name="Second souffle",Key="G",Level=20,Cost=30,Cooldown=28,Heal=.35,Color=Color3.fromRGB(111,235,166)}}
C.Upgrades={Health={Name="Vitalite",Max=10,BaseCost=100,Factor=1.7,Step=20},Speed={Name="Agilite",Max=8,BaseCost=150,Factor=1.85,Step=0.8}}
function C.UpgradeCost(id,level) local d=C.Upgrades[id] return math.floor(d.BaseCost*d.Factor^level) end
C.WeaponOrder={"Fists","Pipe","Bat","Pistol","Axe","SMG","Revolver","Katana","Shotgun","LimitedBlade"}
C.Weapons={
 Shotgun={Name="Fusil a pompe des quais",ShortName="FUSIL POMPE",Cost=11500,Level=16,Damage=20,Range=75,Cooldown=.95,Color=Color3.fromRGB(236,145,78),Firearm=true,Magazine=5,ReloadTime=2.9,Pellets=7,Spread=4.5},
 Revolver={Name="Revolver du pisteur",ShortName="REVOLVER",Cost=6800,Level=12,Damage=72,Range=180,Cooldown=.72,Color=Color3.fromRGB(233,151,86),Firearm=true,Magazine=6,ReloadTime=2.6},
 SMG={Name="Mitraillette du recuperateur",ShortName="MITRAILLETTE",Cost=4200,Level=7,Damage=14,Range=105,Cooldown=.11,Color=Color3.fromRGB(84,210,200),Firearm=true,Magazine=24,ReloadTime=2.1},
 Pistol={Name="Pistolet du refuge",Cost=1400,Level=3,Damage=24,Range=150,Cooldown=.28,Color=Color3.fromRGB(255,190,66),Firearm=true,Magazine=12,ReloadTime=1.6},
 Fists={Name="Poings",Cost=0,Level=1,Damage=10,Range=6.5,Cooldown=0.4,Color=Color3.fromRGB(155,117,71)},
 Pipe={Name="Tuyau de recuperation",Cost=150,Level=1,Damage=16,Range=7,Cooldown=0.46,Color=Color3.fromRGB(125,157,167)},
 Bat={Name="Batte a pointes",Cost=650,Level=2,Damage=28,Range=7.5,Cooldown=0.54,Color=Color3.fromRGB(163,109,65)},
 Axe={Name="Hache de secours",Cost=2200,Level=5,Damage=48,Range=7.5,Cooldown=0.65,Color=Color3.fromRGB(227,92,68)},
 Katana={Name="Lame du survivant",Cost=8500,Level=12,Damage=80,Range=8,Cooldown=0.48,Color=Color3.fromRGB(89,211,204)},
 LimitedBlade={Name="Lame Nova · edition limitee",Premium=true,Level=1,Damage=55,Range=8,Cooldown=0.5,Color=Color3.fromRGB(173,118,255)}
}
C.PetOrder={"Civilian","Runner","Brute","Worker","Soldier","Scrapper","Hazmat","Stalker","Abomination","Drowned","Raider","AnchorTitan","Buddy"}
C.Pets={
 Drowned={Name="Crabi",Coins=.45,XP=.20,Speed=0,Color=Color3.fromRGB(107,200,207),Shape="Crab"},
 Raider={Name="Requinou",Coins=.15,XP=.30,Speed=.18,Color=Color3.fromRGB(147,177,208),Shape="Shark"},
 AnchorTitan={Name="Krakenou",Coins=.50,XP=.45,Speed=.06,Color=Color3.fromRGB(187,144,224),Shape="Kraken"},
 Civilian={Name="Mini Rodeur",Coins=0.10,XP=0.05,Speed=0,Color=Color3.fromRGB(126,212,146),Shape="Cat"},
 Runner={Name="Zippy",Coins=0,XP=0.08,Speed=0.08,Color=Color3.fromRGB(105,212,237),Shape="Rabbit"},
 Brute={Name="Mini Colosse",Coins=0.20,XP=0,Speed=0,Color=Color3.fromRGB(238,170,88),Shape="Bear"},
 Worker={Name="Boulon",Coins=0.18,XP=0.12,Speed=0,Color=Color3.fromRGB(255,187,73),Shape="Robot"},
 Soldier={Name="Sentinelle",Coins=0.12,XP=0.20,Speed=0,Color=Color3.fromRGB(128,177,117),Shape="Bear"},
 Scrapper={Name="Ferraille",Coins=0.30,XP=0.08,Speed=0,Color=Color3.fromRGB(176,188,206),Shape="Robot"},
 Hazmat={Name="Gloop",Coins=0.12,XP=0.30,Speed=0,Color=Color3.fromRGB(181,236,82),Shape="Alien"},
 Stalker={Name="Spectre",Coins=0.08,XP=0.15,Speed=0.15,Color=Color3.fromRGB(182,148,238),Shape="Bat"},
 Abomination={Name="Titanou",Coins=0.35,XP=0.35,Speed=0.05,Color=Color3.fromRGB(243,116,138),Shape="Alien"},
 Buddy={Name="Buddy du refuge",Coins=0.10,XP=0.10,Speed=0.03,Color=Color3.fromRGB(255,213,107),Shape="Dog"}
}
C.TimeRewards={
 {Seconds=300,Name="Echauffement",Description="XP x2 pendant 10 minutes",Kind="XPBoost",Amount=600},
 {Seconds=600,Name="Ravitaillement",Description="150 pieces",Kind="Coins",Amount=150},
 {Seconds=900,Name="Petit echantillon",Description="1 fragment de Rodeur",Kind="Fragment",Id="Civilian",Amount=1},
 {Seconds=1200,Name="Chasseur de tresors",Description="Pieces x2 pendant 10 minutes",Kind="CoinBoost",Amount=600},
 {Seconds=1800,Name="Un nouvel ami",Description="Pet Buddy gratuit : +10% pieces et XP",Kind="Pet",Id="Buddy",Amount=1},
 {Seconds=2700,Name="Fusion express",Description="3 fragments d'Affame",Kind="Fragment",Id="Runner",Amount=3},
 {Seconds=3600,Name="Veteran",Description="1000 pieces",Kind="Coins",Amount=1000},
 {Seconds=5400,Name="Expert",Description="2000 XP",Kind="XP",Amount=2000},
 {Seconds=7200,Name="Expedition toxique",Description="3 fragments de Chercheur toxique",Kind="Fragment",Id="Hazmat",Amount=3}
}
C.Missions={{Kills=10,Coins=120,XP=60},{Kills=30,Coins=400,XP=180},{Kills=75,Coins=1200,XP=600},{Kills=150,Coins=3000,XP=1500}}
-- Intentionally disabled. Configure IDs and the real sale deadline before enabling.
C.MonetizationEnabled=false
C.Products={{Key="CoinsSmall",Name="1000 pieces",Kind="Coins",Amount=1000,ProductId=0},{Key="CoinsLarge",Name="6000 pieces",Kind="Coins",Amount=6000,ProductId=0},{Key="XPSmall",Name="1000 XP",Kind="XP",Amount=1000,ProductId=0},{Key="XPLarge",Name="6000 XP",Kind="XP",Amount=6000,ProductId=0}}
C.LimitedOffer={GamePassId=0,Weapon="LimitedBlade",SaleEndsAt=0}
C.Shops={Upgrades=Vector3.new(-26,0,191),Weapons=Vector3.new(26,0,191),Robux=Vector3.new(39,0,172),Pets=Vector3.new(-43,0,186)}
return C
