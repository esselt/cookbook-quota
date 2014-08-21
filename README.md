Description
============

Enables quotasupport for all EXT3/4 filesystems and
provide a LWRP for enabling quota on a filesystem.
Can also clean filesystems for orphaned quotas.

Requirements
============

Chef version 11.0+

## Platform

Supported platforms by platform family:

* debian

Usage
=====

## quota::default

Runs recipe enable, then clean

## quota::enable

Installs quota and quotatool, enables quotasupport on
all EXT3/4 filesystems

## quota::clean

Checks and removes quota for non existing users on all
file systems

## LWRP: quota

Enables quota for a user on one filesystem

Example use

    quota 'username' do
      user 'username'            # Username to enable quota for, optional can be name
      block_soft 1024            # Soft quota in Kb, optional, must be integer
      block_hard 2048            # Hard quota in Kb, optional, must be integer
      file_soft 10               # Soft quota in number of files, optional, must be integer
      file_hard 20               # Hard quota in number of files, optional, must be integer
      directory '/home/username' # Path to quota, will find filesystem that contains this directory
      action :add / :remove      # Add or remove quota
    end

License and Authors
===================
Author:: Boye Holden (<boye.holden@hist.no>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
