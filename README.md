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



Developer Tip
-------------

There are several other useful grunt tasks in the Grunfile. Most notably:

    grunt watch         // monitor for changes and rebuild automatically
    grunt clean:build   // removes all built files
    grunt prod          // build without source mapping and minify

