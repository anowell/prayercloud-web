Getting Started
---------------

PrayerCloud-Web depends on PrayerCloud-Api. See [PrayerCloud-API Getting Started](https://bitbucket.org/anowell/prayercloud-api/wiki/Home) first.

    npm install
    npm install grunt-cli
    grunt

Detailed [getting started guide] available on the wiki.

Integrating with PrayerCloud-API
--------------------------------

PrayerCloud-API will serve static files from `prayercloud-api/public`.
The simplest way to use PrayerCloud-Web is to create that dir as a symlink to PrayerCloud-Web's build dir

    ln -s path/to/prayercloud-api/public path/to/prayercloud-web/build

Alternatively, you can setup a webserver to serve from each project similar to how it works in production.
Here is a sample [Nginx](http://wiki.nginx.org/Install) config that would start prayercloud at http://localhost:8080

    server {
      listen 8080 default_server;
      listen [::]:8080 default_server ipv6only=on;
      server_name localhost;

      root /path/to/prayercloud-web/build;
      index index.html;

      location / {
        try_files $uri /index.html =404;
      }

      location /api/ {
        proxy_pass http://127.0.0.1:3000;
      }

      # eventually this route should be deprecated
      location /auth/ {
        proxy_pass http://127.0.0.1:3000;
      }
    }


Developer Tip
-------------

There are several other useful grunt tasks in the Grunfile. Most notably:

    grunt watch         // monitor for changes and rebuild automatically
    grunt clean:build   // removes all built files
    grunt prod          // build without source mapping and minify

