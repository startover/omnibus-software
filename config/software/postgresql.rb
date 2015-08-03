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

name "postgresql"
default_version "9.2.8"

if ohai['platform'] != 'windows'

  dependency "zlib"
  dependency "openssl"
  dependency "libedit"
  dependency "ncurses"

  version "9.1.9" do
    source :md5 => "6b5ea53dde48fcd79acfc8c196b83535"
  end

  version "9.2.8" do
    source :md5 => "c5c65a9b45ee53ead0b659be21ca1b97"
  end

  version "9.3.4" do
    source :md5 => "d0a41f54c377b2d2fab4a003b0dac762"
  end

  source :url => "http://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2"
  relative_path "postgresql-#{version}"

  configure_env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
  }

  build do
    command ["./configure",
             "--prefix=#{install_dir}/embedded",
             "--with-libedit-preferred",
             "--with-openssl --with-includes=#{install_dir}/embedded/include",
             "--with-libraries=#{install_dir}/embedded/lib"].join(" "), :env => configure_env
    command "make -j #{workers}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
    command "make install"
  end

else
  # We create a dummy file for the omnibus git_cache to work on Windows
  build do
    command "touch #{install_dir}/uselessfile"
  end
end
