name "pymongo"
default_version "2.8"

dependency "python"
dependency "pip"

build do
  ship_license "Apachev2"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
