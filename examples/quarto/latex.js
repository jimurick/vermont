// For info on how these correspond to latex's def/newcommand/etc, see:
// https://docs.mathjax.org/en/latest/input/tex/macros.html

window.MathJax = {
  tex: {
    macros: {
      y: "\\mathbf{y}",
      x: "\\mathbf{x}",
      X: "\\mathbf{X}",
      H: "\\mathbf{H}",
      R: "\\mathbb{R}",
      E: "\\mathbb{E}",
      eps: "\\varepsilon",
      epsB: "\\boldsymbol{\\varepsilon}",
      betaB: "\\boldsymbol{\\beta}",
      MyFunc: ["\\mathop{\\mathrm{MyFunc}}", 0],
      MSE: ["\\mathop{\\mathrm{MSE}}", 0],
      Exp: ["\\mathop{\\mathrm{E}}", 0],
      Var: ["\\mathop{\\mathrm{Var}}", 0],
      Cov: ["\\mathop{\\mathrm{Cov}}", 0],
      sd: ["\\mathop{\\mathrm{sd}}", 0],
      tr: ["\\mathop{\\mathrm{tr}}", 0]
    }
  }
};