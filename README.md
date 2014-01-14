## Building

```shell
cabal install --only-dependencies &&
cabal configure && cabal build &&
./dist/build/vms/vms
```

## Database

```shell
sudo -i -u postgres
createuser matemat
createdb  -O matemat matemat
psql
```
```sql
alter role "matemat" with encrypted password '1234';
```