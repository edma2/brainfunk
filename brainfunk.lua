local M = {}

local function isToken(c)
  return string.find('><+-.,][', c, 1, true)
end

-- Returns an array with valid Brainfuck characters.
local function tokens(s)
  local ts = {}
  local j = 1
  for i = 1, #s do
    local c = string.sub(s, i, i)
    if isToken(c) then
      ts[j] = c
      j = j + 1
    end
  end
  return ts
end

local function dataAdd(state, amount)
  local index = state.data.pointer
  state.data[index] = state.data[index] + amount
end

local function dataIncr(state) dataAdd(state, 1) end

local function dataDecr(state) dataAdd(state, -1) end

local function dataShiftRight(state)
  state.data.pointer = state.data.pointer + 1
end

local function dataShiftLeft(state)
  state.data.pointer = state.data.pointer - 1
end

local function codeShiftRight(state)
  state.code.pointer = state.code.pointer + 1
end

local function codeShiftLeft(state)
  state.code.pointer = state.code.pointer - 1
end

local function repeatMove(state, move, terminateAt)
  local depth = 0
  local matchingPair = terminateAt == ']' and '[' or ']'
  repeat
    local inst = state.code[state.code.pointer]
    if inst == matchingPair then
      depth = depth + 1
    elseif inst == terminateAt then
      depth = depth - 1
    end
    move(state)
  until depth == 0
end

local function forwardIfZero(state)
  if state.data[state.data.pointer] == 0 then
    repeatMove(state, codeShiftRight, ']')
  end
end

local function reverseIfNonZero(state)
  if not (state.data[state.data.pointer] == 0) then
    repeatMove(state, codeShiftLeft, '[')
  end
end

local function isPrintableAscii(c)
  return c >= 32 and c <= 126 or c == 10 -- newline
end

local function dataWrite(state)
  local n = state.data[state.data.pointer]
  local c
  if isPrintableAscii(n) then
    c = string.char(n)
  else
    c = '\\' .. n
  end
  state.output = state.output .. c
end

local instructionSet = {
  ['>'] = dataShiftRight,
  ['<'] = dataShiftLeft,
  ['+'] = dataIncr,
  ['-'] = dataDecr,
  ['['] = forwardIfZero,
  [']'] = reverseIfNonZero,
  ['.'] = dataWrite,
}

-- Process one instruction.
local function step(state)
  local inst = state.code[state.code.pointer]
  instructionSet[inst](state)
  codeShiftRight(state)
end

function M.eval(s, input)
  local code = tokens(s)
  local length = #code
  local data = setmetatable({}, {__index = function () return 0 end})
  local state = {code = code, data = data, output = '', input = input and input or ''}
  code.pointer = 1
  data.pointer = 1
  repeat
    step(state)
  until code.pointer > length
  return state.output
end

return M
