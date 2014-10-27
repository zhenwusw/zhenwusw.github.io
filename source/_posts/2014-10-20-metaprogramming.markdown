---
layout: post
title: "metaprogramming Ruby vs Elixir"
date: 2014-10-20 22:49
comments: false
categories: 
---

{% reveal /slides/metaprogramming-draft 640 640 %}


# Metaprogramming

* Writing code that writes code
* Dynamic metaprogramming vs Static metaprogramming


> Code that manipulate itself at runtime: so called 'dynamic' metaprogramming

.

> powerful introspection

# Ruby

## [Dynamic programming language](http://en.wikipedia.org/wiki/Dynamic_programming_language)

 * Ruby has it's own VM call YARM: tokenizing, parsing, compiling, executing
 * Ruby doesn't do type checking
 ** code optimization are done at compilation time?

>  Type checking, register allocation, code generation, and code optimization are typically done at compile time


## Pure OO

  * numbers and other primitive types are not objects in some other languages
  * **Everything is object**: that's an important rule
  * instance variable + methods to all types of objects
  * operators are syntactic sugar for methods: e.g. `+`
  

## Flexible

  * Allow users to freely alter its parts at runtime
  * Functional support via Closures: block, lambda, proc which can be attached to any method, heavily used in ruby's Enumerable module
  * Single inheritance + Mixin


On top of that, Ruby provides many ways to inspect and change itself dynamically, to query information about itself -- methods, instance
variables, superclasses, to defining a method or a constant.


Not making a deal between you and compiler, defining class in Ruby is actually running code


Adding / removing methods: it can deprecate many boilerplate code, such as getter and setter. In some other OO languages, Class acts like a contract/template, it allows to spawn many instances as it describes, but doesn't allow itself to be modified. So you need to specify every single method in this template definition, we call it boilerplate methods.Ruby totally avoid this via `define_methods`, `method_missing` ...


## Ruby object model: rules

 {% img center /images/2014-10/1.png 500 500 %}

regular objects have instance variables, class pointer
class objects have class instance variables, class pointer, superclass pointer

{% img center /images/2014-10/2.png 300 500 %}

   class inheritance + mixin
   `MyClass.ancestors => ...`
   Kernel is a module, which was included in Object class

 {% img center /images/2014-10/3.png 500 500 %}

   singleton methods vs instance methods vs class methods
   singleton class vs metaclass

> All metaclasses are singleton classes, but not all singleton classes are metaclasses. Ruby automatically creates a metaclass for every class you create and uses it to hold class methods that you might declare later.


 * `include` vs `extend` vs `ActiveSupport::Concern`

 * Method lookup ...


## Useful skills

 1. define_method + send
 2. method_missing + const_missing
 3. instance_variable_get/set
 4. instance_methods
 5. instance_eval + class_eval
 6. Hooks: inherited, included, extend_object, method_added, method_removed, method_undefined


## How these useful

* HashSerializable

{% include_code hash_serializable.rb %}

* minitest framework


# Elixir


Ruby Router vs Elixir Router
Ruby test framework vs Elixir test framework


Runtime metaprogramming

Compile-time metaprogramming

* no performance penalty


## AST fragment is a triplet which consists of

  * operation
  * context
  * arguments


quoted expression is an Elixir term

compiler use quoted expression to generate final bytecode

evaluate a quoted expression by `Code.eval_quoted(quoted)`

Macro evaluation is done by the compiler, before that, the quoted 
expression is not semantically verified.

So we can inject that AST fragment to where `a` and `b` are valid
identifier.

```elixir
sum_expr = quote do: a + b
bind_expr = quote do
    a = 1
    b = 2
  end
final_expr = quote do
  unquote(bind_expr)
  unquote(sum_expr)
end
```

We produced a new AST fragment that conbines both expressions.

__this is the core of meta-programming approach in Elixir__

> quote: code generation factory

> unquote: code generation tool

`quote` vs `unquote`
`quote` vs `Macro.to_string`

transformation(function invocation) happens in the expansion time

__Macro receives quoted expression__

In runtime, we don't have an access to AST anymore

`quoted = quote do Tracer.trace(1+2) end`

vs

`expanded = Macro.expand(quoted, __ENV__)`


Macro call is actually expanded AST fragments...

> the same things happen when 
> we're building our projects with mix or elixirc.


## Elixir AST: raw AST, final AST

## quote/unquote constructor

## Compile phase

## Macro mechanics

 * Expansion phase
 * this is where compiler calls various macros
 * receives input AST, produce output AST
 * macro is replaced by the output AST
 * re-expanded ... until there's nothing left to expand

> How can Elixir code run before it is produced? 

 It can't. To call a macro, the container module must already be
 compiled, that's why `require` or `import` is needed.

 > When we require a module, we instruct the Elixir to hold the compilation of the current module until the required module is compiled and loaded into the compiler run-time (the Erlang VM instance where compiler is running)

* Hygiene

> This is an example of a macro introducing a variable that must not be hygienic. The variable conn is introduced by the get macro, but must be visible to the code where the macro is called.

* macro invocation
```elixir
get "/resource" do
  send_resp(conn, 200, ...)
end

get "/resource", [do: ...] # do keyword
```

Ruby's closure: `block.call`
Elixir's macro do-keyword inject

## function generation

```elixir
def my_fun do
end

def(my_fun, do: (...))
```

> def macro will receive the quoted representation which will, among other things, contain :my_fun.

> Whenever you pass a do...end block to a macro, it is the same as passing a keywords list with a :do key.

> for many constants (atoms, numbers, strings), the quoted representation is exactly the same as the input value.

> two element tuples and lists will retain their structure when quoted.

```elixir
iex(7)> quote do [a: 1, b: 2] end
[a: 1, b: 2]
```


__It receives some AST fragments, and combines them together with the boilerplate code, to generate the final result.__


 generic code is implemented as macro function
 specific code `use` macro function

* `use`: Elixir mixin, `__using__`

```elixir
defmodule MyRouter do
  use Plug.Router

  get "/hello", do: {conn, "Hi!"}    # macro invocation
  get "/goodbye", do: {conn, "Bye!"} # macro invocation
end
```

```elixir
defmodule MyRouter do
  def match(...) do
  end

  def do_match(...) do
  end

  def get(...) do
  end

  def post(...) do
  end
end
```


* input AST is analyzed and parse in advance
* Parse input AST fragments to get some specific informations

__Ruby reopen class, define method dynamically, closure__
__Elixir reassembles AST__

via pattern matching

prefer runtime abstraction

`assert expected == required`

`defmacro assert({:==, _, [lhs, rhs]} = expr)`

> binary operators are quoted as two arguments function calls.


























