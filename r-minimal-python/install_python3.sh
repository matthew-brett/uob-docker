# Install Python 3 as root
PY_VER=${PY_VER:-3.8}
PY_EXE=python${PY_VER}
apt-get install -y ${PY_EXE}
apt-get install -y ${PY_EXE}-dev ${PY_EXE}-distutils
LOCAL_BIN=/usr/local/bin
ln -s $(which $PY_EXE) $LOCAL_BIN/python
ln -s $(which $PY_EXE) $LOCAL_BIN/python3
GET_PIP=.get_pip.py
curl -L https://bootstrap.pypa.io/get-pip.py -o $GET_PIP
python $GET_PIP
rm $GET_PIP
