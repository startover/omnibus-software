name "pycurl"
default_version "7.19.5.1"

if ohai['platform'] != "windows"
  dependency "python"
  dependency "pip"
  dependency "curl"
  dependency "gdbm" if (ohai['platform'] == "mac_os_x" or ohai['platform'] == "freebsd" or ohai['platform'] == "aix")
  dependency "libgcc" if (ohai['platform'] == "solaris2" and Omnibus.config.solaris_compiler == "gcc")

  build do
    ship_license "https://raw.githubusercontent.com/pycurl/pycurl/master/COPYING-MIT"
    build_env = {
      "PATH" => "/#{install_dir}/embedded/bin:#{ENV['PATH']}",
      "ARCHFLAGS" => "-arch x86_64"
    }
    command "#{install_dir}/embedded/bin/pip install -I #{name}==#{version}", :env => build_env
  end
else
  # FIXME: we could actually try to compile PyCurl even on Windows
  build do
    command "touch #{windows_safe_path(install_dir)}\\uselessfile"
  end
end
