local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep


return {
  -- To return multiple snippets, use one `return` statement per snippet file
  -- and return a table of Lua snippets.
  s(
    { trig = "beg" },
    fmta([[
    \begin{<>}
    \end{<>}
    ]], { i(1), rep(1) }
    )
  ),
}
