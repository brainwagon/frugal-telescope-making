-- Auto-size table columns proportionally to their content length and make
-- every table span the full text width. Fixes pandoc's default behavior of
-- giving text-heavy columns (e.g. "Notes") the same width as tiny ones,
-- which produces cramped, overly tall columns in the PDF.

local function cell_len(blocks)
  local n = 0
  pandoc.walk_block(pandoc.Div(blocks), {
    Str = function(s) n = n + #s.text end,
    Space = function() n = n + 1 end,
    SoftBreak = function() n = n + 1 end,
  })
  return n
end

function Table(t)
  local ncol = #t.aligns
  if ncol == 0 then return nil end

  -- Longest single token (word/URL) per column: a column must be at least
  -- wide enough to fit its widest unbreakable-ish chunk, otherwise text
  -- overflows. We approximate "max word length" as a floor.
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

  -- Use sqrt of length to compress the spread a little: a column with 5x the
  -- text shouldn't be a literal 5x as wide, which would starve short columns.
  local weights = {}
  local total = 0
  for i = 1, ncol do
    weights[i] = math.sqrt(maxlen[i])
    total = total + weights[i]
  end

  local widths = {}
  for i = 1, ncol do
    widths[i] = weights[i] / total
  end
  t.widths = widths
  return t
end
