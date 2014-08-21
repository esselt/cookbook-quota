#
# Cookbook Name:: quota
# Recipe:: enable
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

%w(quota quotatool).each do |pkg|
  package pkg
end

bash 'quota-enable' do
  cwd Chef::Config[:file_cache_path]
  
  code <<-EOF
FSTABNEW=$(mktemp fstab_new.XXXXXX)
FSTABBAK=$(mktemp fstab_bak.XXXXXX)
ERROR=0

cp /etc/fstab $FSTABBAK
awk '($1~"^U|\/") && ($3~"^ext[34]$") && ($4!~"usrjquota") { $4=$4",usrjquota=quota.user,jqfmt=vfsv0" }1' </etc/fstab >$FSTABNEW
cp $FSTABNEW /etc/fstab

quotaoff -a
for MNT in $(awk '($1~"^U|\/") && ($3~"^ext[34]$") && ($4~"usrjquota") { print $2 }' </etc/fstab)
do
  mount -o remount $MNT >/dev/null || {
    ERROR=$?
    break
  }
done

if [ $ERROR -ne 0 ]; then
  mv $FSTABBAK /etc/fstab
  for MNT in $(awk '($1~"^U|\/") && ($3~"^ext[34]$") && ($4!~"usrjquota")  { print $2 }' </etc/fstab)
  do
    mount -o remount $MNT >/dev/null
  done
else
  quotacheck -favugm 1>/dev/null 2>/dev/null
  quotaon -a
fi

rm -rf $FSTABBAK $FSTABNEW
EOF
  
  only_if 'awk \'($1~"^U|\/") && ($3~"^ext[34]$") && ($4!~"usrjquota") { print "true" }\' </etc/fstab | grep true'
end
