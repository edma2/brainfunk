-- bf.lua
-- brainfuck interpreter

cells = {pointer = 1, get = function () return cells[cells.pointer] end }
setmetatable(cells, {__index = function () return 0 end })

Program = {}

function Program:incr()
  self.counter = self.counter + 1
end

function Program:decr()
  self.counter = self.counter - 1
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
function noop()
end

-- if the byte at the data pointer is zero, then instead of moving
-- the instruction pointer forward to the next command, jump it forward
-- to the command after the matching ] command.
function forward(cells, program)
  if cells.get() == 0 then
    repeat
      program:incr()
    until program:inst() == ']'
    program:incr()
  end
end

-- if the byte at the data pointer is nonzero, then instead of moving
-- the instruction pointer forward to the next command, jump it back
-- to the command after the matching [ command.
function back(cells, program)
  if not (cells.get() == 0) then
    repeat
      program:decr()
    until program:inst() == '['
    program:incr()
  end
end

function shiftRight(cells)
  cells.pointer = cells.pointer + 1
end

function shiftLeft(cells)
  cells.pointer = cells.pointer - 1
end

function incr(cells)
  cells[cells.pointer] = cells.get() + 1
end

function decr(cells)
  cells[cells.pointer] = cells.get() - 1
end

interpreter = {}
setmetatable(interpreter, {__index = function (cells) return noop end})
interpreter['>'] = shiftRight
interpreter['<'] = shiftLeft
interpreter['+'] = incr
interpreter['-'] = decr
interpreter['.'] = function (cells) print(cells.get()) end
interpreter[','] = noop
interpreter['['] = forward
interpreter[']'] = back

function run(program)
  while not program:done() do
    local i = program:inst()
    interpreter[i](cells, program)
    program:incr()
  end
end

function main()
  -- program = Program:new('++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.')
  
  program = Program:new([[
  +++++ +++	Set Cell #1 to 8
  [
    >+ increment cell #2 by 1
    <- decrement cell #1 by 1
  ]
  ]])
  
  run(program)

  print(cells)
  for k, v in pairs(cells) do
    if type(v) == 'number' then
      print(k .. ':' .. v)
    end
  end
end
