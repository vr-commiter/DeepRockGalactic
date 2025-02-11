local truegear = require "truegear"

local hookIds = {}
local hookIds1 = {}
local hookIds2 = {}
local hookIds3 = {}
local resetHook = true
local resetHook1 = true
local resetHook2 = true
local resetHook3 = true

local nonVRHookids = {}
local vrHookids = {}
local canDroppod = false

local deployTime = 0
local isGrapping = false
local isDepositing = false
local playerType = nil
local isDroppodDrilling = false
local buildPipelineTime = 0
local isDoubleDrillsDrilling = false
local isJetBoots = false

local lastHealth = 9999
local hoverBootsTime = 0
local isShardDiffractorBeam = false

local progressPercent = 0
local interactTime = 0

local pickaxeHitPoint = {
    X = 0,
    Y = 0,
    Z = 0
}

local lastDefrostProgress = 10
local isRegisterPickaxe = false
local pickaxeTime = 0
local isPause = false
local isRegisterNonVR = false
local isRegisterVR = false

function SendMessage(context)
	if context then
		print(context .. "\n")
		return
	end
	print("nil\n")
end


function BaseOnDroppodImpactRegister()
	for k,v in pairs(hookIds1) do
		UnregisterHook(k, v.id1, v.id2)
	end
		
	hookIds1 = {}
    
    local funcName = "/Game/UI/ScreenOverlays/ScreenOverlay_ShieldDamage.ScreenOverlay_ShieldDamage_C:OnArmorDamaged"
	local hook3, hook4 = RegisterHook(funcName, OnArmorDamaged)
	hookIds1[funcName] = { id1 = hook3; id2 = hook4 }
    
    local funcName = "/Game/UI/ScreenOverlays/ScreenOverlay_HealthDamage.ScreenOverlay_HealthDamage_C:OnDamageTaken_Event"
	local hook3, hook4 = RegisterHook(funcName, OnDamageTaken)
	hookIds1[funcName] = { id1 = hook3; id2 = hook4 }

    local funcName = "/Game/WeaponsNTools/SentryGun/SentryGun_Engineer/HUD_SentryGunWidget.HUD_SentryGunWidget_C:OnDeployProgress_Event"
	local hook3, hook4 = RegisterHook(funcName, OnDeployProgress_Event)
	hookIds1[funcName] = { id1 = hook3; id2 = hook4 }

	local funcName = "/Game/UI/MainOnscreenHUD/Resources/HUD_Resources_Team.HUD_Resources_Team_C:OnDepositingBegin_Event"
	local hook3, hook4 = RegisterHook(funcName, OnDepositingBegin_Event)
	hookIds1[funcName] = { id1 = hook3; id2 = hook4 }
    
	local funcName = "/Game/UI/MainOnscreenHUD/Resources/HUD_Resources_Team.HUD_Resources_Team_C:OnDepositingEnd_Event"
	local hook3, hook4 = RegisterHook(funcName, OnDepositingEnd_Event)
	hookIds1[funcName] = { id1 = hook3; id2 = hook4 }    

    local funcName = "/Game/GameElements/Resources/Collectibles/BP_Collectible_Base.BP_Collectible_Base_C:BndEvt__InstantUsable_K2Node_ComponentBoundEvent_2_UsedBySignature__DelegateSignature"
	local hook3, hook4 = RegisterHook(funcName, OnAnnounceAnimFinished)
	hookIds1[funcName] = { id1 = hook3; id2 = hook4 }
    
    local funcName = "/Game/UI/MainOnscreenHUD/HUD_Health_Base.HUD_Health_Base_C:HealthChanged"
	local hook3, hook4 = RegisterHook(funcName, SetHealth)
	hookIds1[funcName] = { id1 = hook3; id2 = hook4 }
end

function DrillerRegister()
    for k,v in pairs(hookIds2) do
		UnregisterHook(k, v.id1, v.id2)
	end
		
	hookIds2 = {}

    local funcName = "/Game/WeaponsNTools/DetPack/BP_DetPack_Charge.BP_DetPack_Charge_C:OnExploded"
	local hook5, hook6 = RegisterHook(funcName, UseCharge)
	hookIds2[funcName] = { id1 = hook5; id2 = hook6 }

    local funcName = "/Game/WeaponsNTools/DetPack/BP_DetPack_Charge.BP_DetPack_Charge_C:ReceiveBeginPlay"
	local hook5, hook6 = RegisterHook(funcName, ChargeReceiveBeginPlay)
	hookIds2[funcName] = { id1 = hook5; id2 = hook6 }

    
    local funcName = "/Game/WeaponsNTools/Drills/WPN_DoubleDrills.WPN_DoubleDrills_C:OnStartDrilling"
	local hook5, hook6 = RegisterHook(funcName, OnStartDrilling)
	hookIds2[funcName] = { id1 = hook5; id2 = hook6 }

    local funcName = "/Game/WeaponsNTools/Drills/WPN_DoubleDrills.WPN_DoubleDrills_C:OnStopDrilling"
	local hook5, hook6 = RegisterHook(funcName, OnStopDrilling)
	hookIds2[funcName] = { id1 = hook5; id2 = hook6 }
end

function GunnerRegister()
    for k,v in pairs(hookIds3) do
		UnregisterHook(k, v.id1, v.id2)
	end
		
	hookIds3 = {}

    local funcName = "/Game/WeaponsNTools/ShieldGenerator/WPN_ShieldRegeneratorItem.WPN_ShieldRegeneratorItem_C:ReceiveItemThrown"
	local hook7, hook8 = RegisterHook(funcName, ReceiveItemThrown)
	hookIds3[funcName] = { id1 = hook7; id2 = hook8 }
end


function RegisterHooks()


	for k,v in pairs(hookIds) do
		UnregisterHook(k, v.id1, v.id2)
	end
		
	hookIds = {}

    local funcName = "/Script/FSD.AmmoDrivenWeapon:OnWeaponFired"
	local hook1, hook2 = RegisterHook(funcName, OnWeaponFired)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

	local funcName = "/Script/FSD.Flare:StartLightFunction"
	local hook1, hook2 = RegisterHook(funcName, Server_ThrowItem)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/Engine.Character:OnJumped"
	local hook1, hook2 = RegisterHook(funcName, JumpPress)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/FSD.PlayerTemperatureComponent:OnDeath"
	local hook1, hook2 = RegisterHook(funcName, OnDeath)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/WeaponsNTools/Grenades/ITM_GrenadeThrow.ITM_GrenadeThrow_C:GrenadeThrown"
	local hook1, hook2 = RegisterHook(funcName, Server_ThrowItem)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/FSD.FSDGameMode:FSDSetPause"
	local hook1, hook2 = RegisterHook(funcName, FSDSetPause)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
    local funcName = "/Script/FSD.FSDGameMode:FSDClearPause"
	local hook1, hook2 = RegisterHook(funcName, FSDClearPause)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/FSD.FSDGameMode:SignalEndLevelToClients"
	local hook1, hook2 = RegisterHook(funcName, SignalEndLevelToClients)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/Character/States/BP_FallingState.BP_FallingState_C:ReceiveHoverBootsTick"
	local hook1, hook2 = RegisterHook(funcName, ReceiveHoverBootsTick)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/UI/CharacterSelectionMK2/SCREEN_CharacterSelection_Clean.SCREEN_CharacterSelection_Clean_C:OnSelectedCharacterChanged_Event"
	local hook1, hook2 = RegisterHook(funcName, OnSelectedCharacterChanged_Event)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
            
    local funcName = "/Script/FSD.HeavyParticleCannon:UpdateBeamsVisibility"
	local hook1, hook2 = RegisterHook(funcName, Server_SetBeamActive)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/GameElements/Bar/ITM_BarGlass_Item.ITM_BarGlass_Item_C:PlayDrinkPlayer"
	local hook1, hook2 = RegisterHook(funcName, IsDrinking)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
        
    local funcName = "/Script/FSD.JetBootsMovementComponent:OnJumpPressed"
	local hook1, hook2 = RegisterHook(funcName, OnJumpPressed)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
        
    local funcName = "/Script/FSD.JetBootsMovementComponent:OnJumpReleased"
	local hook1, hook2 = RegisterHook(funcName, OnJumpReleased)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/UMG.ProgressBar:SetPercent"
	local hook1, hook2 = RegisterHook(funcName, OnActionHoldProgress)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/LevelElements/Droppod/BP_DropPod_Base.BP_DropPod_Base_C:OnCharacterEnter"
	local hook1, hook2 = RegisterHook(funcName, BaseOnCharacterEnter)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/LevelElements/Droppod/BP_DropPod_Base.BP_DropPod_Base_C:OnCharacterExit"
	local hook1, hook2 = RegisterHook(funcName, BaseOnCharacterExit)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
    
    local funcName = "/Game/LevelElements/Droppod/BP_DropPod_Base.BP_DropPod_Base_C:OnDroppodImpact"
	local hook1, hook2 = RegisterHook(funcName, BaseOnDroppodImpact)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Game/LevelElements/Droppod/BP_DropPod_Base.BP_DropPod_Base_C:OnDrillingStarted"
	local hook1, hook2 = RegisterHook(funcName, BaseOnDrillingStarted)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/FSD.RessuplyPod:OnRep_State"
	local hook1, hook2 = RegisterHook(funcName, OnRep_State)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }

    local funcName = "/Script/FSD.PlayerTemperatureComponent:GetDefrostProgress"
	local hook1, hook2 = RegisterHook(funcName, GetDefrostProgress)
	hookIds[funcName] = { id1 = hook1; id2 = hook2 }
end



-- *******************************************************************

function FireFlamethrower(self)
    local isPlayer = self:get().VRG.VRPlayer.PlayerController.bIsLocalPlayerController
    if not isPlayer or not self:get().VRG.VRPlayer.PlayerController:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("FlameThrower")
    truegear.play_effect_by_uuid("FlameThrower")
    SendMessage(tostring(self:get():GetFullName()))
end

function FireCryospray(self)
    local isPlayer = self:get().VRG.VRPlayer.PlayerController.bIsLocalPlayerController
    if not isPlayer or not self:get().VRG.VRPlayer.PlayerController:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("Cryospray")
    truegear.play_effect_by_uuid("Cryospray")
    SendMessage(tostring(self:get():GetFullName()))
end

function StartFiringGrapplingGun(self)
    local isPlayer = self:get().VRG.VRPlayer.PlayerController.bIsLocalPlayerController
    if not isPlayer or not self:get().VRG.VRPlayer.PlayerController:IsValid() then
        return
    end
    isGrapping = true
    SendMessage("--------------------------------")
    SendMessage("StartFiringGrapplingGun")
    SendMessage(tostring(self:get():GetFullName()))
end


function StopFiringGrapplingGun(self)
    local isPlayer = self:get().VRG.VRPlayer.PlayerController.bIsLocalPlayerController
    if not isPlayer or not self:get().VRG.VRPlayer.PlayerController:IsValid() then
        return
    end
    isGrapping = false
    SendMessage("--------------------------------")
    SendMessage("StopFiringGrapplingGun")
    SendMessage(tostring(self:get():GetFullName()))
end

function ThrowHeldActor(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("ThrowItem")
    truegear.play_effect_by_uuid("ThrowItem")
    SendMessage(tostring(self:get():GetFullName()))
end


function GetDefrostProgress(self)
    local isPlayer = self:get().Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Character.Owner:IsValid() then
        return
    end
    local defrostProgress = self:get().DefrostProgress
    if lastDefrostProgress == defrostProgress then
        return
    end
    lastDefrostProgress = defrostProgress
    SendMessage("--------------------------------")
    SendMessage("BreakFree")
    truegear.play_effect_by_uuid("BreakFree")
    SendMessage(self:get():GetFullName())
    SendMessage(tostring(self:get().DefrostProgress))
end


function BaseOnCharacterEnter(self,Character)
    SendMessage("--------------------------------")
    SendMessage("BaseOnCharacterEnter")
    SendMessage(Character:get():GetFullName())
    local isPlayer = Character:get().Owner.bIsLocalPlayerController
    if not isPlayer then
        return
    end
    canDroppod = true
    if not Character:get().Owner:IsValid() then
        return
    end
    if string.find(Character:get():GetFullName(),"Driller") then
        playerType = "Driller"
    elseif string.find(Character:get():GetFullName(),"Engineer") then
        playerType = "Engineer"
    elseif string.find(Character:get():GetFullName(),"Gunner") then
        playerType = "Gunner"
    elseif string.find(Character:get():GetFullName(),"Navigator") then
        playerType = "Navigator"
    else
        playerType = nil
    end

    SendMessage(tostring(canDroppod))
end

function BaseOnCharacterExit(self,Character)
    SendMessage("--------------------------------")
    SendMessage("BaseOnCharacterExit")
    SendMessage(Character:get():GetFullName())
    local isPlayer = Character:get().Owner.bIsLocalPlayerController
    if not isPlayer then
        return
    end
    canDroppod = false
    SendMessage(tostring(canDroppod))
end

function UpdatePickaxe(self)
    local isPlayer = self:get().VRG.VRPlayer.PlayerController.bIsLocalPlayerController
    if not isPlayer or not self:get().VRG.VRPlayer.PlayerController:IsValid() then
        return
    end
    if not self:get():GetPropertyValue("As WPN Pickaxe").isUsing then
        return
    end
    if self:get():GetPropertyValue("SwingSpeed") < 150 then
        return
    end
    if os.clock() - pickaxeTime < 0.1 then
        return
    end
    pickaxeTime = os.clock()
    SendMessage("--------------------------------")
    SendMessage("PickaxeHitBlock")
    truegear.play_effect_by_uuid("PickaxeHitBlock")
    SendMessage(tostring(self:get():GetFullName()))
    SendMessage(tostring(pickaxeHitPoint["X"]))
    SendMessage(tostring(pickaxeHitPoint["Y"]))
    SendMessage(tostring(pickaxeHitPoint["Z"]))
    SendMessage(tostring(self:get():GetPropertyValue("As WPN Pickaxe").isUsing))
    SendMessage(tostring(self:get():GetPropertyValue("SwingSpeed")))
end

function OnSelectedCharacterChanged_Event(self)

    if not self:get().PlayerState.PawnPrivate.Owner.bIsLocalPlayerController or not self:get().PlayerState.PawnPrivate.Owner:IsValid() then
        return
    end
    if string.find(self:get().PlayerState.PawnPrivate:GetFullName(),"Driller") then
        playerType = "Driller"
    elseif string.find(self:get().PlayerState.PawnPrivate:GetFullName(),"Engineer") then
        playerType = "Engineer"
    elseif string.find(self:get().PlayerState.PawnPrivate:GetFullName(),"Gunner") then
        playerType = "Gunner"
    elseif string.find(self:get().PlayerState.PawnPrivate:GetFullName(),"Navigator") then
        playerType = "Navigator"
    else
        playerType = nil
    end
    SendMessage("--------------------------------")
    SendMessage("OnSelectedCharacterChanged_Event")
    SendMessage(tostring(self:get():GetFullName()))
    SendMessage(tostring(self:get().PlayerState.PawnPrivate:GetFullName()))
    SendMessage(playerType)
end

function OnRep_State(self,oldState)
    SendMessage("--------------------------------")
    SendMessage("OnRep_State")
    SendMessage(self:get().PlayerSpawnPoint:GetFullName())    
    if oldState:get() == 1 and self:get().State == 2 then
        SendMessage("DroppodLanding")
        truegear.play_effect_by_uuid("DroppodLanding")
        SendMessage(self:get():GetFullName())
        if resetHook1 then
            resetHook1 = false
            BaseOnDroppodImpactRegister()
        end    
        if playerType == "Driller" then
            if resetHook2 then
                resetHook2 = false
                DrillerRegister()
            end
        elseif playerType == "Gunner" then
            if resetHook3 then
                resetHook3 = false
                GunnerRegister()
            end
        end

        local ran,errorMsg = pcall(function()
            LoopAsync(1000, RegisterPickaxe)
            isRegisterPickaxe = true            
            if not isRegisterVR then
                isRegisterVR = true
                RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:SetPickaxeSwingSpeed", UpdatePickaxe)
                RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:StopFiringGrapplingGun", StopFiringGrapplingGun)
                RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:StartFiringGrapplingGun", StartFiringGrapplingGun)
                RegisterHook("/Game/VRG/BP_MotionController.BP_MotionController_C:Throw Held Actor", ThrowHeldActor)
                RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:FireCryospray", FireCryospray)
                RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:FireFlamethrower", FireFlamethrower)
                isRegisterPickaxe = false
            end
        end)
    end
    SendMessage(tostring(self:get():GetFullName()))
    SendMessage(tostring(oldState:get()))
    SendMessage(tostring(self:get().State))
end

function OnActionHoldProgress(self,Percent)
    local isPlayer = self:get():GetOwningPlayer().bIsLocalPlayerController
    if not isPlayer or not self:get():GetOwningPlayer():IsValid() then
        return
    end
    if not string.find(self:get():GetFullName(),"Use_Progress") then
        return
    end
    if not self:get():IsVisible() then
        return
    end
    if progressPercent == self:get().Percent then
        return
    end
    progressPercent = self:get().Percent
    if os.clock() - interactTime < 0.15 then
        return
    end
    interactTime = os.clock()
    SendMessage("--------------------------------")
    SendMessage("Interaction")
    truegear.play_effect_by_uuid("Interaction")
    SendMessage(tostring(self:get():GetFullName()))
    SendMessage(tostring(self:get().Percent))
    SendMessage(tostring(self:get():GetOwningPlayer():GetFullName()))
end


function OnJumpPressed(self)
    local isPlayer = self:get().Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Character.Owner:IsValid() then
        return
    end
    isJetBoots = true
    SendMessage("--------------------------------")
    SendMessage("OnJumpPressed")
    SendMessage(tostring(self:get():GetFullName()))
end

function OnJumpReleased(self)
    local isPlayer = self:get().Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Character.Owner:IsValid() then
        return
    end
    isJetBoots = false
    SendMessage("--------------------------------")
    SendMessage("OnJumpReleased")
    SendMessage(tostring(self:get():GetFullName()))
    SendMessage(tostring(self:get():GetFullName()))
end

function IsDrinking(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("Drinking")
    truegear.play_effect_by_uuid("Drinking")
    SendMessage(tostring(self:get():GetFullName()))
end

function Server_SetBeamActive(self)
    local isPlayer = self:get().Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Character.Owner:IsValid() then
        return
    end
    if self:get().bIsBeamActive then
        SendMessage("--------------------------------")
        SendMessage("StartShardDiffractorBeam")
        isShardDiffractorBeam = true
    else
        SendMessage("--------------------------------")
        SendMessage("StopShardDiffractorBeam")
        isShardDiffractorBeam = false
    end
end

function ReceiveHoverBootsTick(self,IsActive)
    local isPlayer = self:get().Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Character.Owner:IsValid() then
        return
    end
    if os.clock() - hoverBootsTime < 0.15 then
        return
    end
    hoverBootsTime = os.clock()
    SendMessage("--------------------------------")
    SendMessage("HoverBoots")
    truegear.play_effect_by_uuid("HoverBoots")
    SendMessage(tostring(IsActive:get()))
    SendMessage(tostring(self:get():GetFullName()))
end

function CallbackSegmentActivatedProgress(self)
    local isPlayer = self:get().Instigator.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Instigator.Owner:IsValid() then
        return
    end
    if os.clock() - buildPipelineTime < 0.2 then
        return
    end
    buildPipelineTime = os.clock()
    SendMessage("--------------------------------")
    SendMessage("BuildPipeline")
    truegear.play_effect_by_uuid("BuildPipeline")
    SendMessage(self:get():GetFullName())
    SendMessage(self:get().Instigator:GetFullName())
end

function SetHealth(self,Health)
    local isPlayer = self:get().HealthComponent.Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().HealthComponent.Character.Owner:IsValid() then
        return
    end
    if lastHealth > Health:get() then
        SendMessage("--------------------------------")
        SendMessage("Healing")
        truegear.play_effect_by_uuid("Healing")
    end
    lastHealth = Health:get()
end

function OnStartDrilling(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    isDoubleDrillsDrilling = true
    SendMessage("--------------------------------")
    SendMessage("OnStartDrilling")
    SendMessage(self:get():GetFullName())
end

function OnStopDrilling(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    isDoubleDrillsDrilling = false
    SendMessage("--------------------------------")
    SendMessage("OnStopDrilling")
    SendMessage(self:get():GetFullName())
end

function OnAnnounceAnimFinished(self,User)
    local isPlayer = User:get().Owner.bIsLocalPlayerController
    if not isPlayer or not User:get().Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("CollectItem")
    truegear.play_effect_by_uuid("CollectItem")
    SendMessage(self:get():GetFullName())
    SendMessage(User:get():GetFullName())
end

function SignalEndLevelToClients(self)
    isPause = false
    isDroppodDrilling = false
    isDepositing = false
    isDoubleDrillsDrilling = false
    isShardDiffractorBeam = false
    isJetBoots = false
end

function FSDSetPause(self)
    isPause = true
end

function FSDClearPause(self)
    isPause = false
end

function OnArmorDamaged(self)
    local isPlayer = self:get().Player.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Player.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("ArmorDamage")
    truegear.play_effect_by_uuid("ArmorDamage")
    SendMessage(self:get():GetFullName())
end

function OnDamageTaken(self)
    local isPlayer = self:get().Player.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Player.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("HealthDamage")
    truegear.play_effect_by_uuid("HealthDamage")
    SendMessage(self:get():GetFullName())
end

function BaseOnDrillingStarted(self)
    SendMessage("--------------------------------")
    SendMessage("BaseOnDrillingStarted")
    if not canDroppod then
        return
    end
    isDroppodDrilling = true
    SendMessage(self:get():GetFullName())
end

function BaseOnDroppodImpact(self)
    isDroppodDrilling = false
    if not canDroppod then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("DroppodLanding")
    truegear.play_effect_by_uuid("DroppodLanding")
    
    SendMessage(self:get():GetFullName())
    if resetHook1 then
        resetHook1 = false
        BaseOnDroppodImpactRegister()
    end    
    if playerType == "Driller" then
        if resetHook2 then
            resetHook2 = false
            DrillerRegister()
        end
    elseif playerType == "Gunner" then
        if resetHook3 then
            resetHook3 = false
            GunnerRegister()
        end
    end
    local ran,errorMsg = pcall(function()
        LoopAsync(1000, RegisterPickaxe)
        isRegisterPickaxe = true            
        if not isRegisterVR then
            isRegisterVR = true
            RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:SetPickaxeSwingSpeed", UpdatePickaxe)
            RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:StopFiringGrapplingGun", StopFiringGrapplingGun)
            RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:StartFiringGrapplingGun", StartFiringGrapplingGun)
            RegisterHook("/Game/VRG/BP_MotionController.BP_MotionController_C:Throw Held Actor", ThrowHeldActor)
            RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:FireCryospray", FireCryospray)
            RegisterHook("/Game/VRG/VRWeaponsManager.VRWeaponsManager_C:FireFlamethrower", FireFlamethrower)
            isRegisterPickaxe = false
        end
    end)
end

function ChargeReceiveBeginPlay(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("ThrowItem")
    truegear.play_effect_by_uuid("ThrowItem")
    SendMessage(self:get():GetFullName())
end

function UseCharge(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("UseCharge")
    truegear.play_effect_by_uuid("UseCharge")
    SendMessage(self:get():GetFullName())
end


function ReceiveItemThrown(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("ThrowItem")
    truegear.play_effect_by_uuid("ThrowItem")
    SendMessage(self:get():GetFullName())
end


function OnDeployProgress_Event(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    if os.clock() - deployTime < 0.2 then
        return
    end
    deployTime = os.clock()
    SendMessage("--------------------------------")
    SendMessage("DeploySentryGun")
    truegear.play_effect_by_uuid("DeploySentryGun")
    SendMessage(self:get():GetFullName())
end

function DoubleDrillAll_SimulateDamage(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("DoubleDrillHitEnemy")
    truegear.play_effect_by_uuid("DoubleDrillHitEnemy")
    SendMessage(self:get():GetFullName())
end

function DoubleDrillAll_SimulateDigBlock(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("DoubleDrillHitBlock")
    truegear.play_effect_by_uuid("DoubleDrillHitBlock")
    SendMessage(self:get():GetFullName())
end

function Cryospray(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("Cryospray")
    truegear.play_effect_by_uuid("Cryospray")
    SendMessage(self:get():GetFullName())
end

function FlameThrower(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("FlameThrower")
    truegear.play_effect_by_uuid("FlameThrower")
    SendMessage(self:get():GetFullName())
end


function Server_ThrowItem(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("ThrowItem")
    truegear.play_effect_by_uuid("ThrowItem")
    SendMessage(self:get():GetFullName())
end

function OnGrappleStart(self,NewState)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    if NewState:get().IsGrapLing then
        isGrapping = true
        SendMessage("--------------------------------")
        SendMessage("OnGrappleStart")
    else
        isGrapping = false
        SendMessage("--------------------------------")
        SendMessage("OnGrappleEnd")
    end
    SendMessage(self:get():GetFullName())
    SendMessage(tostring(NewState:get().IsGrapLing))
end

function OnDeath(self)
    local isPlayer = self:get().Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Character.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("PlayerDeath")
    truegear.play_effect_by_uuid("PlayerDeath")
    isJetBoots = false
    SendMessage(self:get():GetFullName())
end

function JumpPress(self)
    local isPlayer = self:get().Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("Jump")
    truegear.play_effect_by_uuid("Jump")
    SendMessage(self:get():GetFullName())
end

function OnDepositingBegin_Event(self)
    local isPlayer = self:get().Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Character.Owner:IsValid() then
        return
    end
    isDepositing = true
    SendMessage("--------------------------------")
    SendMessage("OnDepositingBegin_Event")
    SendMessage(self:get():GetFullName())
end

function OnDepositingEnd_Event(self)
    local isPlayer = self:get().Character.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Character.Owner:IsValid() then
        return
    end
    isDepositing = false
    SendMessage("--------------------------------")
    SendMessage("OnDepositingEnd_Event")
    SendMessage(self:get():GetFullName())
end

function Server_DamageTarget(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("PickaxeHitEnemy")
    truegear.play_effect_by_uuid("PickaxeHitEnemy")
    SendMessage(self:get():GetFullName())
end

function All_SimulateDamageTarget(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("PickaxeHitEnemy")
    truegear.play_effect_by_uuid("PickaxeHitEnemy")
    SendMessage(self:get():GetFullName())
end

function All_SimulateDigBlock(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("PickaxeHitBlock")
    truegear.play_effect_by_uuid("PickaxeHitBlock")
    SendMessage(self:get():GetFullName())
end

function Server_HitBlock(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    SendMessage("--------------------------------")
    SendMessage("PickaxeHitBlock")
    truegear.play_effect_by_uuid("PickaxeHitBlock")
    SendMessage(self:get():GetFullName())
end

function OnWeaponFired(self)
    local isPlayer = self:get().Owner.Owner.bIsLocalPlayerController
    if not isPlayer or not self:get().Owner.Owner:IsValid() then
        return
    end
    if string.find(self:get():GetFullName(),"Shotgun") or string.find(self:get():GetFullName(),"Launcher") then
        SendMessage("--------------------------------")
        SendMessage("ShotgunShoot")
        truegear.play_effect_by_uuid("ShotgunShoot")
    elseif string.find(self:get():GetFullName(),"Rifle") or string.find(self:get():GetFullName(),"M1000") then
        SendMessage("--------------------------------")
        SendMessage("RifleShoot")
        truegear.play_effect_by_uuid("RifleShoot")
    else
        SendMessage("--------------------------------")
        SendMessage("PistolShoot")
        truegear.play_effect_by_uuid("PistolShoot")
    end
    SendMessage(self:get():GetFullName())
end


function DroppodDrilling()
    if isPause then
        return
    end
    if not canDroppod then
        return
    end
    if isDroppodDrilling then
        SendMessage("--------------------------------")
        SendMessage("DroppodDrilling")
        truegear.play_effect_by_uuid("DroppodDrilling")
    end
end

function Grappling()
    if isPause then
        return
    end
    if isGrapping then
        SendMessage("--------------------------------")
        SendMessage("Grappling")
        truegear.play_effect_by_uuid("Grappling")
    end
end

function Depositing()
    if isPause then
        return
    end
    if isDepositing then
        SendMessage("--------------------------------")
        SendMessage("Depositing")
        truegear.play_effect_by_uuid("Depositing")
    end
end

function DoubleDrillsDrilling()
    if isPause then
        return
    end
    if isDoubleDrillsDrilling then
        SendMessage("--------------------------------")
        SendMessage("DoubleDrillsDrilling")
        truegear.play_effect_by_uuid("DoubleDrillsDrilling")
    end
end

function ShardDiffractorBeam()
    if isPause then
        return
    end
    if isShardDiffractorBeam then
        SendMessage("--------------------------------")
        SendMessage("ShardDiffractorBeam")
        truegear.play_effect_by_uuid("ShardDiffractorBeam")
    end
end

function JetBoots()
    if isPause then
        return
    end
    if isJetBoots then
        SendMessage("--------------------------------")
        SendMessage("JetBoots")
        truegear.play_effect_by_uuid("JetBoots")
    end
end

function RegisterPickaxe()
    if isRegisterPickaxe then
        if not isRegisterNonVR then
            isRegisterNonVR = true
            RegisterHook("/Script/FSD.PickaxeItem:All_SimulateDigBlock", All_SimulateDigBlock)
            RegisterHook("/Script/FSD.PickaxeItem:Server_HitBlock", Server_HitBlock)
            RegisterHook("/Script/FSD.PickaxeItem:All_SimulateDamageTarget", All_SimulateDamageTarget)
            RegisterHook("/Script/FSD.PickaxeItem:Server_DamageTarget", Server_DamageTarget)
            RegisterHook("/Script/FSD.GrapplingHookGun:Server_SetState", OnGrappleStart)
        end
        isRegisterPickaxe = false
    end
end

truegear.init("548430", "Deep Rock Galactic")

function CheckPlayerSpawned()
	RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
		if resetHook then
			local ran, errorMsg = pcall(RegisterHooks)
			if ran then
				resetHook = false
				SendMessage("--------------------------------")
				SendMessage("Grappling")
				truegear.play_effect_by_uuid("Grappling")
			else
				print(errorMsg)
			end
		end		
	end)
end

SendMessage("TrueGear Mod is Loaded");
CheckPlayerSpawned()

LoopAsync(100, DroppodDrilling)
LoopAsync(150, Grappling)
LoopAsync(150, DoubleDrillsDrilling)
LoopAsync(120, Depositing)
LoopAsync(100, ShardDiffractorBeam)
LoopAsync(200, JetBoots)