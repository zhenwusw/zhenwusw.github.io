---
layout: post
title: "how ruby excute your code"
date: 2014-01-19 11:09
comments: false
categories: ['ruby internal']
published: false
---


> “YARV is not just a stack machine—it’s a double-stack machine!”


YARV has its own stack pointer and a program counter -- that is
like your computer's actual microprocessor.

> The CFP pointer indicates the current frame pointer. Each stack frame in your Ruby program stack contains, in turn, a different value for the self, PC, and SP registers,

YARV instruction of `puts 2+2`

```
trace
putself
putobject     2
putobject     2
opt_plus
opt_send_simple      <<callinfo!mid:puts....
leave
```

Ruby uses the `trace` to support the `set_trace_func` feature.















