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

## Mail
We use /usr/bin/exim4 -t -f no-reply@c3d2.de to send mail.
The user running vms has to be added to the trusted_users of exim4
