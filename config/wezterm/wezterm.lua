-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- rendering and fps
config.max_fps = 165
config.default_prog = { '/usr/bin/fish', '-l' }

-- tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Colorscheme
config.color_scheme = 'gruvbox'
-- config.color_scheme = 'gruvbox'
config.enable_wayland = true
config.window_background_opacity = 0.8
config.kde_window_background_blur = true

-- Padding
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- cursor thickness
config.cursor_thickness = 2
config.default_cursor_style = 'SteadyBar'

-- font
config.font = wezterm.font('CaskaydiaCove Nerd Font Mono')
config.font_size = 14
config.font_size = 14

-- keybindings
config.keys = {
  -- ToggleFullScreen
  {
    key = 'f',
    mods = 'ALT|CTRL',
    action = wezterm.action.ToggleFullScreen
  },
  -- copy paste
  {
    key = 'c',
    mods = 'ALT|CTRL',
    action = wezterm.action.CopyTo 'Clipboard'
  },
  {
    key = 'v',
    mods = 'ALT|CTRL',
    action = wezterm.action.PasteFrom 'Clipboard'
  },
}

-- and finally, return the configuration to wezterm
return config
