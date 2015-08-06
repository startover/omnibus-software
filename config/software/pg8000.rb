name "pg8000"
default_version "1.10.1"

dependency "python"
dependency "pip"

build do
  ship_license "https://raw.githubusercontent.com/mfenniak/pg8000/master/LICENSE"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
