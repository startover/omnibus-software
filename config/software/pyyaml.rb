name "pyyaml"
default_version "3.11"

dependency "python"
dependency "pip"

if ohai['platform'] == 'windows'
  dependency "libyaml-windows"
else
  dependency "libyaml"
end

build do
  ship_license "http://pyyaml.org/export/385/pyyaml/trunk/LICENSE"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
