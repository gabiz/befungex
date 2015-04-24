defmodule BX.EngineTest do
  use ExUnit.Case
  alias BX.Engine
  alias BX.Cursor
  alias BX.Space

  def createEngine(code \\ "0123@") do
    space = Space.new(code)
    Engine.new(
          space, 
          Cursor.new(Space.size(space)), 
          [])
  end

  test "Creates new command" do
    assert Map.keys(createEngine) == [:cursor, :output, :pushMode, :space, :stack]
  end

  test "Gets position from cursor" do
    assert Cursor.position(BX.Cursor.new |> Cursor.advance) == %{x: 1, y: 0}
  end

  test "Gets next instruction" do
    engine = createEngine
    assert Engine.instruction(engine) == "0"
  end

  test "Performs operation" do
    assert Engine.perform_operation("+", [2, 1]) == [3]
    assert Engine.perform_operation("-", [2, 1]) == [-1]
    assert Engine.perform_operation("*", [2, 1]) == [2]
    assert Engine.perform_operation("/", [2, 1]) == [0]
    assert Engine.perform_operation("%", [2, 1]) == [1]
    assert Engine.perform_operation("!", [2, 1]) == [0, 1]
    assert Engine.perform_operation("`", [2, 1]) == [0]
    assert Engine.perform_operation(":", [2, 1]) == [2, 2, 1]
    assert Engine.perform_operation("\\", [2, 1]) == [1, 2]
    assert Engine.perform_operation("$", [2, 1]) == [1]
  end

  test "New direction" do
    assert Engine.new_direction("_", 2) == "<"    
    assert Engine.new_direction("_", 0) == ">"    
    assert Engine.new_direction("|", 2) == "^"    
    assert Engine.new_direction("|", 0) == "v"    
  end

  test "executes code" do
    engine = createEngine("0.@") |> Engine.execute
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert stack == [0]
    assert output == ""
    assert Cursor.position(cursor) == %{x: 1, y: 0}
    engine = engine |> Engine.execute
    %{cursor: cursor, stack: stack, output: output} = engine
    assert stack == []
    assert output == "0"
    assert Cursor.position(cursor) == %{x: 2, y: 0}
  end

  test "Performs + operation" do
    engine = createEngine("12+@") |> Engine.execute 3
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 3, y: 0}
    assert stack == [3]
    assert output == ""
  end

  test "Performs \\ operation" do
    engine = createEngine("12\\@") |> Engine.execute 3
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 3, y: 0}
    assert stack == [1, 2]
    assert output == ""
  end

  test "Performs > operation" do
    engine = createEngine(">12\\@") |> Engine.execute 4
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 4, y: 0}
    assert stack == [1, 2]
    assert output == ""
  end

  test "executes _ operation" do
    engine = createEngine("1_2") |> Engine.execute 3
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 2, y: 0}
    assert stack == [1]
    assert output == ""

    engine = createEngine("0_1") |> Engine.execute 3
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 0, y: 0}
    assert stack == [1]
    assert output == ""
  end

  test "Runs Hello World" do
    code = "\"!dlrow olleH\">:#,_@"
    engine = createEngine(code) |> Engine.execute_loop
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 19, y: 0}
    assert stack == [0, 0]
    assert output == "Hello world!"
  end


  test "Runs Hello World2" do
    code = """
>              v
v  ,,,,,"Hello"<
>48*,          v
v,,,,,,"World!"<
>25*,@
"""
    engine = createEngine(code) |> Engine.execute_loop
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 5, y: 4}
    assert stack == []
    assert output == "Hello World!\n"
  end

  test "runs replicator" do
    code = ":0g,:93+`#@_1+"
    engine = createEngine(code) |> Engine.execute_loop
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 10, y: 0}
    assert stack == [13, 0]
    assert output == ":0g,:93+`#@_1+"
  end

  test "generates an output space" do
    code = """
>              v
v  ,,,,,"Hello"<
>48*,          v
v,,,,,,"World!"<
>25*,@
"""
    engine = createEngine(code) |> Engine.execute
    %{cursor: cursor, stack: stack, output: output} = engine 
    assert Cursor.position(cursor) == %{x: 1, y: 0}
    assert Engine.output_space(engine) == """
><span style=\"background:red\"> </span>             v
v  ,,,,,"Hello"<
>48*,          v
v,,,,,,"World!"<
>25*,@
"""
# ><div style style=\"background:red\"> </div>              v


  end

end
