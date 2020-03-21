# ベースイメージはUbuntu18.04
# BaseImage is Ubuntu18.04
FROM ubuntu:18.04

# いくつかのソフトウェアパッケージと一時的なフォルダを作成
# Install some software package and make temporary directory
RUN apt update && \
    apt install -y --no-install-recommends wget unzip bzip2 vim && \
    mkdir /tmp/AiwolfTmp

# Java8(OpenJDK)のインストール
# Install Java8 (OpenJDK)
RUN apt install -y openjdk-8-jdk

# 人狼知能サーバをダウンロード
# Download aiwolf-server(ver0.5.6)
RUN wget http://aiwolf.org/control-panel/wp-content/uploads/2014/03/aiwolf-ver0.5.6.zip -O /tmp/AiwolfTmp/aiwolf-platform.zip && \
    mkdir /home/aiwolf-platform && \
    unzip -j /tmp/AiwolfTmp/aiwolf-platform.zip -d /home/aiwolf-platform

# .NET Core SDK2.2 のインストール
# Install .NET Core SDK 2.2
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/AiwolfTmp/packages-microsoft-prod.deb && \
    dpkg -i /tmp/AiwolfTmp/packages-microsoft-prod.deb && \
    apt install -y apt-transport-https && \
    apt update && \
    apt install -y dotnet-sdk-2.2

# C#エージェント用のクライアントスターターのダウンロード
# Download C# Agent ClientStarter(ver2.0.1)
RUN wget https://github.com/AIWolfSharp/AIWolf_NET/releases/download/v2.0.1/ClientStarter-2.0.1-linux-x64.tgz -O /tmp/AiwolfTmp/aiwolf-client-starter.tgz && \
    mkdir /home/aiwolf-client-starter && \
    tar xzvf /tmp/AiwolfTmp/aiwolf-client-starter.tgz -C /home/aiwolf-client-starter --strip=1 

# Miniconda3のインストール
# Install Miniconda3(ver4.7.12.1)
ENV PATH=/root/miniconda3/bin:$PATH
RUN wget --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-4.7.12.1-Linux-x86_64.sh -O /tmp/AiwolfTmp/miniconda.sh && \
    bash /tmp/AiwolfTmp/miniconda.sh -b

# Minicondaの準備
# Setup miniconda
RUN conda update conda -y && \
    conda init bash

# 公式の環境を再現するためのyamlファイルを作成
# Create yaml file to reproduction official environment
RUN { \
        echo 'name: aiwolf'; \
        echo 'channels:'; \
        echo '  - conda-forge'; \
        echo '  - defaults'; \
        echo 'dependencies:'; \
        echo '  - _libgcc_mutex=0.1=main'; \
        echo '  - _tflow_select=2.3.0=mkl'; \
        echo '  - absl-py=0.7.1=py36_0'; \
        echo '  - alabaster=0.7.10=py36h306e16b_0'; \
        echo '  - anaconda-client=1.6.14=py36_0'; \
        echo '  - anaconda-navigator=1.8.7=py36_0'; \
        echo '  - anaconda-project=0.8.2=py36_0'; \
        echo '  - asn1crypto=0.24.0=py_1'; \
        echo '  - astor=0.8.0=py36_0'; \
        echo '  - astroid=1.6.3=py36_0'; \
        echo '  - astropy=3.0.2=py36h3010b51_1'; \
        echo '  - attrs=18.1.0=py_1'; \
        echo '  - babel=2.5.3=py36_0'; \
        echo '  - backcall=0.1.0=py36_0'; \
        echo '  - backports=1.0=py_2'; \
        echo '  - backports.shutil_get_terminal_size=1.0.0=py36_2'; \
        echo '  - beautifulsoup4=4.6.0=py36_1'; \
        echo '  - bitarray=0.8.1=py36h14c3975_1'; \
        echo '  - bkcharts=0.2=py36_0'; \
        echo '  - blas=1.0=mkl'; \
        echo '  - blaze=0.11.3=py36_0'; \
        echo '  - bleach=2.1.3=py36_0'; \
        echo '  - blosc=1.16.3=hd408876_0'; \
        echo '  - bokeh=0.12.16=py36_0'; \
        echo '  - boto=2.48.0=py36_1'; \
        echo '  - bottleneck=1.2.1=py36h035aef0_1'; \
        echo '  - bzip2=1.0.8=h7b6447c_0'; \
        echo '  - c-ares=1.15.0=h7b6447c_1001'; \
        echo '  - ca-certificates=2020.1.1=0'; \
        echo '  - certifi=2018.4.16=py36_0'; \
        echo '  - cffi=1.11.5=py36h9745a5d_1001'; \
        echo '  - chainer=6.3.0=py_0'; \
        echo '  - chardet=3.0.4=py36_1003'; \
        echo '  - click=6.7=py_1'; \
        echo '  - cloudpickle=0.5.3=py36_0'; \
        echo '  - clyent=1.2.2=py36_1'; \
        echo '  - colorama=0.3.9=py36_0'; \
        echo '  - conda=4.5.4=py36_0'; \
        echo '  - conda-build=3.10.5=py36_0'; \
        echo '  - conda-env=2.6.0=1'; \
        echo '  - conda-verify=2.0.0=py36h98955d8_0'; \
        echo '  - contextlib2=0.5.5=py36_0'; \
        echo '  - cryptography=2.2.2=py36h14c3975_0'; \
        echo '  - curl=7.61.0=h84994c4_0'; \
        echo '  - cycler=0.10.0=py36_0'; \
        echo '  - cython=0.28.2=py36h14c3975_0'; \
        echo '  - cytoolz=0.9.0.1=py36h14c3975_1'; \
        echo '  - dask=0.17.5=py36_0'; \
        echo '  - dask-core=0.17.5=py36_0'; \
        echo '  - datashape=0.5.4=py36_1'; \
        echo '  - dbus=1.13.12=h746ee38_0'; \
        echo '  - decorator=4.3.0=py36_0'; \
        echo '  - distributed=1.21.8=py36_0'; \
        echo '  - docutils=0.14=py36_1001'; \
        echo '  - entrypoints=0.2.3=py36_2'; \
        echo '  - et_xmlfile=1.0.1=py36_0'; \
        echo '  - expat=2.2.6=he6710b0_0'; \
        echo '  - fastcache=1.0.2=py36h14c3975_2'; \
        echo '  - filelock=3.0.4=py36_0'; \
        echo '  - flask=1.0.2=py36_0'; \
        echo '  - flask-cors=3.0.4=py36_0'; \
        echo '  - fontconfig=2.13.0=h9420a91_0'; \
        echo '  - freetype=2.9.1=h8a8886c_1'; \
        echo '  - gast=0.2.2=py36_0'; \
        echo '  - gevent=1.3.0=py36h14c3975_0'; \
        echo '  - glib=2.63.1=h5a9c865_0'; \
        echo '  - glob2=0.6=py36_1'; \
        echo '  - gmp=6.1.2=h6c8ec71_1'; \
        echo '  - gmpy2=2.0.8=py36h10f8cd9_2'; \
        echo '  - greenlet=0.4.13=py36h14c3975_0'; \
        echo '  - gst-plugins-base=1.14.0=hbbd80ab_1'; \
        echo '  - gstreamer=1.14.0=hb453b48_1'; \
        echo '  - h5py=2.7.1=py36ha1f6525_2'; \
        echo '  - hdf5=1.10.2=hba1933b_1'; \
        echo '  - heapdict=1.0.0=py36_2'; \
        echo '  - html5lib=1.0.1=py36_0'; \
        echo '  - icu=58.2=h9c2bf20_1'; \
        echo '  - idna=2.6=py36h82fb2a8_1'; \
        echo '  - imageio=2.3.0=py36_0'; \
        echo '  - imagesize=1.0.0=py36_0'; \
        echo '  - intel-openmp=2019.4=243'; \
        echo '  - ipykernel=4.8.2=py36_0'; \
        echo '  - ipython=6.4.0=py36_1'; \
        echo '  - ipython_genutils=0.2.0=py36_0'; \
        echo '  - ipywidgets=7.2.1=py36_0'; \
        echo '  - isort=4.3.4=py36_0'; \
        echo '  - itsdangerous=0.24=py36_1'; \
        echo '  - jdcal=1.4=py36_0'; \
        echo '  - jedi=0.12.0=py36_1'; \
        echo '  - jinja2=2.10=py36_0'; \
        echo '  - jpeg=9b=h024ee3a_2'; \
        echo '  - jsonschema=2.6.0=py36_0'; \
        echo '  - jupyter=1.0.0=py36_7'; \
        echo '  - jupyter_client=5.2.3=py36_0'; \
        echo '  - jupyter_console=5.2.0=py36_1'; \
        echo '  - jupyter_core=4.4.0=py36_0'; \
        echo '  - jupyterlab=0.32.1=py36_0'; \
        echo '  - jupyterlab_launcher=0.10.5=py36_0'; \
        echo '  - keras=2.2.4=0'; \
        echo '  - keras-applications=1.0.7=py_0'; \
        echo '  - keras-base=2.2.4=py36_0'; \
        echo '  - keras-preprocessing=1.0.9=py_1'; \
        echo '  - kiwisolver=1.0.1=py36hf484d3e_0'; \
        echo '  - lazy-object-proxy=1.3.1=py36h14c3975_2'; \
        echo '  - libcurl=7.61.0=h1ad7b7a_0'; \
        echo '  - libedit=3.1.20181209=hc058e9b_0'; \
        echo '  - libffi=3.2.1=hd88cf55_4'; \
        echo '  - libgcc-ng=9.1.0=hdf63c60_0'; \
        echo '  - libgfortran-ng=7.3.0=hdf63c60_0'; \
        echo '  - libpng=1.6.37=hbc83047_0'; \
        echo '  - libprotobuf=3.7.1=hd408876_0'; \
        echo '  - libsodium=1.0.16=h1bed415_0'; \
        echo '  - libssh2=1.8.0=h9cfc8f7_4'; \
        echo '  - libstdcxx-ng=9.1.0=hdf63c60_0'; \
        echo '  - libtiff=4.1.0=h2733197_0'; \
        echo '  - libuuid=1.0.3=h1bed415_2'; \
        echo '  - libxcb=1.13=h1bed415_1'; \
        echo '  - libxml2=2.9.9=hea5a465_1'; \
        echo '  - libxslt=1.1.33=h7d1a2b0_0'; \
        echo '  - llvmlite=0.23.1=py36hdbcaa40_0'; \
        echo '  - locket=0.2.0=py36_1'; \
        echo '  - lxml=4.2.1=py36h23eabaa_0'; \
        echo '  - lz4-c=1.8.1.2=h14c3975_0'; \
        echo '  - lzo=2.10=h49e0be7_2'; \
        echo '  - markdown=3.1.1=py36_0'; \
        echo '  - markupsafe=1.0=py36h14c3975_1'; \
        echo '  - matplotlib=2.2.2=py36hb69df0a_2'; \
        echo '  - mccabe=0.6.1=py36_1'; \
        echo '  - mistune=0.8.3=py_0'; \
        echo '  - mkl=2018.0.3=1'; \
        echo '  - mkl_fft=1.0.1=py36h3010b51_0'; \
        echo '  - mkl_random=1.0.1=py36h629b387_0'; \
        echo '  - mock=3.0.5=py36_0'; \
        echo '  - more-itertools=4.1.0=py36_0'; \
        echo '  - mpc=1.1.0=h10f8cd9_1'; \
        echo '  - mpfr=4.0.1=hdf1c602_3'; \
        echo '  - mpmath=1.0.0=py36_2'; \
        echo '  - msgpack-python=0.6.1=py36hfd86e86_1'; \
        echo '  - multipledispatch=0.5.0=py36_0'; \
        echo '  - navigator-updater=0.2.1=py36_0'; \
        echo '  - nbconvert=5.3.1=py36_0'; \
        echo '  - nbformat=4.4.0=py36_0'; \
        echo '  - ncurses=6.2=he6710b0_0'; \
        echo '  - networkx=2.1=py36_0'; \
        echo '  - nltk=3.3.0=py36_0'; \
        echo '  - nose=1.3.7=py36_2'; \
        echo '  - notebook=5.5.0=py36_0'; \
        echo '  - numba=0.38.0=py36h637b7d7_0'; \
        echo '  - numexpr=2.6.5=py36_0'; \
        echo '  - numpy=1.14.3=py36hcd700cb_1'; \
        echo '  - numpy-base=1.14.3=py36h9be14a7_1'; \
        echo '  - numpydoc=0.8.0=py36_0'; \
        echo '  - odo=0.5.1=py36_0'; \
        echo '  - olefile=0.45.1=py36_0'; \
        echo '  - openpyxl=2.5.3=py36_0'; \
        echo '  - openssl=1.0.2u=h7b6447c_0'; \
        echo '  - packaging=17.1=py36_0'; \
        echo '  - pandas=0.23.0=py36h637b7d7_0'; \
        echo '  - pandoc=2.2.3.2=0'; \
        echo '  - pandocfilters=1.4.2=py36_1'; \
        echo '  - parso=0.2.0=py36_0'; \
        echo '  - partd=0.3.8=py36_0'; \
        echo '  - patchelf=0.10=he6710b0_0'; \
        echo '  - path.py=11.0.1=py36_0'; \
        echo '  - pathlib2=2.3.2=py36_0'; \
        echo '  - patsy=0.5.0=py36_0'; \
        echo '  - pbr=5.2.0=py_0'; \
        echo '  - pcre=8.43=he6710b0_0'; \
        echo '  - pep8=1.7.1=py36_0'; \
        echo '  - pexpect=4.5.0=py36_0'; \
        echo '  - pickleshare=0.7.4=py36_0'; \
        echo '  - pillow=5.1.0=py36heded4f4_0'; \
        echo '  - pip=20.0.2=py36_1'; \
        echo '  - pkginfo=1.4.2=py36_0'; \
        echo '  - pluggy=0.6.0=py36_0'; \
        echo '  - ply=3.11=py36_0'; \
        echo '  - prompt_toolkit=1.0.15=py36_0'; \
        echo '  - protobuf=3.7.1=py36he6710b0_0'; \
        echo '  - psutil=5.4.5=py36h14c3975_0'; \
        echo '  - ptyprocess=0.5.2=py36h69acd42_0'; \
        echo '  - py=1.5.3=py36_0'; \
        echo '  - pycodestyle=2.4.0=py36_0'; \
        echo '  - pycosat=0.6.3=py36h7b6447c_0'; \
        echo '  - pycparser=2.18=py36_1'; \
        echo '  - pycrypto=2.6.1=py36h14c3975_9'; \
        echo '  - pycurl=7.43.0.1=py36hb7f436b_0'; \
        echo '  - pyflakes=1.6.0=py_1'; \
        echo '  - pygments=2.2.0=py36_0'; \
        echo '  - pylint=1.8.4=py36_0'; \
        echo '  - pyodbc=4.0.23=py36hf484d3e_0'; \
        echo '  - pyopenssl=18.0.0=py36_0'; \
        echo '  - pyparsing=2.2.0=py36_0'; \
        echo '  - pyqt=5.9.2=py36h05f1152_2'; \
        echo '  - pysocks=1.6.8=py36_0'; \
        echo '  - pytables=3.4.3=py36h02b9ad4_2'; \
        echo '  - pytest=3.5.1=py36_0'; \
        echo '  - pytest-arraydiff=0.2=py36h39e3cac_0'; \
        echo '  - pytest-astropy=0.3.0=py36_0'; \
        echo '  - pytest-doctestplus=0.1.3=py36_0'; \
        echo '  - pytest-openfiles=0.3.0=py36_0'; \
        echo '  - pytest-remotedata=0.2.1=py36_0'; \
        echo '  - python=3.6.5=hc3d631a_2'; \
        echo '  - python-dateutil=2.7.3=py36_0'; \
        echo '  - pytz=2018.4=py36_0'; \
        echo '  - pywavelets=0.5.2=py36h035aef0_2'; \
        echo '  - pyyaml=3.12=py36_1'; \
        echo '  - pyzmq=17.0.0=py36h14c3975_3'; \
        echo '  - qt=5.9.6=h8703b6f_2'; \
        echo '  - qtawesome=0.4.4=py36_0'; \
        echo '  - qtconsole=4.3.1=py36_0'; \
        echo '  - qtpy=1.4.1=py36_0'; \
        echo '  - readline=7.0=h7b6447c_5'; \
        echo '  - requests=2.18.4=py36he2e5f8d_1'; \
        echo '  - rope=0.10.7=py36_0'; \
        echo '  - ruamel_yaml=0.15.35=py36h14c3975_1'; \
        echo '  - scikit-image=0.13.1=py36h14c3975_1'; \
        echo '  - scikit-learn=0.19.1=py36hedc7406_0'; \
        echo '  - scipy=1.1.0=py36hd20e5f9_0'; \
        echo '  - seaborn=0.8.1=py36_0'; \
        echo '  - send2trash=1.5.0=py36_0'; \
        echo '  - setuptools=46.0.0=py36_0'; \
        echo '  - simplegeneric=0.8.1=py36_2'; \
        echo '  - singledispatch=3.4.0.3=py36_0'; \
        echo '  - sip=4.19.8=py36hf484d3e_0'; \
        echo '  - six=1.11.0=py36_1001'; \
        echo '  - snappy=1.1.7=hbae5bb6_3'; \
        echo '  - snowballstemmer=1.2.1=py36_0'; \
        echo '  - sortedcollections=0.6.1=py36_0'; \
        echo '  - sortedcontainers=1.5.10=py36_0'; \
        echo '  - sphinx=1.7.4=py36_0'; \
        echo '  - sphinxcontrib-websupport=1.0.1=py36_0'; \
        echo '  - spyder=3.2.8=py36_0'; \
        echo '  - sqlalchemy=1.2.7=py36h6b74fdf_0'; \
        echo '  - sqlite=3.31.1=h7b6447c_0'; \
        echo '  - statsmodels=0.9.0=py36h3010b51_1000'; \
        echo '  - sympy=1.1.1=py36_0'; \
        echo '  - tbb=2020.0=hfd86e86_0'; \
        echo '  - tbb4py=2020.0=py36hfd86e86_0'; \
        echo '  - tblib=1.3.2=py36_0'; \
        echo '  - tensorboard=1.13.1=py36_0'; \
        echo '  - tensorflow=1.13.1=mkl_py36h27d456a_0'; \
        echo '  - tensorflow-base=1.13.1=mkl_py36h7ce6ba3_0'; \
        echo '  - tensorflow-estimator=1.13.0=py_0'; \
        echo '  - termcolor=1.1.0=py36_1'; \
        echo '  - terminado=0.8.1=py36_1'; \
        echo '  - testpath=0.3.1=py36_0'; \
        echo '  - tk=8.6.8=hbc83047_0'; \
        echo '  - toolz=0.9.0=py36_0'; \
        echo '  - tornado=5.0.2=py36h14c3975_0'; \
        echo '  - traitlets=4.3.2=py36_0'; \
        echo '  - typing=3.6.4=py36_0'; \
        echo '  - typing_extensions=3.7.2=py36_1000'; \
        echo '  - unicodecsv=0.14.1=py36_0'; \
        echo '  - unixodbc=2.3.7=h14c3975_0'; \
        echo '  - urllib3=1.22=py36hbe7ace6_0'; \
        echo '  - wcwidth=0.1.7=py36_0'; \
        echo '  - webencodings=0.5.1=py36_1'; \
        echo '  - werkzeug=0.14.1=py36_0'; \
        echo '  - wheel=0.34.2=py36_0'; \
        echo '  - widgetsnbextension=3.2.1=py36_0'; \
        echo '  - wrapt=1.10.11=py36h14c3975_2'; \
        echo '  - xlrd=1.1.0=py36_1'; \
        echo '  - xlsxwriter=1.0.4=py36_0'; \
        echo '  - xlwt=1.3.0=py36_0'; \
        echo '  - xz=5.2.4=h14c3975_4'; \
        echo '  - yaml=0.1.7=had09818_2'; \
        echo '  - zeromq=4.2.5=hf484d3e_1'; \
        echo '  - zict=0.1.3=py36_0'; \
        echo '  - zlib=1.2.11=h7b6447c_3'; \
        echo '  - zstd=1.3.7=h0b5b093_0'; \
        echo '  - pip:'; \
        echo '    - grpcio==1.20.1'; \
        echo '    - simpleai==0.8.2'; \
        echo 'prefix: /root/miniconda3/envs/aiwolf'; \
    } > /tmp/AiwolfTmp/aiwolf.yaml

# 仮想環境の構築
# Building a Virtual Environment
RUN conda env create -f /tmp/AiwolfTmp/aiwolf.yaml && \
    echo 'conda activate aiwolf' >> /root/.bashrc && \
    echo '処理の完了までに時間を要する場合があります．' && \
    echo 'Processing may take some time to complete.'

# 一時的なフォルダを削除
# Delete temporary directory
RUN rm -r /tmp/AiwolfTmp/

# 人狼知能設定ファイルの削除
# Delete Werewolf Intelligence Configuration File
RUN rm /home/aiwolf-platform/AutoStarter.ini && \
    rm /home/aiwolf-platform/SampleSetting.cfg

# AutoStarter.shを書き換え
# Remake AutoStarter.sh
RUN echo 'java -cp /home/aiwolf-platform/aiwolf-server.jar:/home/aiwolf-platform/aiwolf-common.jar:/home/aiwolf-platform/aiwolf-client.jar:/home/aiwolf-platform/aiwolf-viewer.jar:/home/aiwolf-platform/jsonic-1.3.10.jar org.aiwolf.ui.bin.AutoStarter /home/aiwolf-platform/AutoStarter.ini' > /home/aiwolf-platform/AutoStarter.sh

# "conda run"で実行する
CMD [ "conda", "run", "-n", "aiwolf", "/bin/bash", "/home/aiwolf-platform/AutoStarter.sh" ]