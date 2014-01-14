## Building

```shell
export PATH=~/.cabal/bin:$PATH
cabal install --only-dependencies &&
cabal configure && cabal build &&
./dist/build/vms/vms Development
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