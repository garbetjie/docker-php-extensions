ARG IMAGE
FROM $IMAGE
COPY --from=composer:2.0.6 /usr/bin/composer /usr/local/bin/composer
