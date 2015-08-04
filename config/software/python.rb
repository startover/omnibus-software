#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
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

name "python"

if ohai['platform'] != 'windows'
  default_version "2.7.10"

  dependency "ncurses"
  dependency "zlib"
  dependency "openssl"
  dependency "bzip2"
  dependency "libsqlite3"

  source :url => "http://python.org/ftp/python/#{version}/Python-#{version}.tgz",
         :md5 => 'd7547558fd673bd9d38e2108c6b42521'

  relative_path "Python-#{version}"

  env = {
    "CFLAGS" => "-I#{install_dir}/embedded/include -O3 -g -pipe",
    "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
  }

  python_configure = ["./configure",
                      "--enable-universalsdk=/",
                      "--prefix=#{install_dir}/embedded"]

  if ohai['platform_family'] == 'mac_os_x'
    python_configure.push('--enable-ipv6',
                          '--with-universal-archs=intel',
                          '--enable-shared')
  end

  python_configure.push("--with-dbmliborder=")

  build do
    ship_license "PSFL"
    command python_configure.join(" "), :env => env
    patch :source => "disable_sslv3.patch" if ohai['platform_family'] == 'mac_os_x'
    command "make -j #{workers}", :env => env
    command "make install", :env => env
    delete "#{install_dir}/embedded/lib/python2.7/test"

    # There exists no configure flag to tell Python to not compile readline support :(
    block do
      FileUtils.rm_f(Dir.glob("#{install_dir}/embedded/lib/python2.7/lib-dynload/readline.*"))
    end
  end

else
  default_version "2.7.9"
  # We're gonna get a standard binary (TODO react according to the architecture)
  source :url => "https://www.python.org/ftp/python/#{version}/python-#{version}.amd64.msi"
  build do
    # In case Python is already installed on the build machine well... let's uninstall it
    # (fortunately we're building in a VM :) )
    command "start /wait msiexec /x python-#{version}.amd64.msi /qn"

    # Installs Python with all the components we need (pip..) under C:\python-omnibus
    command "start /wait msiexec /i python-#{version}.amd64.msi TARGETDIR=\"C:\\python-omnibus\" /qn"

    # Let's ship the Python binaries TODO :  compute the "27" part
    copy "C:\\python-omnibus\\python.exe", "#{install_dir}\\embedded\\bin\\python.exe"
    copy "C:\\python-omnibus\\pythonw.exe", "#{install_dir}\\embedded\\bin\\pythonw.exe"
    sync "C:\\python-omnibus\\DLLs", "#{install_dir}\\embedded\\dlls"

    # And the libs
    sync "C:\\python-omnibus\\Lib", "#{install_dir}\\embedded\\lib"
    sync "C:\\python-omnibus\\libs", "#{install_dir}\\embedded\\libs"
  end
end
