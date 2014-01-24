---
layout: post
title: "displaying YARV instructions"
date: 2014-01-18 11:51
comments: false
categories: ['ruby internal']
---


One easy way to see how Ruby compiles your code is with the
`RubyVM::InstructionsSequence Object`

```ruby
code = <<END
puts 2+2
END
puts RubyVM::InstructionSequence.compile(code).disasm
```

outputs

```
== disasm: <RubyVM::InstructionSequence:<compiled>@<compiled>>==========
0000 trace            1                                               (   1)
0002 putself          
0003 putobject        2
0005 putobject        2
0007 opt_plus         <ic:2>
0009 send             :puts, 1, nil, 8, <ic:1>
0015 leave
```

As we can see, the line numbers on the left show the position
of each instruction the bytecode array that the compiler actually
prouces


```ruby
“code = <<END
10.times do |n|
  puts n
end
END
puts RubyVM::InstructionSequence.compile(code).disasm”
```

```
== disasm: <RubyVM::InstructionSequence:<compiled>@<compiled>>==========
== catch table
| catch type: break  st: 0002 ed: 0010 sp: 0000 cont: 0010
|------------------------------------------------------------------------
0000 trace            1                                               (   1)
0002 putobject        10
0004 send             :times, 0, block in <compiled>, 0, <ic:0>
0010 leave            
== disasm: <RubyVM::InstructionSequence:block in <compiled>@<compiled>>=
== catch table
| catch type: redo   st: 0000 ed: 0012 sp: 0000 cont: 0000
| catch type: next   st: 0000 ed: 0012 sp: 0000 cont: 0012
|------------------------------------------------------------------------
local table (size: 2, argc: 1 [opts: 0, rest: -1, post: 0, block: -1] s3)
[ 2] n<Arg>     
0000 trace            1                                               (   2)
0002 putself          
0003 getdynamic       n, 0
0006 send             :puts, 1, nil, 8, <ic:0>
0012 leave
```

As we can see, Ruby display the two YARV instruction snippets
seperately. The first corresponds to the global scope and the
second to the inner block scope.

Here we can see the `local table`, once Ruby's ompiler runs, the
information about the block parameter is copied out of the AST
and into another data structure called the `locale table`.





























