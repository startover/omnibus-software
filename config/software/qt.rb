name "qt"

default_version "4.8"

if ohai['platform'] == 'mac_os_x'
  dependency "homebrew"

  build do
    command "brew install qt"
    command "brew linkapps qt"
  end
elsif ohai['platform'] == 'mac_os_x'
  # We create a dummy file for the omnibus git_cache to work on Windows
  build do
    command "touch #{install_dir}/uselessfile"
  end
end
