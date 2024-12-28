local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local AIChatModule = {}

-- Default Settings for the AI Chat
AIChatModule.Settings = {
	AI_API_KEY = "YOUR_OPENAI_API_KEY", -- Add your OpenAI API Key here
	AI_API_URL = "https://api.openai.com/v1/completions",
	Model = "gpt-4", -- Can be changed to "gpt-3.5" or other available models
	MaxTokens = 100,
	Temperature = 0.7,

	-- Colors
	TextColor = Color3.fromRGB(255, 255, 255), -- Default color for TextLabels
	BackgroundColor = Color3.fromRGB(30, 30, 30), -- Background color for messages
	InputTextColor = Color3.fromRGB(0, 0, 0), -- Text color in input box
	InputBackgroundColor = Color3.fromRGB(255, 255, 255), -- Input box background
	ButtonColor = Color3.fromRGB(0, 255, 0), -- Submit button color
	ButtonTextColor = Color3.fromRGB(0, 0, 0), -- Submit button text color

	-- Text Settings
	TextSize = 18, -- Default text size for chat messages
	TextSpeed = 0.05, -- Delay between each character in seconds (adjustable for typing speed)

	-- Sound Settings
	SoundID = "rbxassetid://929615246", -- ID for the talk sound
	SoundType = "PerCharacter", -- "PerMessage" or "PerCharacter"

	-- Other Settings
	DebounceTime = 1, -- Time in seconds before the button can be clicked again
	ScrollPadding = 10, -- Padding between the last message and the bottom of the scrolling frame
}

-- Create the Chat GUI
function AIChatModule:CreateChatGUI()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "AIChatGui"
	screenGui.Parent = playerGui
	screenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

	-- Create a background frame for the chat
	local chatBackground = Instance.new("Frame")
	chatBackground.Name = "ChatBackground"
	chatBackground.Size = UDim2.new(1, 0, 1, 0) -- Fill the entire screen
	chatBackground.Position = UDim2.new(0, 0, 0, 0)
	chatBackground.BackgroundColor3 = AIChatModule.Settings.BackgroundColor
	chatBackground.BorderSizePixel = 0
	chatBackground.Parent = screenGui

	-- Create ScrollingFrame for conversation
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollingFrame"
	scrollFrame.Size = UDim2.new(1, 0, 0.9, 0) -- Leave space for the input box
	scrollFrame.Position = UDim2.new(0, 0, 0, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.Parent = chatBackground
	scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.ScrollBarThickness = 10

	-- Add UIListLayout for automatic spacing between messages
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 5)
	layout.Parent = scrollFrame

	-- Create a Template TextLabel to clone
	local templateLabel = Instance.new("TextLabel")
	templateLabel.Name = "TextLabel"
	templateLabel.Size = UDim2.new(1, -10, 0, 30)
	templateLabel.BackgroundTransparency = 1
	templateLabel.TextColor3 = AIChatModule.Settings.TextColor
	templateLabel.TextSize = AIChatModule.Settings.TextSize
	templateLabel.TextWrapped = true
	templateLabel.Text = ""
	templateLabel.TextXAlignment = Enum.TextXAlignment.Left
	templateLabel.Parent = scrollFrame

	-- Create TextBox for user input
	local inputBox = Instance.new("TextBox")
	inputBox.Name = "InputBox"
	inputBox.Size = UDim2.new(0.9, 0, 0.1, 0)
	inputBox.Position = UDim2.new(0, 0, 0.9, 0)
	inputBox.PlaceholderText = "Type your message..."
	inputBox.Text = ""
	inputBox.Parent = screenGui
	inputBox.ClearTextOnFocus = false
	inputBox.BackgroundColor3 = AIChatModule.Settings.InputBackgroundColor
	inputBox.TextColor3 = AIChatModule.Settings.InputTextColor
	inputBox.TextSize = 16

	-- Create Submit Button
	local submitButton = Instance.new("TextButton")
	submitButton.Name = "SubmitButton"
	submitButton.Size = UDim2.new(0.1, 0, 0.1, 0)
	submitButton.Position = UDim2.new(0.9, 0, 0.9, 0)
	submitButton.Text = "Send"
	submitButton.BackgroundColor3 = AIChatModule.Settings.ButtonColor
	submitButton.TextColor3 = AIChatModule.Settings.ButtonTextColor
	submitButton.TextSize = 16
	submitButton.Parent = screenGui

	-- Function to play the customized talk sound
	local function playTalkSound()
		local sound = Instance.new("Sound")
		sound.SoundId = AIChatModule.Settings.SoundID
		sound.Parent = player.Character or player:WaitForChild("Character")
		sound:Play()
		sound.Ended:Connect(function()
			sound:Destroy()
		end)
	end

	-- Function to handle sending message to AI
	local function SendMessageToAI(playerInput)
		local headers = {
			["Authorization"] = "Bearer " .. AIChatModule.Settings.AI_API_KEY,
			["Content-Type"] = "application/json"
		}

		local requestData = {
			model = AIChatModule.Settings.Model,
			prompt = playerInput,
			max_tokens = AIChatModule.Settings.MaxTokens,
			temperature = AIChatModule.Settings.Temperature
		}

		local jsonData = HttpService:JSONEncode(requestData)

		local success, response = pcall(function()
			return HttpService:PostAsync(AIChatModule.Settings.AI_API_URL, jsonData, Enum.HttpContentType.ApplicationJson, false, headers)
		end)

		if success then
			local decodedResponse = HttpService:JSONDecode(response)
			return decodedResponse.choices[1].text
		else
			return "COULD NOT GET A RESPONSE FROM THE AI. [Did you put in the right key?]"
		end
	end

	-- Function to update GUI with new messages
	local function DisplayChatMessage(message, sender)
		local newMessage = templateLabel:Clone()
		newMessage.Text = sender .. ": "
		newMessage.Parent = scrollFrame

		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.CanvasSize.Y.Offset + newMessage.Size.Y.Offset + layout.Padding.Offset)
		scrollFrame.CanvasPosition = Vector2.new(0, scrollFrame.CanvasSize.Y.Offset)

		local typedText = ""
		for i = 1, #message do
			typedText = typedText .. message:sub(i, i)
			newMessage.Text = sender .. ": " .. typedText
			if AIChatModule.Settings.SoundType == "PerCharacter" then
				playTalkSound()
			end
			wait(AIChatModule.Settings.TextSpeed)
		end

		if AIChatModule.Settings.SoundType == "PerMessage" then
			playTalkSound()
		end

		-- Adjust CanvasSize for padding
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.CanvasSize.Y.Offset + AIChatModule.Settings.ScrollPadding)
	end

	local canClick = true

	submitButton.MouseButton1Click:Connect(function()
		if canClick then
			local userMessage = inputBox.Text
			if userMessage ~= "" then
				submitButton.Text = "Sending..."
				canClick = false

				DisplayChatMessage(userMessage, "Player")
				inputBox.Text = ""

				local aiResponse = SendMessageToAI(userMessage)

				DisplayChatMessage(aiResponse, "AI")

				wait(AIChatModule.Settings.DebounceTime)
				canClick = true
				submitButton.Text = "Send"
			end
		end
	end)
end

return AIChatModule