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

name "nginx"
default_version "1.4.4"

if ohai['platform'] != 'windows'

  dependency "pcre"
  dependency "openssl"

  source :url => "http://nginx.org/download/nginx-#{version}.tar.gz",
         :md5 => "5dfaba1cbeae9087f3949860a02caa9f"

  relative_path "nginx-#{version}"

  build do
    command ["./configure",
             "--prefix=#{install_dir}/embedded",
             "--with-http_ssl_module",
             "--with-http_stub_status_module",
             "--with-ipv6",
             "--with-debug",
             "--with-ld-opt=-L#{install_dir}/embedded/lib",
             "--with-cc-opt=\"-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include\""].join(" ")
    command "make -j #{workers}", :env => {"LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
    command "make install"

    # ensure the logs directory is available on rebuild from git cache
    mkdir "#{install_dir}/embedded/logs"
    touch "#{install_dir}/embedded/logs/.gitkeep"
  end

else
  # We create a dummy file for the omnibus git_cache to work on Windows
  build do
    command "touch #{install_dir}/uselessfile"
  end
end
