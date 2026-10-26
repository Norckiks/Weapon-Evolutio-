local Players=game:GetService("Players")
local CAS=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local remote=game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("MovementAction")
local Config=require(game.ReplicatedStorage:WaitForChild("MovementConfig"))
local Audio=require(game.ReplicatedStorage:WaitForChild("PresentationConfig")).Audio
local Debris=game:GetService("Debris")
remote.OnClientEvent:Connect(function(kind,character,expires,direction)
 if kind~="VaultAccepted" or character~=player.Character or typeof(expires)~="number" or typeof(direction)~="Vector3" then return end
 local remaining=expires-workspace:GetServerTimeNow()
 if remaining<=0 or remaining>1 or direction~=direction or direction.Magnitude<.9 or direction.Magnitude>1.1 then return end
 local h=character:FindFirstChildOfClass("Humanoid") local root=character:FindFirstChild("HumanoidRootPart")
 if not h or not root or h.Health<=0 or root.Anchored or h.FloorMaterial==Enum.Material.Air then return end
 h:ChangeState(Enum.HumanoidStateType.Freefall)
 root.AssemblyLinearVelocity=direction*Config.VaultForwardSpeed+Vector3.new(0,math.max(root.AssemblyLinearVelocity.Y,Config.VaultUpSpeed),0)
end)
local soundConnections={}
local function sound(character,id,volume,pitch)
 if player:GetAttribute("SFXEnabled")==false then return end
 local root=character:FindFirstChild("HumanoidRootPart") if not root then return end
 local s=Instance.new("Sound") s.Name="MovementFoley" s.SoundId=id s.Volume=volume s.PlaybackSpeed=pitch s.RollOffMaxDistance=35 s.RollOffMinDistance=4 s.SoundGroup=game.SoundService:FindFirstChild("WorldFoley") s.Parent=root s:Play() Debris:AddItem(s,2)
end
local function bindSounds(character)
 for _,connection in soundConnections do connection:Disconnect() end table.clear(soundConnections)
 for _,item in {{"Sliding",Audio.Cloth,.38,.75},{"Vaulting",Audio.Cloth,.3,1.2},{"Crouching",Audio.Cloth,.18,.9}} do
  table.insert(soundConnections,character:GetAttributeChangedSignal(item[1]):Connect(function() if character:GetAttribute(item[1]) then sound(character,item[2],item[3],item[4]) end end))
 end
 local humanoid=character:WaitForChild("Humanoid",10) if not humanoid or character~=player.Character then return end
 table.insert(soundConnections,humanoid.StateChanged:Connect(function(old,new)
  if old==Enum.HumanoidStateType.Freefall and new==Enum.HumanoidStateType.Landed then sound(character,Audio.StepConcrete,.25,.85) end
 end))
end
player.CharacterAdded:Connect(bindSounds) if player.Character then task.spawn(bindSounds,player.Character) end
local function allowed()
 return player:GetAttribute("HasStarted")==true and not player:GetAttribute("GameMenuOpen") and not player:GetAttribute("OptionsOpen") and not UIS:GetFocusedTextBox()
end
local function action(verb)
 return function(_,state)
  if not allowed() then return Enum.ContextActionResult.Pass end
  if state==Enum.UserInputState.Begin then remote:FireServer(verb) end
  return Enum.ContextActionResult.Sink
 end
end
CAS:BindAction("SurvivalCrouch",action("Crouch"),true,Enum.KeyCode.C,Enum.KeyCode.ButtonR1)
CAS:SetTitle("SurvivalCrouch","GLISSE")
CAS:BindAction("SurvivalVault",action("Vault"),true,Enum.KeyCode.V,Enum.KeyCode.ButtonY)
CAS:SetTitle("SurvivalVault","FRANCHIR")
local gui=Instance.new("ScreenGui") gui.Name="MovementHUD" gui.IgnoreGuiInset=true gui.ResetOnSpawn=false gui.DisplayOrder=12 gui.Parent=player:WaitForChild("PlayerGui")
local label=Instance.new("TextLabel") label.Name="MovementHint" label.AnchorPoint=Vector2.new(.5,1) label.Position=UDim2.new(.5,0,1,-62) label.Size=UDim2.fromOffset(320,24) label.BackgroundColor3=Color3.fromRGB(38,48,68) label.BackgroundTransparency=.15 label.TextColor3=Color3.fromRGB(255,244,216) label.Font=Enum.Font.Cartoon label.TextSize=12 label.Parent=gui
local corner=Instance.new("UICorner") corner.CornerRadius=UDim.new(0,10) corner.Parent=label
local offset=0
RunService:BindToRenderStep("SurvivalMovementPresentation",Enum.RenderPriority.Camera.Value+2,function(dt)
 local c=player.Character local h=c and c:FindFirstChildOfClass("Humanoid")
 local active=allowed() and h and h.Health>0 label.Visible=active==true
 if not h then offset=0 return end
 local slide=c:GetAttribute("Sliding")==true local crouch=c:GetAttribute("Crouching")==true local vault=c:GetAttribute("Vaulting")==true
 local target=active and (slide and -.7 or crouch and -.45 or 0) or 0
 offset+=(target-offset)*(1-math.exp(-dt*12)) h.CameraOffset=Vector3.new(0,offset,0)
 if active then
  local state=slide and "GLISSADE" or crouch and "ACCROUPI" or vault and "FRANCHISSEMENT" or ""
  label.Text=state~="" and state or UIS.TouchEnabled and "GLISSE en courant · FRANCHIR un obstacle" or UIS.GamepadEnabled and "R1 : accroupi / glisse · Y : franchir" or "C : accroupi / glisse · V : franchir"
  if UIS.TouchEnabled then label.Visible=state~="" end
 end
 local width=workspace.CurrentCamera.ViewportSize.X label.Size=UDim2.fromOffset(math.min(320,width-30),24)
end)
