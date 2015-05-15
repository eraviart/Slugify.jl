# Slugify -- A library that simplifies a text to an ASCII subset
# By: Emmanuel Raviart <emmanuel@raviart.com>
#
# Copyright (C) 2015 Emmanuel Raviart
# https://github.com/eraviart/Slugify.jl
#
# This file is part of Slugify.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


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
