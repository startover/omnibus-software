name "snakebite"
default_version "1.3.11"

dependency "python"
dependency "pip"
dependency "google-apputils"

build do
  ship_license "https://raw.githubusercontent.com/spotify/snakebite/master/LICENSE"
  if ohai['platform'] == 'windows'
    command "#{install_dir}/embedded/Scripts/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  else
    command "#{install_dir}/embedded/bin/pip install -I --install-option=\"--install-scripts=#{install_dir}/bin\" #{name}==#{version}"
  end
end
