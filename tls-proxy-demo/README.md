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
which properties. We're using ports 8000 (serving applications), 8090 (MCMP communication) for httpd, and
ports 8080, 8081 for Tomcats; all of them are exposed to the localhost.

> [!NOTE]
> Given we created our own certificate, you will get a warning in most web browsers. Either disregard
> the warning (preferred) or import the created certificate among trusted ones.

If everything works as expected, you can visit

* [https://localhost:8000/](https://localhost:8000/)

    * to check whether httpd runs

* [https://localhost:8080/app/app.jsp](https://localhost:8080/app/app.jsp)

    * to check the application on the first tomcat

* [https://localhost:8081/app/app.jsp](https://localhost:8081/app/app.jsp)

    * to check the application on the second tomcat

* [https://localhost:8000/app/app.jsp](https://localhost:8000/app/app.jsp)

    * to access the application through proxy
    * in case you're accessing through the browser, pay attention to the session cookies (they are honored by the balancer by default)

* [https://localhost:8000/mod\_cluster\_manager](https://localhost:8000/mod_cluster_manager)

    * note that this should NOT be accessible from the internet as it permits changing settings of the proxy (it's exposed only for the demonstration purposes)
    * to check whether cluster manager is running and whether the proxy sees the two Tomcat instances (it takes a little bit of time for them to appear)


> [!CAUTION]
> Do not use this setup in production. The mod\_cluster\_manager page should not be accessible to outsiders. The same applies
> to the Tomcat containers. In real world use case you would expose the port `8000` only.

