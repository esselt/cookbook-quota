#
# Cookbook Name:: quota
# Resource:: default
#
# Copyright 2013, HiST AITeL
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

actions :add, :remove
default_action :add

attribute :name,        :kind_of => String, :name_attribute => true
attribute :user,        :kind_of => String, :name_attribute => true
attribute :block_soft,  :kind_of => Fixnum, :default => 0
attribute :block_hard,  :kind_of => Fixnum, :default => 0
attribute :file_soft,   :kind_of => Fixnum, :default => 0
attribute :file_hard,   :kind_of => Fixnum, :default => 0
attribute :directory,   :kind_of => String, :regex => /^\/.*/, :default => '/home'
attribute :mount,       :kind_of => String