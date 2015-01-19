brainfuck = require 'brainfuck'

describe("brainfuck", function()
  it("adds 2", function()
    assert.are.same('2', brainfuck.eval('++.'))
  end)
  it("loops", function()
    assert.are.same('8', brainfuck.eval('++[>++++<-]>.'))
  end)
end)
