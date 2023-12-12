FROM dart:2.19-sdk AS build

WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe bin/rinha.dart -o bin/server

FROM ubuntu:latest
COPY --from=build /app/bin/server /app/bin/

EXPOSE 8080
CMD ["/app/bin/server"]
