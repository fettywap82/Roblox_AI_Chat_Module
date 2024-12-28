# AI Chat Module for Roblox

Easily integrate an AI-powered chat interface into your Roblox game using this module. The AI Chat Module allows players to interact with an AI, providing a seamless and immersive chat experience.

---

## Features

- Fully functional chat GUI with customizable design.
- AI responses powered by OpenAI's API.
- Smooth typing effect with adjustable speed.
- Supports scrolling for long conversations.
- Completely customizable settings for colors, sizes, and behavior.
- Debounce functionality to prevent spamming.

---

## Installation

1. **Download the Module**
   - Clone or download this repository to your local machine.

2. **Add the Module to Your Game**
   - Place the AI Chat Module script in `ReplicatedStorage`.

3. **Add the Initialize Script**
   - Create a LocalScript in `StarterPlayerScripts` or `StarterGui`.
   - In the LocalScript, add the following code:

     ```lua
     local AIChatModule = require(game:GetService("ReplicatedStorage").AIChatModule)
     AIChatModule:CreateChatGUI()
     ```

4. **Set Up Your OpenAI API Key**
   - Open the `AIChatModule` script located in `ReplicatedStorage`.
   - Replace `YOUR_OPENAI_API_KEY` in the settings with your actual OpenAI API key.

---

## Customization

### Settings

The AI Chat Module has a `Settings` table for easy customization:

- **API Settings:**
  - `AI_API_KEY`: Your OpenAI API key.
  - `AI_API_URL`: The endpoint for the API (default: `https://api.openai.com/v1/completions`).
  - `Model`: The AI model to use (e.g., `gpt-4`).
  - `MaxTokens`: The maximum number of tokens in the AI's response.
  - `Temperature`: Controls randomness in the AI's responses.

- **Design Settings:**
  - `TextColor`: Color of the chat text.
  - `BackgroundColor`: Background color of the chat messages.
  - `ButtonColor`: Color of the send button.
  - `InputBackgroundColor`: Background color of the input box.
  - `TextSize`: Size of the chat text.

- **Behavior Settings:**
  - `TextSpeed`: Delay between each character in the typing effect.
  - `DebounceTime`: Time in seconds before the send button can be clicked again.

### Example

To change the text color and debounce time, edit the `Settings` table:

```lua
AIChatModule.Settings.TextColor = Color3.fromRGB(0, 255, 0)  -- Green text
AIChatModule.Settings.DebounceTime = 2  -- 2-second debounce
```

---

## Usage

Once installed, the AI Chat GUI will automatically load for all players. Players can type messages into the input box and receive AI responses in real time.

---

## Contributing

Feel free to fork the repository and submit pull requests with improvements or bug fixes. Suggestions are always welcome!

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

