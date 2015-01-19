local M = {}

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

local function noop()
  print 'ok'
end

local function incrDataPointer(state)
  state.data.pointer = state.data.pointer + 1
end

local function decrDataPointer(state)
  state.data.pointer = state.data.pointer - 1
end

local function incrCodePointer(state)
  state.code.pointer = state.code.pointer + 1
end

local function decrCodePointer(state)
  state.code.pointer = state.code.pointer - 1
end

local function incrData(state)
  index = state.data.pointer
  state.data[index] = state.data[index] + 1
end

local function decrData(state)
  index = state.data.pointer
  state.data[index] = state.data[index] - 1
end

local function forwardIfZero(state)
  if state.data[state.data.pointer] == 0 then
    repeat
      incrCodePointer(state)
    until state.code[state.code.pointer] == ']'
  end
end

local function backIfNonZero(state)
  if not (state.data[state.data.pointer] == 0) then
    repeat
      decrCodePointer(state)
    until state.code[state.code.pointer] == '['
  end
end

local function printData(state)
  c = state.data[state.data.pointer]
  state.output = state.output .. c
end

local instructions = {
  ['>'] = incrDataPointer,
  ['<'] = decrDataPointer,
  ['+'] = incrData,
  ['-'] = decrData,
  ['['] = forwardIfZero,
  [']'] = backIfNonZero,
  ['.'] = printData,
  [','] = noop
}

local function step(state)
  local inst = state.code[state.code.pointer]
  instructions[inst](state)
  incrCodePointer(state)
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
