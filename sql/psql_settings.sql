elect name, setting, short_desc || coalesce(E'\n' || extra_desc, '')
from pg_settings where name ~ '^enable_';
