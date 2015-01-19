dofile 'bf.lua'

local empty = Program:new('')
local source1 = [[
  +++++ +++	Set Cell #1 to 8
  [
    >+ increment cell #2 by 1
    <- decrement cell #1 by 1
  ]
]]
local program1 = Program:new(source1)

describe("a program", function()
  it("can be empty", function()
    assert(empty:done())
  end)
  
  it("program1", function()
    run(program1)
    assert.equals(8, cells[2])
  end)
end)

describe("a nested block", function()
  describe("can have many describes", function()
    -- tests
  end)

  -- more tests pertaining to the top level
end)
