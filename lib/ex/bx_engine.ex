defmodule BX.Engine do
  alias BX.Cursor

  @doc """
  Create a new engine
  """
  def new(code) do
    space = BX.Space.new(code)
    new(
      space, 
      Cursor.new(BX.Space.size(space)), 
      [])

  end
  def new(space, cursor, stack) do
    %{space: space, cursor: cursor, stack: stack, pushMode: false, output: ""}
  end

  @doc """
  Extract the next instruction
  """
  def instruction(engine) do
    engine.space[Cursor.position(engine.cursor)]
  end

  @doc """
  Advance cursor to next instruction
  """
  def advance(%{cursor: cursor} = engine) do
    %{ engine | cursor: BX.Cursor.advance(cursor) }
  end

  @doc """
  Changes direction
  """
  def new_direction("_", 0),  do: ">"
  def new_direction("_", _),  do: "<"
  def new_direction("|", 0),  do: "v"
  def new_direction("|", _),  do: "^"

  @doc """
  Convert a digit to a string
  """
  def digit_to_string(digit) do String.at("0123456789", digit) end

  def to_codepoint(<< val :: utf8 >>) do val end
  def from_codepoint(val) do << val :: utf8 >> end

  @doc """
  Perform a stack operation
  """
  def perform_operation(op, [a, b]) do
    import String

    case to_atom(op) do
      :+ -> [a + b]
      :- -> [a - b]
      :* -> [a * b]
      :/ -> [div(a, b)]
      :% -> [rem(b, a)]
      :! -> [if a == 0 do 1 else 0 end, b]
      :'`' -> [if b > a do 1 else 0 end]
      :':' -> [a, a, b]
      :'\\' -> [b, a]
      :'$' -> []
    end
  end

  @doc """
  Push entry to stack
  """
  def push_stack(stack, entry) do [ entry | stack ] end

  @doc """
  Push list to stack
  """
  def push_list(stack, list) do list ++ stack end

  @doc """
  Pop stack
  """
  def pop_stack([]) do {0, []} end
  def pop_stack([top | rest]) do {top, rest} end

  @doc """
  Top stack
  """
  def top_stack([]) do 0 end
  def top_stack([top | _rest]) do top end

  @doc """
  Get operation
  """
  def get_operation(%{space: space, stack: stack} = engine) do
    { y, stack } = pop_stack(stack)
    { x, stack } = pop_stack(stack)
    stack = push_stack(stack, to_codepoint(space[%{x: x, y: y}]))
    %{ engine | space: space, stack: stack}
  end

  @doc """
  Put operation
  """
  def put_operation(%{space: space, stack: stack} = engine) do
    { y, stack } = pop_stack(stack)
    { x, stack } = pop_stack(stack)
    { v, stack } = pop_stack(stack)
    space = Map.put(space, %{x: x, y: y}, v)
    %{ engine | space: space, stack: stack}
  end

  @doc """
  Append to output
  """
  def append_output(output, char) do
    output <> char
  end

  @doc """
  Execute operation
  """
  def exec_operation(op, %{stack: stack, output: output} = engine) do
    { a, stack } = pop_stack stack
    { b, stack } = pop_stack stack
    %{ engine | stack:  push_list(stack, perform_operation(op, [a, b])) }
  end

  @doc """
  Execute an instruction
  """
  def execute_instruction(instruction, %{cursor: cursor, stack: stack, pushMode: pushMode, output: output} = engine) do
    cond do
      instruction == "@" -> raise "end of file not expected"
      instruction == "\"" -> %{ engine | pushMode: !pushMode }
      pushMode -> %{ engine | stack: push_stack(stack, to_codepoint(instruction)) }
      String.match? instruction,  ~r/[0-9]/ -> %{ engine | stack: push_stack(stack, String.to_integer(instruction)) }
      String.match? instruction, ~r/[<>^v\?]/ -> %{ engine | cursor: Cursor.change_direction(cursor, instruction) }
      String.match? instruction, ~r/[|_]/ -> { top, stack } = pop_stack(stack); %{ engine | stack: stack, cursor: Cursor.change_direction(cursor, new_direction(instruction, top)) }
      instruction == "." -> ({val, stack} = pop_stack(stack); %{ engine | output: append_output(output, to_string(val)), stack: stack })
      instruction == "," -> ({val, stack} = pop_stack(stack); %{ engine | output: append_output(output, from_codepoint(val)), stack: stack })
      instruction == "#" -> advance(engine)
      instruction == "g" -> get_operation(engine)
      instruction == "p" -> put_operation(engine)
      instruction == "&" -> %{ engine | stack: push_stack(stack, IO.gets "Enter a digit: ")}
      instruction != " " -> exec_operation instruction, engine
      true -> engine
    end |> advance

  end

  @doc """
  Execute next instruction
  """
  def execute(engine) do
    execute_instruction instruction(engine), engine
  end

  @doc """
  Execute count instructions
  """
  def execute(engine, 0) do engine end
  def execute(engine, count) do execute(engine |> execute, count-1) end

  @doc """
  Execute instructions until done
  """
  def execute_loop(engine) do execute_loop(instruction(engine), engine) end
  def execute_loop("@", engine) do engine end
  def execute_loop(_instruction, engine) do
    engine = execute(engine)
    execute_loop(instruction(engine), engine)
  end

  @doc """
  Outputs result
  """
  def output_result(engine) do engine.output end


end
