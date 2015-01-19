brainfuck = require 'brainfuck'

local function evalWithOutput(src, fn)
  out = io.tmpfile()
  io.output(out)
  brainfuck.eval(src)
  io.input(out)
  out:seek('set')
  fn(io.read())
  out:close()
end

describe("brainfuck", function()
  it("adds 2", function()
    evalWithOutput('++.', function (output)
      assert.are.same('2', output)
    end)
  end)
  it("loops", function()
    evalWithOutput('++[>+++<-]>.', function (output)
      assert.are.same('8', output)
    end)
  end)
end)
