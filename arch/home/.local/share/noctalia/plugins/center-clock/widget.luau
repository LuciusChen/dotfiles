--!nonstrict

-- The calendar icon looks like a paper calendar in any palette and mode, so its
-- colors are fixed rather than palette roles.
local HEADER = "#fb4934"
local PAPER = "#e3dfcb"
local INK = "#1a1b1b"

local function render()
  local time = os.date("%H:%M:%S")
  local weekday = string.upper(os.date("%a"))
  local date = os.date("%d")

  barWidget.render(ui.row({ gap = 5, align = "center" }, {
    ui.column({
      width = 20,
      height = 19,
      gap = 0,
      fill = PAPER,
      radius = 3,
      border = "outline_variant",
      borderWidth = 1,
      align = "center",
      justify = "center",
    }, {
      ui.row({
        width = 20,
        height = 8,
        fill = HEADER,
        radius = 0,
        align = "center",
        justify = "center",
      }, {
        ui.label({
          text = weekday,
          fontSize = 7,
          fontWeight = "bold",
          color = PAPER,
          textAlign = "center",
          baseline = "text",
        }),
      }),
      ui.row({
        width = 20,
        height = 11,
        fill = PAPER,
        radius = 0,
        align = "center",
        justify = "center",
      }, {
        ui.label({
          text = date,
          fontSize = 11,
          fontWeight = "bold",
          color = INK,
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
