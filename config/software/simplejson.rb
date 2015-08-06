name "simplejson"
default_version "3.6.5"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/simplejson/simplejson/master/LICENSE.txt"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
