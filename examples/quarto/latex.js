// For info on how these correspond to latex's def/newcommand/etc, see:
// https://docs.mathjax.org/en/latest/input/tex/macros.html

window.MathJax = {
  tex: {
    macros: {
      y: "\\mathbf{y}",
      X: "\\mathbf{X}",
      R: "\\mathbb{R}",
      eps: "\\varepsilon",
      epsB: "\\boldsymbol{\\varepsilon}",
      betaB: "\\boldsymbol{\\beta}",
      Var: ["\\mathop{\\mathrm{Var}}", 0]
    }
  }
};