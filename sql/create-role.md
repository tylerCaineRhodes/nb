# Create a Role
```bash
createdb
psql
CREATE USER postgres SUPERUSER;
```


# If you run into issues with the above command, try the following:
```bash
sudo -u postgres psql
ALTER
ROLE postgres WITH PASSWORD 'postgres'
```

# If role postgres does not exist, go into one of the initial tables
```bash
 psql -U $(whoami) -d postgres
```
