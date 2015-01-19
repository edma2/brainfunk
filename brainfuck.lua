local M = {}

-- Returns an array with valid Brainfuck characters.
local function tokens(s)
  local ts = {}
  local j = 1
  for i = 1, #s do
    c = string.sub(s, i, i)
    if string.find('><+-.,][', c, 1, true) then
      ts[j] = c
      j = j + 1
    end
  end
  return ts
end

local function dataAdd(state, amount)
  index = state.data.pointer
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
  depth = 0
  matchingPair = terminateAt == ']' and '[' or ']'
  repeat
    inst = state.code[state.code.pointer]
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

local function dataWrite(state)
  c = state.data[state.data.pointer]
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
