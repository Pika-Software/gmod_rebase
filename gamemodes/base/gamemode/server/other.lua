-- Entity
function GM:EntityTakeDamage( entity, info )
end

function GM:CreateEntityRagdoll( entity, ragdoll )
end

-- Password
function GM:CheckPassword( steamid64, ip, server_pass, pass, nick )
	if (server_pass ~= "") and (server_pass ~= pass) then
		return false
	end

	return true
end

-- Vehicle
do
	local math_Clamp = math.Clamp
	function GM:VehicleMove( ply, vehicle, mv )
		if mv:KeyPressed(IN_DUCK) and (vehicle.SetThirdPersonMode ~= nil) then
			vehicle:SetThirdPersonMode( not vehicle:GetThirdPersonMode() )
		end

		local iWheel = ply:GetCurrentCommand():GetMouseWheel()
		if (iWheel ~= 0) and (vehicle.SetCameraDistance ~= nil) then
			vehicle:SetCameraDistance( math_Clamp(vehicle:GetCameraDistance() - iWheel * 0.03 * (1.1 + vehicle:GetCameraDistance()), -1, 10) )
		end
	end
end

-- Undo
function GM:PreUndo( undo )
	return false
end

function GM:PostUndo( undo, count )
end

-- VariableEdit
do

	local IsValid = IsValid
	local hook_Run = hook.Run
	local hook_name = "CanEditVariable"

	function GM:VariableEdited( ent, ply, key, val, editor )
		if IsValid( ent ) and IsValid( ply ) then
			if not hook_Run( hook_name, ent, ply, key, val, editor ) then
				return
			end

			ent:EditValue( key, val )
		end
	end

end

function GM:CanEditVariable( ent, ply, key, val, editor )
	return false
end

-- NPC
function GM:OnNPCKilled( ent, att, infl )
end

function GM:ScaleNPCDamage( npc, hitgroup, dmg )
end

-- PhysGun
function GM:OnPhysgunFreeze( wep, phys, ent, ply )
	if ent:GetUnFreezable() then return false end

	if phys:IsMoveable() then
		phys:EnableMotion( false )
		ply:AddFrozenPhysicsObject( ent, phys )

		return true
	end

	return false
end

function GM:OnPhysgunReload( wep, ply )
	ply:PhysgunUnfreeze()
end

-- GravityGun
function GM:GravGunOnPickedUp( ply, ent )
end

function GM:GravGunOnDropped( ply, ent )
end

-- Hostname Update
do

	local GetHostName = GetHostName
	local SetGlobalString = SetGlobalString

	function GM:UpdateHostName()
		SetGlobalString( "ServerName", GetHostName() )
	end

end

-- Team System
function GM:ShowTeam( ply )
end

timer.Simple(0, function()
	-- Remove stupid stuff
	timer.Remove("HostnameThink")

	-- admin_functions.lua
	concommand.Remove("banid2")
	concommand.Remove("kickid2")

	-- modules/properties.lua
	net.ReceiveRemove("properties")
end)

-- Hostname Update
do

	local cvars_AddChangeCallback = cvars.AddChangeCallback
	hook.Add("PostGamemodeLoaded", "Clear Base", function()
		GAMEMODE:UpdateHostName()
		cvars_AddChangeCallback("hostname", GAMEMODE.UpdateHostName, "ServerHostnameUpdate")
	end)

end
