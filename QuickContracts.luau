local Q={}
Q.Definitions={
 {Name="Premiere sortie",Description="Elimine 3 zombies",Target=3,Coins=40,XP=20},
 {Name="Chasseur polyvalent",Description="Elimine 2 especes differentes",Target=2,Coins=60,XP=30,Variety=true},
 {Name="Nettoyage express",Description="Elimine 7 zombies",Target=7,Coins=100,XP=60},
}
function Q.Ensure(meta)
 local s=meta.QuickContract
 if typeof(s)~="table" then s={} meta.QuickContract=s end
 local index=s.Index
 if typeof(index)~="number" or index~=index or index<1 or index>#Q.Definitions or index%1~=0 then index=1 end
 s.Index=index
 local count=s.Count
 if typeof(count)~="number" or count~=count then count=0 end
 s.Count=math.clamp(math.floor(count),0,Q.Definitions[index].Target-1)
 if typeof(s.Seen)~="table" then s.Seen={} end
 return s,Q.Definitions[index]
end
function Q.OnKill(meta,species)
 local s,d=Q.Ensure(meta)
 if d.Variety then
  if s.Seen[species] then return end
  s.Seen[species]=true
 end
 s.Count+=1
 if s.Count<d.Target then return end
 -- Advance before awarding: a completed contract cannot be claimed again.
 s.Index=s.Index%#Q.Definitions+1 s.Count=0 s.Seen={}
 return d
end
return Q
