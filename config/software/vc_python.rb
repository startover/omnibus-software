# Microsoft Visual C++ for Python

name 'vc_python'
default_version '2.7'

source :url => 'https://www.dropbox.com/s/1exq5v0voj0q2e4/VCForPython27.msi?dl=0',
       :md5 => '4e6342923a8153a94d44ff7307fcdd1f'

build do
    command "start /wait msiexec /x VCForPython27.msi /qn"
    command "start /wait msiexec /i VCForPython27.msi /qn"
    # TODO : ship that, pycrypto probably needs it !!!
    touch "#{install_dir}/uselessfile"
end

