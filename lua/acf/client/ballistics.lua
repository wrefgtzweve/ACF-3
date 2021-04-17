ACF.BulletEffect = ACF.BulletEffect or {}

local function BulletFlight(Bullet)
	local DeltaTime = CurTime() - Bullet.LastThink
	local Drag = Bullet.SimFlight:GetNormalized() *  (Bullet.DragCoef * Bullet.SimFlight:Length() ^ 2 ) / ACF.DragDiv

	Bullet.SimPosLast = Bullet.SimPos
	local Correction = 0.5 * (Bullet.Accel - Drag) * DeltaTime   --Double integrates constant acceleration for better positional accuracy
	Bullet.SimPos = Bullet.SimPos + ACF.Scale * DeltaTime * (Bullet.SimFlight + PositionCorrection)  --Calculates the next shell position
	Bullet.SimFlight = Bullet.SimFlight + (Bullet.Accel - Drag) * DeltaTime			--Calculates the next shell vector

	if IsValid(Bullet.Effect) then
		Bullet.Effect:ApplyMovement(Bullet)
	end

	--debugoverlay.Line(Bullet.SimPosLast, Bullet.SimPos, 15, Color(255, 255, 0))
	Bullet.LastThink = CurTime()
end

hook.Add("Think", "ACF_ManageBulletEffects", function()
	for Index, Bullet in pairs(ACF.BulletEffect) do
		--This is the bullet entry in the table, the omnipresent Index var refers to this
		BulletFlight(Bullet, Index)
	end
end)

ACF_SimBulletFlight = BulletFlight
