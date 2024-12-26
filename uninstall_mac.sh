#!/bin/bash

echo "Starting uninstallation process..."

# Uninstall Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Uninstalling Oh My Zsh..."
    # Run the official uninstall script
    sh "$HOME/.oh-my-zsh/tools/uninstall.sh"
else
    echo "Oh My Zsh is not installed."
fi

# Remove .zshrc.backup if it exists
if [ -f ~/.zshrc.backup ]; then
    echo "Removing .zshrc.backup file..."
    rm ~/.zshrc.backup
fi

# Remove .zsh_history file
if [ -f ~/.zsh_history ]; then
    echo "Removing .zsh_history file..."
    rm ~/.zsh_history
fi

# Remove .zsh_sessions directory if it exists
if [ -d ~/.zsh_sessions ]; then
    echo "Removing .zsh_sessions directory..."
    rm -rf ~/.zsh_sessions
fi

# Remove all .zshrc* files (including backups)
echo "Removing all .zshrc* files..."
rm -f ~/.zshrc*

# Remove Powerlevel10k theme
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "Removing Powerlevel10k theme..."
    rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
fi

# Remove .p10k.zsh configuration file
if [ -f ~/.p10k.zsh ]; then
    echo "Removing .p10k.zsh configuration file..."
    rm ~/.p10k.zsh
fi

# Remove custom plugins
echo "Removing custom plugins..."
plugins=(
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
    "autoswitch_virtualenv"
    "zsh-history-substring-search"
)

for plugin in "${plugins[@]}"; do
    if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin" ]; then
        echo "Removing $plugin..."
        rm -rf "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
    fi
done

# Remove MesloLGS NF fonts
echo "Removing MesloLGS NF fonts..."
fonts=(
    "MesloLGS NF Regular.ttf"
    "MesloLGS NF Bold.ttf"
    "MesloLGS NF Italic.ttf"
    "MesloLGS NF Bold Italic.ttf"
)

for font in "${fonts[@]}"; do
    if [ -f "$HOME/Library/Fonts/$font" ]; then
        echo "Removing $font..."
        rm "$HOME/Library/Fonts/$font"
    fi
done

# Reset Terminal font settings to default
echo "Resetting Terminal font settings..."
osascript <<EOD
tell application "Terminal"
    set default settings to settings set "Basic"
    set startup settings to settings set "Basic"
    
    tell settings set "Basic"
        set font name to "SF Mono"
        set font size to 11
    end tell
end tell
EOD

# Uninstall Homebrew if requested
read -p "Do you want to uninstall Homebrew? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstalling Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
fi

echo "Uninstallation complete. Please restart your terminal for changes to take effect." 
