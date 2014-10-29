require 'sinatra'

get '/' do
  'Hello world!'
end

get '/*' do
  # halt 400, 'go away!'
  status 400
  headers "Allow" => "BREW, POST, GET, PROPFIND, WHEN",
          "Refresh" => "Refresh: 20; http://www.ietf.org/rfc/rfc2324.txt"
  body "I'm a tea pot!"
end

# $> ruby sinatra_router.rb


# ---------------------
# gem "minitest"
# require "minitest/autorun"

# module Declarative
#   def test(name, &block)
#     test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
#     defined = method_defined? test_name
#     raise "#{test_name} is already defined in #{self}" if defined
#     if block_given?
#       define_method(test_name, &block)
#     else
#       define_method(test_name) do
#         flunk "No implementation provided for #{name}"
#       end
#     end
#   end
# end

# class Meme
#   def i_can_has_cheezburger?
#     "OHAI!"
#   end

#   def will_it_blend?
#     "YES!"
#   end
# end

# class TestMeme < Minitest::Test
#   def setup
#     @meme = Meme.new
#   end

#   def test_that_kitty_can_eat
#     assert_equal "OHAI!", @meme.i_can_has_cheezburger?
#   end

#   def test_that_it_will_not_blend
#     refute_match /^no/i, @meme.will_it_blend?
#   end

#   # extend Declarative
#   # test "that kitty can eat" do
#   #   assert_equal "OHAI!", @meme.i_can_has_cheezburger?
#   # end
# end