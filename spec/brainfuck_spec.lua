brainfuck = require 'brainfuck'

describe("brainfuck", function()
  it("adds 2", function()
    assert.are.same('\\2', brainfuck.eval('++.'))
  end)
  it("loops", function()
    assert.are.same('\\8\\1', brainfuck.eval('++[>++++<-]>.<+.'))
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
    assert.are.same('\\16', s)
  end)
  it("hello world", function ()
    local helloworld = brainfuck.eval([[
+++++ +++               Set Cell #0 to 8
[
    >++++               Add 4 to Cell #1; this will always set Cell #1 to 4
    [                   as the cell will be cleared by the loop
        >++             Add 2 to Cell #2
        >+++            Add 3 to Cell #3
        >+++            Add 3 to Cell #4
        >+              Add 1 to Cell #5
        <<<<-           Decrement the loop counter in Cell #1
    ]                   Loop till Cell #1 is zero; number of iterations is 4
    >+                  Add 1 to Cell #2
    >+                  Add 1 to Cell #3
    >-                  Subtract 1 from Cell #4
    >>+                 Add 1 to Cell #6
    [<]                 Move back to the first zero cell you find; this will
                        be Cell #1 which was cleared by the previous loop
    <-                  Decrement the loop Counter in Cell #0
]                       Loop till Cell #0 is zero; number of iterations is 8
 
The result of this is:
Cell No :   0   1   2   3   4   5   6
Contents:   0   0  72 104  88  32   8
Pointer :   ^
 
>>.                     Cell #2 has value 72 which is 'H'
>---.                   Subtract 3 from Cell #3 to get 101 which is 'e'
+++++++..+++.           Likewise for 'llo' from Cell #3
>>.                     Cell #5 is 32 for the space
<-.                     Subtract 1 from Cell #4 for 87 to give a 'W'
<.                      Cell #3 was set to 'o' from the end of 'Hello'
+++.------.--------.    Cell #3 for 'rl' and 'd'
>>+.                    Add 1 to Cell #5 gives us an exclamation point
>++.                    And finally a newline from Cell #6
    ]])
    assert.are.same('Hello World!\n', helloworld)
  end)
end)
