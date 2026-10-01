#!/bin/sh
docker compose exec -T db psql -U booking_user -d booking_db -v ON_ERROR_STOP=1 "$@"
