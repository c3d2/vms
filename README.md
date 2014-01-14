## Building

```shell
cabal configure && cabal build &&
./dist/build/vms/vms
```

## Database

```shell
sudo -i -u postgres
createuser -W matemat
createdb  -O matemat matemat
```