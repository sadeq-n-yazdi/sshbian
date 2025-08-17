#/bin/bash

docker build --tag my-ssh-box .
# --build-arg DEV_USER_PASSWORD=atalmatal 

docker stop  my-ssh-container
docker rm  my-ssh-container

#docker run --rm --privileged -it --name my-ssh-container -p 2222:22 -v $HOME/.ssh:/root/.ssh --cap-add=NET_ADMIN --device=/dev/net/tun my-ssh-box
test "[ -x authorized_keys ]" && echo 'Exists' || cp "$HOME/.ssh/authorized_keys" ./ && \
docker run --rm --privileged --device=/dev/net/tun:/dev/net/tun --name my-ssh-container -p 2222:22 --cap-add=NET_ADMIN --device=/dev/net/tun my-ssh-box

docker logs -f my-ssh-box

