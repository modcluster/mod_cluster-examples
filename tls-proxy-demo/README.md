# TLS/SSL demo

A small demo showing httpd based proxy with two Tomcat web servers running with HTTPS.

You can get the whole demo running by executing:

```shell
sh setup.sh
podman-compose up -d
```

If you're interested in how it is configured and run, check out the `setup.sh` script first. The
script generates a root certificate and builds the two container images the demo is using (Containerfiles
use this root certificate to generate their own; check the corresponding files for details).

Then inspect the `compose.yaml` file that instructs podman-compose which containers to run with
which properties. We're using port 8090 for httpd, and ports 8080, 8081 for Tomcats; all of them are
exposed to the localhost.

```
**NOTE**

Given we created our own certificate, you will get a warning in most web browsers. Either disregard
the warning (preferred) or import the created certificate among trusted ones.
```

If everything works as expected, you can visit

* [https://localhost:8090/](https://localhost:8090/)

    * to check whether httpd runs

* [https://localhost:8090/mod_cluster_manager](https://localhost:8090/mod_cluster_manager)

    * to check whether cluster manager is running and whether the proxy sees the two Tomcat instances (it takes a little bit of time)

* [https://localhost:8080/app/app.jsp](https://localhost:8080/app/app.jsp)

    * to check the application on the first tomcat

* [https://localhost:8081/app/app.jsp](https://localhost:8081/app/app.jsp)

    * to check the application on the second tomcat

* [https://localhost:8090/app/app.jsp](https://localhost:8090/app/app.jsp)

    * to access the application through proxy
    * in case you're accessing through the browser, pay attention to the session cookies (they are honored by the balancer by default)

