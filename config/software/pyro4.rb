name "pyro4"
default_version "4.35"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/irmen/Pyro4/master/LICENSE"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" Pyro4==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" Pyro4==#{version}"
  end
end
