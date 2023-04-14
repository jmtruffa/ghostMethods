getJWT = function(integration = "admin") {
  require(jose)
  require(wkb)

  # capitalize and append to the string "GHOST_SECRET_" to get the env var
  env = paste0("GHOST_SECRET_", toupper(integration))
  envVar = Sys.getenv(env)

  # split the secret into two parts
  secret = strsplit(envVar, ":")[[1]][1]
  kid = strsplit(envVar, ":")[[1]][2]
  
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