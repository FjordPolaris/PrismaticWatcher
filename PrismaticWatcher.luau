--// Initialisation

local Watcher = {}
Watcher.__index = Watcher

--// Constructor

function Watcher.new(Object: Instance, Settings)
	assert(typeof(Object) == "Instance" and Object:IsA("PrismaticConstraint"), "Expected a PrismaticConstraint!")

	local self = setmetatable({}, Watcher)
	self.Object = Object
	self.Precision = (Settings and Settings.Precision) or 0.01

	return self
end

--// Functions

function Watcher:IsStopped(): boolean
	if self.Object.ActuatorType ~= Enum.ActuatorType.Servo then
		return false
	end

	local posDiff = math.abs(self.Object.TargetPosition - self.Object.CurrentPosition)
	return posDiff <= self.Precision
end

function Watcher:WaitUntilStopped(timeout: number)
	local startTime = tick()

	while not self:IsStopped() do
		if timeout and (tick() - startTime) >= timeout then
			warn("PrismaticWatcher Timeout for:", self.Object:GetFullName())
			break
		end
		task.wait()
	end
end

return Watcher
