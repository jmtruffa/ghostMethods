#' Crea un JWT para integración con Ghost.or
#' 
#' Toma el secret de la variable de entorno GHOST_SECRET_ADMIN
#' y crea un JWT para integración con Ghost.
#' 
#' @details
#' El secret se obtiene de la variable de entorno GHOST_SECRET_ADMIN
#' que se setea en el archivo .Renviron
#' el nombre en el archivo es GHOST_SECRET_ADMIN o
#' GHOST_SECRET_[USER]
#' La función toma el valor de la variable de entorno y lo divide en dos partes
#' separadas por ":". La primera parte es el kid y la segunda el secret.
#' 
#' @param integration Qué variable tomará. Default es "admin"
#' @return Devuelve un JWT para integración con Ghost
#' @examples getJWT("admin") -> Devuelve un JWT para integración con Ghost
#' @export
#' @importFrom jose jwt_encode_hmac jwt_claim
#' @importFrom wkb hex2raw
getJWT = function(integration = "admin") {
  require(jose)
  require(wkb)

  # capitalize and append to the string "GHOST_SECRET_" to get the env var
  env = paste0("GHOST_SECRET_", toupper(integration))
  envVar = Sys.getenv(env)

  # split the secret into two parts
  secret = strsplit(envVar, ":")[[1]][2]
  kid = strsplit(envVar, ":")[[1]][1]
  
  # create a JWT with the secret and kid  
  jwt = jose::jwt_encode_hmac(
    claim = jwt_claim(
      exp = as.numeric(Sys.time() + 300),
      aud = "/admin/"
    ),
    secret = hex2raw(secret),
    header = list(
      kid = kid)
  )
  return (jwt)
}
