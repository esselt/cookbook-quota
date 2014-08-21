#
# Cookbook Name:: quota
# Provider:: default
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

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

# This LWRP supports whyrun mode
def whyrun_supported?
  true
end

# Load the current resource
def load_current_resource
  # Get mount point for directory
  mount = shell_out("df -P #{@new_resource.directory} | tail -1 | awk '{print $6}'").stdout.strip
  
  # Get current resource
  quota = shell_out("repquota -c #{mount} | grep #{@new_resource.user}").stdout
  if !quota.nil? and match = quota.match(/^\w+\s+--\s+\d+\s+(\d+)\s+(\d+)\s+\w*\s+\d+\s+(\d+)\s+(\d+)\s+\w*$/)
    bsoft, bhard, fsoft, fhard = match.captures
  end
  
  # Load existing resource
  @current_resource = Chef::Resource::Quota.new(@new_resource.user)
  @current_resource.block_soft(bsoft.to_i) unless bsoft.nil?
  @current_resource.block_hard(bhard.to_i) unless bhard.nil?
  @current_resource.file_soft(fsoft.to_i) unless fsoft.nil?
  @current_resource.file_hard(fhard.to_i) unless fhard.nil?
  @current_resource.directory(@new_resource.directory)
  @current_resource.mount(mount)
  @current_resource
end

action :add do
  unless @new_resource.block_soft == @current_resource.block_soft \
    and @new_resource.block_hard == @current_resource.block_hard \
    and @new_resource.file_soft == @current_resource.file_soft \
    and @new_resource.file_hard == @current_resource.file_hard
    converge_by("set quota for #{@new_resource.user} on filesystem #{@current_resource.mount}") do
      shell_out!("setquota -u #{@new_resource.user} #{@new_resource.block_soft} #{@new_resource.block_hard} #{@new_resource.file_soft} #{@new_resource.file_hard} #{@current_resource.mount}")
      @new_resource.updated_by_last_action(true)
    end
  end
end

action :remove do
  unless @current_resource.block_soft == 0 \
    and @current_resource.block_hard == 0 \
    and @current_resource.file_soft == 0 \
    and @current_resource.file_hard == 0
    converge_by("remove quota for #{@new_resource.user} on filesystem #{@current_resource.mount}") do
      shell_out!("setquota -u #{@new_resource.user} 0 0 0 0 #{@current_resource.mount}")
      @new_resource.updated_by_last_action(true)
    end
  end
end