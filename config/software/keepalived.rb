#
# Copyright:: Copyright (c) 2012-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
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

name "keepalived"
default_version "1.2.9"

if ohai['platform'] != 'windows'

  dependency "popt"
  dependency "openssl"

  version "1.2.9" do
    source :md5 => "adfad98a2cc34230867d794ebc633492"
  end

  version "1.1.20" do
    source :md5 => "6c3065c94bb9e2187c4b5a80f6d8be31"
  end

  source :url => "http://www.keepalived.org/software/keepalived-#{version}.tar.gz"
  relative_path "keepalived-#{version}"

  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -static-libgcc",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
  }

  build do
    # This is cherry-picked from change
    # d384ce8b3492b9d76af23e621a20bed8da9c6016 of keepalived, (master
    # branch), and should be no longer necessary after 1.2.9.
    if version == "1.2.9"
      patch :source => "keepalived-1.2.9_opscode_centos_5.patch"
    end
    command "./configure --prefix=#{install_dir}/embedded --disable-iconv", :env => env
    command "make -j #{workers}", :env => env
    command "make install"
  end

else
  # We create a dummy file for the omnibus git_cache to work on Windows
  build do
    command "touch #{install_dir}/uselessfile"
  end
end
