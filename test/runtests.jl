# Slugify.jl -- A library that simplifies a text to an ASCII subset
# By: Emmanuel Raviart <emmanuel@raviart.com>
#
# Copyright (C) 2015 Emmanuel Raviart
# https://github.com/eraviart/Slugify.jl
#
# This file is part of Slugify.jl.
#
# The Slugify.jl package is licensed under the MIT "Expat" License.


using Base.Test

importall Slugify


# write your own tests here
@test slugify("Hello world!") == "hello-world"
@test slugify("   Hello   world!   ") == "hello-world"
@test slugify("œil, forêt, ça, où...") == "oeil-foret-ca-ou"
@test slugify("   ") == ""
@test slugify("") == ""
@test slugify("   Hello   world!   ", separator = ' ', transform = uppercase) == "HELLO WORLD"
@test slugify("   ", separator = ' ') == ""
@test slugify("", separator = ' ') == ""
