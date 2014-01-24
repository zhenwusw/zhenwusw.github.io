---
layout: post
title: "use ripper to test ruby tokenization"
date: 2014-01-13 20:42
comments: false
categories: ['ruby internal']
---

The code Ruby actually runs looks nothing like your original code.


## How Ruby interpret execute your ruby code

{% img center /images/2014-01/code-journey-through-ruby.png 470 150 %}


## process one: tokenize

```ruby
require 'ripper'
require 'pp'

code =<<STR
10.times do |n|
puts n
end
STR

# 10.times do |n|
# puts n/4+6
# end

# 10.times do |n|
# array << n if n < 5
# end

puts code
pp Ripper.lex(code)
```

Run the code you'll get:


```
[[[1, 0], :on_int, "10"],
 [[1, 2], :on_period, "."],
 [[1, 3], :on_ident, "times"],
 [[1, 8], :on_sp, " "],
 [[1, 9], :on_kw, "do"],
 [[1, 11], :on_sp, " "],
 [[1, 12], :on_op, "|"],
 [[1, 13], :on_ident, "n"],
 [[1, 14], :on_op, "|"],
 [[1, 15], :on_ignored_nl, "\n"],
 [[2, 0], :on_ident, "puts"],
 [[2, 4], :on_sp, " "],
 [[2, 5], :on_ident, "n"],
 [[2, 6], :on_nl, "\n"],
 [[3, 0], :on_kw, "end"],
 [[3, 3], :on_nl, "\n"]]
```


which is a series of tokens converted from our ruby code

## process two: parsing

Tokens are grouped into sentences or phrases that make sense to Ruby.


{% img center /images/2014-01/ruby-bison-diagram.png 300 250 %}


* LALR parsing algorithm

Ruby optionally dispalys debug information, showing how the parser jumps from one state to another, by using  `ruby -y simple.rb`



AS Ruby parses your code, matching one grammar rule after another, it converts the tokenss in your code file into a comlex interal data structure called **an abstract syntax tree** 


The AST is used to record the structure and syntactical meaning of your Ruby code


{% img center /images/2014-01/ast.png 500 350 %}