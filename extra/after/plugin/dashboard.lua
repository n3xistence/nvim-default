local db = require('dashboard')
local ascii = require('ascii')

local function concat_tables(...)
  local insert = {}
  local tables = { ... }

  for _, t in ipairs(tables) do
    for _, v in ipairs(t) do
      table.insert(insert, v)
    end
  end

  return insert
end

local function split(str, sep)
  local fields = {}
  local pattern = string.format("([^%s]+)", sep)
  str:gsub(pattern, function(c) fields[#fields + 1] = c end)

  return fields
end

local function is_file(str)
  if not str or #str == 0 then
    return false
  end

  local elements = split(str, '.')

  return #elements > 1
end

local function get_file(path)
  local elements = split(path, '/')

  return elements[#elements]
end

-- local function nl_string_to_table(s)
--   local lines = {}
--
--   for line in s:gmatch("[^\r\n]+") do
--     table.insert(lines, line)
--   end
--
--   return lines
-- end
--
-- local custom_header = nl_string_to_table([[
--
-- ]])

db.setup({
  theme = 'hyper',
  config = {
    header = concat_tables(
      ascii.art.planets.planets.saturn_plus,
      ascii.art.text.neovim.sharp,
      { "", "" } -- add a newline
    ),
    plugins = { enable = true },
    footer = {}, -- removes the footer
    shortcut = {
      { desc = '󰊳 Update', group = '@property', action = 'PackerSync', key = 'u' },
      {
        icon = ' ',
        icon_hl = '@variable',
        desc = 'Files',
        group = 'Label',
        action = 'Telescope find_files',
        key = 'f',
      },
      {
        desc = ' Apps',
        group = 'DiagnosticHint',
        -- action = 'Telescope find_files cwd=~/source/repos',
        action = 'Oil ~/source/repos',
        key = 'a',
      },
      {
        desc = ' dotfiles',
        group = 'Number',
        action = 'Oil ~/source/setup/.dotfiles',
        key = 'd',
      },
      {
        desc = '󰐥 quit',
        group = 'Label',
        action = 'quit',
        key = 'q',
      }
    },
  },
})

local current_file = get_file(vim.fn.expand("%:p"))
if not is_file(current_file) then
  -- vim.cmd("Dashboard")
end

vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#add8e6' })
vim.keymap.set("n", "<leader>d", ":Dashboard<CR>", { noremap = true })
