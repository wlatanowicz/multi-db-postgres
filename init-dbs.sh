#!/usr/bin/env bash

N=1

psql=( psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --no-password )

while true
do
    DATABASE_VAR=DATABASE_${N}
    DATABASE=${!DATABASE_VAR}

    if [ -n "$DATABASE" ]
    then

        USERNAME_VAR=USERNAME_${N}
        USERNAME=${!USERNAME_VAR}
        PASSWORD_VAR=PASSWORD_${N}
        PASSWORD=${!PASSWORD_VAR}

        if [ -n "$USERNAME" ]
        then
            echo Creating user $USERNAME

            "${psql[@]}" --dbname postgres --set user="$USERNAME" --set password="$PASSWORD" <<< \
                "CREATE USER :\"user\" WITH PASSWORD :'password';" \
                || exit $?
        fi

        OWNER=${USERNAME:-postgres}

        echo Creating database $DATABASE with owner $OWNER

        "${psql[@]}" --dbname postgres --set db="$DATABASE" --set owner="$OWNER" <<< \
            "CREATE DATABASE :\"db\" WITH OWNER :\"owner\";" \
            || exit $?

    else
        break
    fi

    N=$((N+1))

done
