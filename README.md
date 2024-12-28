# macOS Terminal Enhancer

## A script to enhance the macOS terminal experience by installing popular Zsh plugins and the Powerlevel10k theme.

## Overview

This script is designed for **macOS** and automates the installation of popular Zsh plugins for Oh My Zsh, specifically:
- `zsh-syntax-highlighting`
- `zsh-autosuggestions`
- `zsh-history-substring-search`

Additionally, the script installs the **Powerlevel10k (p10k)** theme, which provides a beautiful and customizable prompt for your terminal.

The script checks if these plugins and the theme are already installed and adds them to the `.zshrc` configuration file if they are not present. It ensures that your Zsh environment is enhanced with useful features for a better command line experience.

## Features

- **Installs Oh My Zsh**: This script installs [Oh My Zsh GitHub page](https://github.com/ohmyzsh/ohmyzsh).
- **Installs Plugins**: Clones the specified plugins from their GitHub repositories if they are not already installed.
- **Installs Powerlevel10k Theme**: Clones the Powerlevel10k theme repository and sets it up for use.
- **Updates .zshrc**: Adds the plugins and theme to the `plugins` array and sets the theme in your `.zshrc` file.
- **Sourcing**: Automatically sources the `.zshrc` file to apply changes immediately.


## How to Use the Script

1. **Run the Installation Script**: The script will automatically check for and install the necessary Xcode Command Line Tools if they are not already installed. Simply execute the script:

   ```bash
   ./initial_install_mac.sh
   ```

2. **Clone the Repository**: If you haven't already, clone the repository containing this script to your local machine.

   ```bash
   git clone https://github.com/coder8matic/macos-terminal-enhancer.git
   cd macos-terminal-enhancer
   ```

3. **Make the Script Executable**: Ensure the script is executable by running:

   ```bash
   chmod +x initial_install_mac.sh
   ```

4. **Verify Installation**: After running the script, you can verify that the plugins and theme are installed by checking the `~/.oh-my-zsh/custom/plugins/` directory and ensuring that they are listed in your `.zshrc` file.

5. **Restart Terminal**: Close and reopen your terminal or run `source ~/.zshrc` to apply the changes.

## Example .zshrc Configuration

After running the script, your `.zshrc` file should include a `plugins` section and the theme configuration similar to the following:

```bash
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-history-substring-search
)

# Set the theme to Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"
```

## Troubleshooting

- If you encounter any issues with plugin or theme installation, ensure that you have an active internet connection and that Git is installed on your system.
- If the plugins or theme do not appear to be working, make sure to source your `.zshrc` file or restart your terminal.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the authors of the plugins and the Powerlevel10k theme for their contributions to the Zsh community.
- Special thanks to the [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) team for creating a powerful framework for managing Zsh configurations.
