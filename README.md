FileRemover
===========

Simple recursive file remover I use for removing annoying files such as the `.DS_Store` files in OS X.

The default behavior is to remove `.DS_Store` files, from the current folder and all its sub-folders, but you can use it with any regular expression.

Written in Elixir.

(I also used this to play with ANSI formatting...)


### How to use

1. Get [Elixir](http://elixir-lang.org/)!
2. Clone this project
3. `iex -S mix`
4. `FileRemover.run("/cool_folder", ~r/\.DS_Store/)`
5. Wait and enjoy the show!