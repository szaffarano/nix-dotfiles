DOTFILES_DIR="${NH_FLAKE:-}"
NVIM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_CONFIG_BKP="$NVIM_CONFIG.bkp"
SOURCE_CONFIG="$DOTFILES_DIR/modules/home-manager/terminal/editors/nvim/config"

# Validate NH_FLAKE is set
if [[ -z $DOTFILES_DIR ]]; then
	echo "Error: NH_FLAKE environment variable is not set" >&2
	echo "Set it to your dotfiles directory path (e.g., export NH_FLAKE=~/.dotfiles)" >&2
	exit 1
fi

# Validate dotfiles directory exists
if [[ ! -d $DOTFILES_DIR ]]; then
	echo "Error: Dotfiles directory not found at $DOTFILES_DIR" >&2
	exit 1
fi

# Validate source config exists
if [[ ! -d $SOURCE_CONFIG ]]; then
	echo "Error: Neovim config not found at $SOURCE_CONFIG" >&2
	echo "Expected path: modules/home-manager/terminal/editors/nvim/config" >&2
	exit 1
fi

# Detect current state and toggle
if [[ -L $NVIM_CONFIG ]]; then
	# Currently in live mode -> restore managed mode
	echo "Detected live mode (symlink). Restoring managed config..."
	rm "$NVIM_CONFIG"
	if [[ -d $NVIM_CONFIG_BKP ]]; then
		mv "$NVIM_CONFIG_BKP" "$NVIM_CONFIG"
		echo "Restored from backup. Now in managed mode."
	else
		echo "Warning: No backup found. Symlink removed."
	fi
else
	# Currently in managed mode -> enable live mode
	echo "Enabling live mode..."
	if [[ -d $NVIM_CONFIG ]]; then
		mv "$NVIM_CONFIG" "$NVIM_CONFIG_BKP"
		echo "Backed up existing config to $NVIM_CONFIG_BKP"
	fi
	ln -s "$SOURCE_CONFIG" "$NVIM_CONFIG"
	echo "Created symlink to $SOURCE_CONFIG"
	echo "Now in live mode."
fi
