hs = hs

-- Global variable to store the drawing
local windowBorder = nil

-- Function to draw red border around the focused window
local function drawRedBorder()
	-- Delete old border if exists
	if windowBorder then
		windowBorder:delete()
		windowBorder = nil
	end

	-- Get focused window
	local win = hs.window.focusedWindow()
	if not win then
		return
	end

	local frame = win:frame()

	-- Create a red rectangle around the window
	windowBorder = hs.drawing.rectangle(frame)
	windowBorder:setStrokeColor({ ["red"] = 1, ["blue"] = 0, ["green"] = 0, ["alpha"] = 1 })
	windowBorder:setFill(false)
	windowBorder:setStrokeWidth(4)
	windowBorder:setLevel(hs.drawing.windowLevels.overlay) -- Keep on top
	windowBorder:setRoundedRectRadii(4, 4)
	windowBorder:show()
end

-- Bind to a hotkey to test manually
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function()
	drawRedBorder()
end)

-- Automatically update border when window focus changes
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function()
	drawRedBorder()
end)

-- Optional: remove border when focus is lost
hs.window.filter.default:subscribe(hs.window.filter.windowUnfocused, function()
	if windowBorder then
		windowBorder:delete()
		windowBorder = nil
	end
end)

hs.hotkey.bind({ "alt" }, "w", function()
	local choices = {}
	for _, win in ipairs(hs.window.allWindows()) do
		if win:title() ~= "" then
			table.insert(choices, {
				text = win:application():name() .. " — " .. win:title(),
				subText = "Space: " .. win:screen():name(),
				uuid = win:id(), -- Save the window ID to refocus later
			})
		end
	end

	local chooser = hs.chooser.new(function(choice)
		if not choice then
			return
		end
		local target = hs.window.get(choice.uuid)
		if target then
			target:focus()
		end
	end)

	chooser:choices(choices)
	chooser:rows(10)
	chooser:width(40)
	chooser:show()
end)

-- local lastApp
-- -- Create a hotkey to toggle between the current and last active applications
-- hs.hotkey.bind({ "alt" }, "b", function()
-- 	local currentApp = hs.application.frontmostApplication()
--
-- 	-- If we already have a last app stored, switch to it
-- 	if lastApp and lastApp:isRunning() then
-- 		lastApp:activate() -- Bring the last app to the front
-- 	else
-- 		-- If no last app or it's not running, just switch to the current app
-- 		currentApp:activate()
-- 	end
--
-- 	-- Update the last active app to the current one
-- 	lastApp = currentApp
-- end)

-- hs.loadSpoon("hs_select_window")
--
-- -- customize bindings to your preference
-- local SWbindings = {
-- 	all_windows = { { "alt" }, "b" },
-- 	app_windows = { { "alt", "shift" }, "b" },
-- }
-- spoon.hs_select_window:bindHotkeys(SWbindings)
