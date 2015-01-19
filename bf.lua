-- bf.lua
-- brainfuck interpreter

Program = {}

function Program:incr()
  self.counter = self.counter + 1
end

function Program:inst()
  return self[self.counter]
end

function Program:done()
  return self:inst() == nil
end

-- Create a new program from string.
function Program:new(input)
  local program = {counter = 1}
  for i = 1, #input do
    program[i] = string.sub(input, i, i)
  end
  self.__index = self
  return setmetatable(program, self)
end

program = Program:new('++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.')

-- Run one instruction and increment program index.
function runOne(program)
  local i = program:inst()
  print(i)
  program:incr()
end

function run(program)
  while not program:done() do
    runOne(program)
  end
end

run(program)

-- array of cells, where each cell is a one character string
-- when a cell is first written to, it is written into the table.
cells = {}
setmetatable(cells, {__index = function () return 0 end })

-- while programIndex < #program do
--   print(program[programIndex])
--   programIndex = programIndex + 1
-- end
