#!/bin/bash

# Bash script to setup environment on mac
# - homebrew
# - zsh
# - Powerlevel10k
# - custom plugins for Oh My Zsh

# Bash script to install Homebrew

# Step 1: Install Homebrew
echo "Step 1: Installing Homebrew..."

# Check if Homebrew is already installed
if command -v brew >/dev/null 2>&1; then
  echo "Homebrew is already installed."
  echo "Running 'brew update' to ensure it is up-to-date..."
  brew update
else
  echo "Homebrew is not installed. Proceeding with installation..."
  
  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Check if installation was successful
  if [ $? -eq 0 ]; then
    echo "Homebrew installed successfully!"

    # Add Homebrew to PATH if it's not already there (Mac-specific path)
    if [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
      echo "Adding Homebrew to PATH..."
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    echo "Homebrew installation failed. Please check for errors above."
    exit 1
  fi
fi

# Verify installation
echo "Verifying Homebrew installation..."
brew --version

echo "Homebrew installation script complete."


# Install Oh My Zsh
echo "Step 2: Installing Oh My Zsh..."

if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "Oh My Zsh is already installed."
else
  # Check if zsh is installed and use the appropriate shell for installation
  if command -v zsh &> /dev/null; then
    echo "zsh is installed. Using zsh for the installation."
    shell="zsh"
  else
    echo "zsh is not installed. Falling back to sh for the installation."
    shell="sh"
  fi

  # Install Oh My Zsh
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

  if [ $? -eq 0 ]; then
    echo "Oh My Zsh installed successfully!"
  else
    echo "Oh My Zsh installation failed. Please check for errors above."
    exit 1
  fi
fi

# Step 3: Verify Oh My Zsh installation
echo "Step 3: Verifying Oh My Zsh installation..."
if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  # Check if OMZVERSION is defined
  if grep -q "OMZVERSION=" "$HOME/.oh-my-zsh/oh-my-zsh.sh"; then
    # Print Oh My Zsh version by extracting from the oh-my-zsh.sh file
    version=$(grep "OMZVERSION=" "$HOME/.oh-my-zsh/oh-my-zsh.sh" | cut -d'"' -f2)
    echo "Oh My Zsh version: $version"
  else
    echo "Oh My Zsh version is not defined in oh-my-zsh.sh."
  fi
else
  echo "Could not verify Oh My Zsh version. Installation may have failed."
  exit 1
fi


# Step 4: Install Powerlevel10k theme
echo "Step 4: Installing Powerlevel10k theme..."

if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  echo "Powerlevel10k theme is already installed."
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  if [ $? -eq 0 ]; then
    echo "Powerlevel10k theme installed successfully!"
    
    # Ensure .zshrc is updated to source .p10k.zsh
    if ! grep -q 'source ~/.p10k.zsh' ~/.zshrc; then
      echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
      echo "Updated .zshrc to source .p10k.zsh."
    fi

    # Ensure ZSH_THEME is set for Powerlevel10k
    if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
      sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
      echo "Set ZSH_THEME to Powerlevel10k in .zshrc."
    fi
  else
    echo "Powerlevel10k theme installation failed. Please check for errors above."
    exit 1
  fi
fi

# Step 5: Copy pre-configured .p10k.zsh file
echo "Step 5: Copying pre-configured .p10k.zsh to home directory..."
cp ./config/.p10k.zsh ~/.p10k.zsh
echo "Step 6: .p10k.zsh has been successfully copied."

# Install MesloLGS NF fonts for Powerlevel10k
echo "Installing MesloLGS NF fonts..."

# Create fonts directory if it doesn't exist
mkdir -p "$HOME/Library/Fonts"

# Download all four font variants
echo "Downloading MesloLGS NF fonts..."
curl -fsSL -o "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
curl -fsSL -o "$HOME/Library/Fonts/MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
curl -fsSL -o "$HOME/Library/Fonts/MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
curl -fsSL -o "$HOME/Library/Fonts/MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"

# Verify font installation
if [ -f "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" ]; then
  echo "MesloLGS NF fonts installed successfully!"
  
  # Set MesloLGS NF as the default font in Terminal.app (Basic profile)
  echo "Step 7: Setting up Terminal font..."
  osascript <<EOD
tell application "Terminal"
    # Set Basic as default profile
    set default settings to settings set "Basic"
    set startup settings to settings set "Basic"
    
    # Configure the Basic profile
    tell settings set "Basic"
        set font name to "MesloLGS NF"
        set font size to 12
    end tell
end tell
EOD

  echo "Terminal font updated. Please restart Terminal for changes to take effect."
else
  echo "Font installation failed. Please check for errors above."
  exit 1
fi

# Step 8: Install custom plugins for Oh My Zsh
echo "Step 8: Installing custom plugins for Oh My Zsh..."
additional_plugins=(
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "zsh-history-substring-search"
)




# Check if the plugins line exists
if grep -q 'plugins=(' ~/.zshrc; then
    # Move the opening parenthesis to a new line if there is content after it
    sed -i '' '/^plugins=(\s*[^)]/s/^plugins=(\s*/plugins=(\n    /' ~/.zshrc

    # Find the first line after plugins=( that ends with )
    sed -i '' '/^plugins=(/,/)/ { /)$/! { N; }; /.*[^ ]$/ s/\(.*[^ ]\)\()$\)/\1\n\2/; }' ~/.zshrc
fi

# Add additional plugins before the closing parenthesis
for plugin in "${additional_plugins[@]}"; do
    # Define the plugin directory
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"

    # Clone the plugin repository if it doesn't exist
    if [ ! -d "$PLUGIN_DIR" ]; then
        echo "Installing $plugin..."
        git clone "https://github.com/zsh-users/$plugin.git" "$PLUGIN_DIR"
    else
        echo "$plugin is already installed."
    fi

    # Add plugin into ~/.zshrc
    if ! grep -q "$plugin" ~/.zshrc; then
        # Insert the plugin before the first closing parenthesis after plugins=(
        sed -i '' "/^plugins=(/,/)/ { /)/ s/)/    $plugin\n)/; }" ~/.zshrc
    fi
done

echo "Plugins have been added to .zshrc."


# Source zshrc using zsh
exec zsh -l

# Configure Finder preferences
echo "Setting Finder default view to list view..."
defaults write com.apple.finder FXPreferredViewStyle Nlsv
killall Finder

# Final reload of zsh
exec zsh -l

# Step 9: Final message
echo "Step 9: Installation complete. Please restart your terminal for changes to take effect."