METODOS PARA GHOST.ORG

Este proyecto de R implementa algunos métodos para utilizar los endopoints de la API del sitio Ghost.org

Una vez que uno ya tiene creado el sitio, y los usuarios, crea una integración y obtiene la API Key. Esta API key debe ser guardada en su .Renviron bajo el nombre de:

- GHOST_SECRET_ADMIN

Desde ahí la función getJWT la leerá para poder conformar el JWT token.

También podrá utilizar la API Key de alguno de los escritores (contributors)  que haya dado de alta en el sitio.
Por el momento, en esta implementación, sólo está contemplada una API adicional de un escritor:

- GHOST_SECRET_JMTRUFFA

La función getJWT tiene un parámetro "integration" que determina cuál es la API Key a utilizar:

- admin
- jmtruffa

Como se puede ver, el parámetro espera lo que será el sufijo de la variable de entorno e.g.: jmtruffa -> GHOST_SECRET_JMTRUFFA

No hay puestos profusos controles, por cuanto de ingresar un parámetro que no se corresponde con una variable de entorno, la función no leerá ningún valor pero igual devolverá un JWT token que, lógicamente, no servirá. Tomar el cuidado necesario de tener las variables de entorno creadas y leídas.
