local function remove_background(elements)
  for _, element in ipairs(elements) do
    vim.api.nvim_set_hl(0, element, { bg = "none" })
  end
end

local function remove_telescope_background()
  local elements = {
    "TelescopeBorder",
    "TelescopePromptBorder",

    "TelescopeResultsTitle",
    "TelescopePreviewTitle",
    "TelescopePromptTitle",

    "TelescopeResultsNormal",
    "TelescopePreviewNormal",
    "TelescopePromptNormal",

    "GitSignsAdd",
    "GitSignsChange",
    "GitSignsDelete",
  }

  remove_background(elements)
end

local function remove_lsp_background()
  local elements = {
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
  }

  remove_background(elements)
end

local function remove_git_background()
  local elements = {
    "DiagnosticSignError",
    "DiagnosticSignWarn",
    "DiagnosticSignInfo",
    "DiagnosticSignHint",
  }

  remove_background(elements)
end

local function remove_misc_backgrounds(elements)
  remove_background(elements)
end

-- exposing this globally for ad-hoc use
function setColor(color)
  color = color or DEFAULT_COLOR
  DEFAULT_COLOR = color
  vim.cmd.colorscheme(color)

  remove_telescope_background()
  remove_lsp_background()
  remove_git_background()

  remove_misc_backgrounds({
    "Normal",
    "NormalFloat",
    "SignColumn"
  })

  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "white", bg = "none" })
  vim.api.nvim_set_hl(0, "FloatTitle", { fg = "white", bg = "none" })
end

setColor()
