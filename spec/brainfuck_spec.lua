brainfuck = require 'brainfuck'

describe("brainfuck", function()
  it("adds 2", function()
    assert.are.same('2', brainfuck.eval('++.'))
  end)
  it("loops", function()
    assert.are.same('81', brainfuck.eval('++[>++++<-]>.<+.'))
  end)
  it("nested loops", function()
    local s = brainfuck.eval([[
      ++++  add 4 to cell #0 (initialize outer loop counter to 4)
      [
        >++ add 2 to cell #1 (initialize inner loop counter to 2)
        [
          >++ add 2 to cell #2
          <- subtract 1 from cell #1
        ]
        <- subtract 1 from cell #0
      ]
      >>. print cell #2
    ]])
    assert.are.same('16', s)
  end)
end)
