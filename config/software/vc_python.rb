# Microsoft Visual C++ for Python

name 'vc_python'
default_version '2.7'

source :url => 'http://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi'

build do
    command "start /wait msiexec /x VCForPython27.msi /qn"
    command "start /wait msiexec /i VCForPython27.msi /qn"
end

