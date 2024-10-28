local easter_egg_icons = { '󰄛 ', '󰚾 ', '󱄅 ' }

local icons = { '󱓉 ', '󰐙 ', '󰀚 ', '󰎝 ', '󰆃 ', '󰕜 ' }

local function random_normal_icon()
  return icons[math.random(#icons)]
end

local function random_easter_egg_icon()
  return easter_egg_icons[math.random(#easter_egg_icons)]
end

local function get_random_icon()
  if math.random(7) == 3 then
    return random_easter_egg_icon()
  end

  return random_normal_icon()
end

require("tabline").setup({
  options = {
    section_separators = { '', '' },
    component_separators = { '', '' },
    show_tabs_only = false,
    show_devicons = true,
    show_bufnr = false,
    modified_icon = get_random_icon(), -- set new icon each session
    modified_italic = true
  }
})

vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'black', fg = 'black' })
