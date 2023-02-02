
nix build --no-link <flake-uri>#homeConfigurations.sebas.activationPackage

"$(nix path-info <flake-uri>#homeConfigurations.sebas.activationPackage)"/activate


## Arch

### Preconditions

```sh
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
pushd yay-bin
makepkg -si
popd
rm -rf yay-bin
yay -Y --gendb

yay -S zsh
sudo chsh sebas -s /bin/zsh
```

### Wayland

```sh
yay -S wlroots
sudo usermod -aG seat sebas
sudo systemctl enable seatd.service
sudo systemctl start seatd.service
```


bemenu: Wayland-native alternative to dmenu                                                                           
dmenu: Application launcher used in default config                                                                    
foot: Terminal emulator used in the default configuration 
i3status: Status line generation                                                                                      
mako: Lightweight notification daemon                    
polkit: System privilege control. Required if not using seatd service
swaybg: Wallpaper tool for sway                                                                                       
swayidle: Idle management daemon                                                                                      
swaylock: Screen locker                                  
waybar: Highly customizable bar                                                                                       
xorg-xwayland: X11 support
