#
# Cookbook Name:: quota
# Recipe:: clean
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

mounts = Mixlib::ShellOut.new('awk \'($1~"^U|\/") && ($3~"^ext[34]$") && ($4~"usrjquota") { print $2 }\' </etc/fstab').run_command.stdout.split("\n")
mounts.each do |mount|
  quotas = Mixlib::ShellOut.new("repquota #{mount} | grep ^#").run_command.stdout.split("\n")
  quotas.each do |quota|
    if match = quota.match(/^#(\d+)\s+--\s+\d+\s+(\d+)\s+(\d+)\s+\w*\s+(\d+)\s+(\d+)\s+\w*$/)
      user, bsoft, bhard, fsoft, fhard = match.captures
      if bsoft.to_i > 0 \
        or bhard.to_i > 0 \
        or fsoft.to_i > 0 \
        or fhard.to_i > 0
        execute "quota-clean-#{user}-#{mount.hash}" do
          command "setquota -u #{user} 0 0 0 0 #{mount}"
        end
      end
    end
  end
end
