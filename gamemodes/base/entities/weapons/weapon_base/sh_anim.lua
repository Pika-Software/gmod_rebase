
local ActIndex = {
	[ "pistol" ]		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ]			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ]		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ]			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ]		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]			= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ]		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ]		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ]			= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ]			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER
}

--[[---------------------------------------------------------
	Name: SetWeaponHoldType
	Desc: Sets up the translation table, to translate from normal
			standing idle pose, to holding weapon pose.
-----------------------------------------------------------]]

do

	local ACT_MP_ATTACK_CROUCH_PRIMARYFIRE = ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
	local ACT_MP_ATTACK_STAND_PRIMARYFIRE = ACT_MP_ATTACK_STAND_PRIMARYFIRE
	local ACT_MP_RELOAD_CROUCH = ACT_MP_RELOAD_CROUCH
	local ACT_MP_RELOAD_STAND = ACT_MP_RELOAD_STAND
	local ACT_HL2MP_JUMP_SLAM = ACT_HL2MP_JUMP_SLAM
	local ACT_MP_CROUCH_IDLE = ACT_MP_CROUCH_IDLE
	local ACT_MP_STAND_IDLE = ACT_MP_STAND_IDLE
	local ACT_MP_CROUCHWALK = ACT_MP_CROUCHWALK
	local ACT_RANGE_ATTACK1 = ACT_RANGE_ATTACK1
	local ACT_MP_SWIM = ACT_MP_SWIM
	local ACT_MP_WALK = ACT_MP_WALK
	local ACT_MP_JUMP = ACT_MP_JUMP
	local ACT_MP_RUN = ACT_MP_RUN

	local Msg = Msg

	function SWEP:SetWeaponHoldType( t )
		t = t:lower()
		local index = ActIndex[ t ]

		if ( index == nil ) then
			Msg( "SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set! (defaulting to normal)\n" )
			t = "normal"
			index = ActIndex[ t ]
		end

		self.ActivityTranslate = {
			[ ACT_MP_STAND_IDLE ] = index,
			[ ACT_MP_WALK ] = index + 1,
			[ ACT_MP_RUN ] = index + 2,
			[ ACT_MP_CROUCH_IDLE ] = index + 3,
			[ ACT_MP_CROUCHWALK ] = index + 4,
			[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = index + 5,
			[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ] = index + 5,
			[ ACT_MP_RELOAD_STAND ] = index + 6,
			[ ACT_MP_RELOAD_CROUCH ] = index + 6,
			[ ACT_MP_JUMP ] = index + 7,
			[ ACT_RANGE_ATTACK1 ] = index + 8,
			[ ACT_MP_SWIM ] = index + 9
		}

		-- "normal" jump animation doesn't exist
		if ( t == "normal" ) then
			self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
		end

		self:SetupWeaponHoldTypeForAI( t )
	end

end

-- Default hold pos is the pistol
SWEP:SetWeaponHoldType( "pistol" )

--[[---------------------------------------------------------
	Name: weapon:TranslateActivity()
	Desc: Translate a player's Activity into a weapon's activity
		 	So for example, ACT_HL2MP_RUN becomes ACT_HL2MP_RUN_PISTOL
			Depending on how you want the player to be holding the weapon
-----------------------------------------------------------]]
function SWEP:TranslateActivity( act )
	local ply = self:GetOwner()
	if IsValid( ply ) then
		if ply:IsNPC() then
			if ( self.ActivityTranslateAI[ act ] ) then
				return self.ActivityTranslateAI[ act ]
			end

			return -1
		end

		if ( self.ActivityTranslate[ act ] != nil ) then
			return self.ActivityTranslate[ act ]
		end
	end

	return -1
end
