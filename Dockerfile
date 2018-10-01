FROM postgres:10.0

COPY init-dbs.sh /usr/local/bin/
COPY multi-db-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["multi-db-entrypoint.sh"]
CMD ["postgres"]
