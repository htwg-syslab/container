# build
```
docker build --tag pi-esys-runner:latest .
```
# run
```
docker run -d --network=host --device=/dev/ttyAMA0 -v /sys:/sys --name=pi-esys-runner --restart=unless-stopped --hostname=pi-esys-runner pi-esys-runner:latest
```
