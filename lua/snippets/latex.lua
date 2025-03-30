local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local rep = require('luasnip.extras').rep

-- Snippets for LaTeX files
ls.add_snippets('tex', {
  -- Environment snippet: "beg" expands to \begin{...}...\end{...}
  s('beg', {
    t '\\begin{',
    i(1, 'environment'),
    t { '}', '\t' },
    i(2, 'content'),
    t { '', '\\end{' },
    rep(1),
    t '}',
  }),

  -- Fraction snippet: "frac" expands to \frac{numerator}{denominator}
  s('frac', {
    t '\\frac{',
    i(1, 'numerator'),
    t '}{',
    i(2, 'denominator'),
    t '}',
  }),

  -- Section snippet: "sec" expands to \section{...}
  s('sec', {
    t '\\section{',
    i(1, 'Section Title'),
    t '}',
  }),

  -- Subsection snippet: "ssec" expands to \subsection{...}
  s('ssec', {
    t '\\subsection{',
    i(1, 'Subsection Title'),
    t '}',
  }),

  -- Equation snippet: "eq" expands to an equation environment
  s('eq', {
    t '\\begin{equation}',
    t { '', '\t' },
    i(1, 'equation'),
    t { '', '\\end{equation}' },
  }),

  -- Align snippet: "al" expands to an align environment
  s('al', {
    t '\\begin{align}',
    t { '', '\t' },
    i(1, 'align equations'),
    t { '', '\\end{align}' },
  }),

  -- Figure snippet: "fig" expands to a figure environment with centering and caption
  s('fig', {
    t { '\\begin{figure}[htbp]', '\t\\centering' },
    t { '', '\t\\includegraphics[width=' },
    c(1, { t '0.8\\textwidth', t '\\linewidth' }),
    t ']{',
    i(2, 'image.png'),
    t '}',
    t { '', '\t\\caption{' },
    i(3, 'Caption'),
    t '}',
    t { '', '\\end{figure}' },
  }),

  -- Itemize snippet: "it" expands to an itemize environment
  s('it', {
    t { '\\begin{itemize}', '\t\\item ' },
    i(1, 'Item'),
    t { '', '\\end{itemize}' },
  }),

  -- Bibliography snippet: "bib" expands to a bibliography environment (if not using BibTeX)
  s('bib', {
    t { '\\begin{thebibliography}{9}', '\t\\bibitem{' },
    i(1, 'key'),
    t '} ',
    i(2, 'Reference'),
    t { '', '\\end{thebibliography}' },
  }),
})
