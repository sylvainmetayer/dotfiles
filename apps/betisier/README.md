# Betisier

School project : https://github.com/sylvainmetayer/Betisier-TP/

## Setup

Import DB from repository (`admin/betisierSylvain.sql`)

Run the following query to reset password :

```sql
UPDATE personne SET per_pwd = MD5(CONCAT(MD5('IUT'), 'SALT'));
```

All users will have the `IUT` password.
