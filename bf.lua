-- bf.lua
-- brainfuck interpreter

cells = {pos = 1}
setmetatable(cells, {__index = function () return 0 end })

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
