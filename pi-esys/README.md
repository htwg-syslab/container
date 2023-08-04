# build
```
docker build --tag pi-esys:latest .
```
# run
```
docker run -d --network=host --device=/dev/ttyAMA0 -v /sys:/sys --name=pi-esys --restart=unless-stopped --hostname=pi-esys pi-esys:latest
```
