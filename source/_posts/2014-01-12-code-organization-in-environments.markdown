---
layout: post
title: "[Dynamo] Code organization in environments"
date: 2014-01-12 11:07
comments: false
categories: ['elixir', 'dynamo']
---

First of all, Dynamo is a [mix][mix-link] project, which shipping with environments independence naturally.

{% codeblock mix.exs %}
  deps: Mix.env # dev, test, prod
{% endcodeblock %}


coming soon...
[mix-link]: http://elixir-lang.org/getting_started/mix/1.html
