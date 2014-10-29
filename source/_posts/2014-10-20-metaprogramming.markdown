---
layout: post
title: "metaprogramming Ruby vs Elixir"
date: 2014-10-20 22:49
comments: false
categories: 
---

[Slides](/slides/metaprogramming#/)


# Metaprogramming

* Writing code that writes code

  * To remove boilerplate code
  * C++ STL
  * Java getter/setter
  * C -> C++ -> Java -> Ruby (runtime is more powerful)

* Dynamic metaprogramming vs Static metaprogramming

  * Dynamic: code that manipulate itself at runtime
  * Static:  static metaprogramming approaches

* Ruby runtime support vs Elixir/Clojure Macro systems


# Ruby

## Dynamic programming language

 * Ruby has it's own VM call YARV (tokenizing, parsing, compiling, executing)
 * Ruby doesn't do type checking
 * Code optimization are done when converting AST into YARV instructions

For some static languages: type checking, register allocation, code generation, and code optimization are typically done at compile time.

Instead of making a deal between you and compiler, defining class in Ruby is actually running code.

## Pure OO

 * Everything is object: even numbers and other primitive types
 * Instance variable + methods to all types of objects
 * Operators are just syntactic sugar for methods: e.g. `+`

## Flexible

  * Everything can be queried and altered at runtime (class objects, regular objects, variables, methods)
  * Single inheritance + Mixin
  * Closures: block, lambda, proc (heavily used in ruby's Enumerable module)


Adding / removing methods: it can deprecate many boilerplate code, such as getter and setter. In some other OO languages, Class acts like a contract/template, it allows to spawn many instances as it describes, but doesn't allow itself to be modified. So you need to specify every single method in this template definition, we call it boilerplate methods. Ruby totally avoid this via `define_methods`, `method_missing` ...


## Ruby object model

  {% img center /images/slides/ruby-object-model.png 500 500 %}

 * regular objects: instance variables, class pointer
 * class objects: class instance variables,instance methods, class pointer,  superclass pointer


  {% img center /images/slides/ruby-mixin.png 300 500 %}

  * class inheritance + mixin
  * D.ancestors => [C, M, Object, Kernel, BasicsObject]

 {% img center /images/slides/ruby-singleton-hierachy.png 500 500 %}

   singleton methods vs instance methods vs class methods
   singleton class vs metaclass

All metaclasses are singleton classes, but not all singleton classes are metaclasses. Ruby automatically creates a metaclass for every class you create and uses it to hold class methods that you might declare later.


## Powerful language support

 1. define_method + send
 2. method_missing, const_missing
 3. instance_variable_get/set
 4. instance_methods
 5. instance_eval, class_eval
 6. Hooks: inherited, included, extend_object, method_added, method_removed, method_undefined


## Examples

* HashSerializable
* Sinatra Router, minitest framework
* Elixir plug Router, Elixir ExUnit framework

{% include_code metaprogramming/hash_serializable.rb %}


# Elixir

* Compile-time metaprogramming (no performance penalty)

  Unlike Ruby, we don't have access to the process when Ruby AST
  converts to YARV instructions. In Elixir, we have full access to
  the compile process, which consists of AST expansion stage and
  bytecode generation stage. Use `mix` or `elixirc` to generate the
  final bytecode.

  {% img center /images/slides/elixir-compile-process.png 600 300 %}

* Elixir AST fragment: {operation, context, arguments}

  * `operation` is an atom or another tuple in the same representation
  * `context` is keyword list containing metadata, like numbers and contexts
  * `arguments` is either a list of arguments for the function call or an atom

* quote + unquote

  `quote` and `unquote` are two of the important tools Elixir macro system
  provides. `quote` is used to creating AST fragments, `unquote` is used to
  combine these AST fragments.

Evaluate a quoted expression by `Code.eval_quoted(quoted)`;
Macro evaluation is done by the compiler, before that, the quoted 
expression is not semantically verified.


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

We produced a new AST fragment that combine both expressions, **this is the core of meta-programming approach in Elixir**.

* Transformation tools: `quote` vs `Macro.to_string` vs `Macro.expand(exp, __ENV__)`

* Macro call is actually expanding AST fragments...

* Others
  * Hygiene
  * `__use__`, `__before_compile__`
  * `defmodule`, `def` are all macros
