--!nonstrict

local function render()
  local time = os.date("%H:%M:%S")
  local weekday = os.date("%a")
  local date = os.date("%d")

  barWidget.render(ui.row({ gap = 6, align = "center" }, {
    ui.column({
      width = 20,
      height = 19,
      gap = 0,
      fill = "on_surface",
      radius = 3,
      border = "outline",
      borderWidth = 1,
      align = "center",
      justify = "center",
    }, {
      ui.row({
        width = 20,
        height = 8,
        fill = "error",
        radius = 0,
        align = "center",
        justify = "center",
      }, {
        ui.label({
          text = weekday,
          fontSize = 7,
          fontWeight = "bold",
          color = "on_surface",
          textAlign = "center",
          baseline = "text",
        }),
      }),
      ui.row({
        width = 20,
        height = 11,
        fill = "on_surface",
        radius = 0,
        align = "center",
        justify = "center",
      }, {
        ui.label({
          text = date,
          fontSize = 11,
          fontWeight = "bold",
          color = "surface",
          textAlign = "center",
          baseline = "textFixedHeight",
        }),
      }),
    }),
    ui.label({
      text = time,
      fontSize = 13,
      color = "on_surface",
      baseline = "textFixedHeight",
    }),
  }))

  barWidget.setTooltip(os.date("%A, %Y-%m-%d"))
end

function update()
  noctalia.setUpdateInterval(1000)
  render()
end

function onClick()
  noctalia.runAsync("noctalia msg panel-toggle control-center calendar")
end
