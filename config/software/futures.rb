name "futures"
default_version "2.2.0"

dependency "python"
dependency "pip"

build do
  ship_license "https://pythonfutures.googlecode.com/hg/LICENSE"
  if ohai['platform'] == 'windows'
    command "#{windows_safe_path(install_dir)}\\embedded\\pip install -I --install-option=\"--install-scripts=#{windows_safe_path(install_dir)}\\bin\" #{name}==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
