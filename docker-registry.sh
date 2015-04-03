docker run  \
         -e SETTINGS_FLAVOR=local \
         -e STORAGE_PATH=/registry \
         -e SEARCH_BACKEND=sqlalchemy \
         -p 5000:5000 \
         -p 8088:8080 \
         registry

