-- Auto-size table columns proportionally to their content length and make
-- every table span the full text width. Fixes pandoc's default behavior of
-- giving text-heavy columns (e.g. "Notes") the same width as tiny ones,
-- which produces cramped, overly tall columns.
--
-- Works with both the legacy Table AST (pandoc < 2.10: aligns/headers/rows/
-- widths) and the current one (pandoc >= 2.10: colspecs/head/bodies).

local function cell_len(blocks)
  local n = 0
  pandoc.walk_block(pandoc.Div(blocks), {
    Str = function(s) n = n + #s.text end,
    Space = function() n = n + 1 end,
    SoftBreak = function() n = n + 1 end,
  })
  return n
end

-- Turn a per-column "longest content" vector into normalized widths. Uses sqrt
-- to compress the spread: a column with 5x the text shouldn't be a literal 5x
-- as wide, which would starve the short columns.
local function widths_from_maxlen(maxlen, ncol)
  local weights, total = {}, 0
  for i = 1, ncol do
    weights[i] = math.sqrt(maxlen[i])
    total = total + weights[i]
  end
  local widths = {}
  for i = 1, ncol do widths[i] = weights[i] / total end
  return widths
end

function Table(t)
  -- New AST (pandoc >= 2.10): colspecs is a list of {alignment, width} pairs.
  if t.colspecs ~= nil then
    local ncol = #t.colspecs
    if ncol == 0 then return nil end

    local maxlen = {}
    for i = 1, ncol do maxlen[i] = 1 end

    local function scan_rows(rows)
      for _, row in ipairs(rows) do
        for i, cell in ipairs(row.cells) do
          if i <= ncol then
            local l = cell_len(cell.contents)
            if l > maxlen[i] then maxlen[i] = l end
          end
        end
      end
    end

    scan_rows(t.head.rows)
    for _, body in ipairs(t.bodies) do
      scan_rows(body.head)
      scan_rows(body.body)
    end

    local widths = widths_from_maxlen(maxlen, ncol)
    for i = 1, ncol do
      t.colspecs[i][2] = widths[i]
    end
    return t
  end

  -- Legacy AST (pandoc < 2.10).
  local ncol = #t.aligns
  if ncol == 0 then return nil end

  local maxlen = {}
  for i = 1, ncol do maxlen[i] = 1 end

  local function scan(cells)
    for i, c in ipairs(cells) do
      local l = cell_len(c)
      if l > maxlen[i] then maxlen[i] = l end
    end
  end

  scan(t.headers)
  for _, row in ipairs(t.rows) do scan(row) end

  t.widths = widths_from_maxlen(maxlen, ncol)
  return t
end
