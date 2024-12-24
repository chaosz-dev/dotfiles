local app = require("astal.gtk3.app")
local bar = require("widgets.bar")

app:start({
  css = "./style.css",
  main = function()
    bar(0)
  end
})

