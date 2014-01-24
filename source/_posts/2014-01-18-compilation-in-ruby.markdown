---
layout: post
title: "compilation in Ruby"
date: 2014-01-18 09:46
comments: false
categories: ["ruby internal"]
published: false
---

> You may think of Ruby as a dynamic scripting language, but, in
  fact, it uses a compiler just like C, Java, and myan other 
  programming laungages. Rubys' compiler works b iterating through
  the AST produced by the tokenizing and parsing processes,
  generating a series of bytescode instructions along the way.



> The code Ruby actually runs looks nothing like your original code

..

> Starting with version 1.9, Ruby compiles your code before executing it.

..

> It translates your Ruby code into another language that Ruby's VM understands
> The only difference is that you don't use Ruby's compiler directly

..

Now the process becomes: tokenizing -> parsing -> compiling


## The only differences between YARV and the JVM are the following

* Ruby doesn't expose the commpiler to you as a separate tool.

* Ruby never compiles your Ruby code all the way to machine language

