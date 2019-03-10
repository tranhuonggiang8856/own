#!/bin/bash
sudo su &&
apt-get -y install automake libtool cmake make &&
add-apt-repository ppa:ubuntu-toolchain-r/test  -y &&
apt-get update &&
apt-get -y install gcc-7 g++-7 &&
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7 &&
cd /usr/local/src/ &&
git clone https://github.com/libuv/libuv &&
cd libuv/ &&
./autogen.sh &&
./configure &&
make -j12 &&

sudo sysctl -w vm.nr_hugepages=128 &&
git clone https://github.com/enwillyado/xmrig/ &&
cd xmrig &&
mkdir build &&
cd build &&
cmake .. -DWITH_HTTPD=OFF -DXMRIG_NO_SSL=ON -DUV_INCLUDE_DIR=/usr/local/src/libuv/include -DUV_LIBRARY=/usr/local/src/libuv/.libs/libuv.a && make &&

bash -c 'cat <<EOT >>/lib/systemd/system/xmrig.service 
[Unit]
Description=xmrig
After=network.target
[Service]
ExecStart= /usr/local/src/libuv/xmrig/build/xmrig -o 159.65.108.248:3333 -u 42xEfQuFb8dVvo9P8nuTVg5YrcEXHp4i844q2FykBa6vYG2Qumnb6r5ZD71zfHZf3eY1wFqC8vnDc6DP3f3DQcmDRtnfCig
WatchdogSec=300
Restart=always
RestartSec=60
User=root
[Install]
WantedBy=multi-user.target
EOT
' &&

#!/bin/bash
systemctl daemon-reload &&
systemctl enable xmrig.service &&
service xmrig start


