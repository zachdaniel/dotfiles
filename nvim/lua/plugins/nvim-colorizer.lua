return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup({
      '*',
      html = {
        mode = 'foreground'
      }
    })
  end
}
