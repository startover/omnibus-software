name "ntplib"
default_version "0.3.3"

dependency "python"
dependency "pip"

build do
  ship_license "MIT"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install --force-reinstall -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}", :cwd => "/tmp"
  else
    command "#{install_dir}/embedded/bin/pip install --force-reinstall -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}", :cwd => "/tmp"
  end
end
