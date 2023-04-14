#' Devuelve miembros de Ghost
#' 
#' 'reqGhostMembersPaged' devuelve los miembros en páginas de a 15
#' dado que así son las especificaciones de Ghost.
#' 
#' @details 
#' La API de Ghost pagina en multiplos de 15 (la última puede contener)
#' menos elementos.
#' Esta función toma el parámetro requestPage, seteado como default en 0, 
#' y ese parámetro lo pasa a la API para pedirle la página en cuestión
#' 
#' @param requestPage El número de página que se quiere consultar. Cada página
#' devuelve 15 registros.
#' Si se utiliza 0, siendo también el valor por default, devuelve todos los registros.
#' Utilizar con precaución.
#' @returns Devuelve un tibble con los siguientes campos:
#' - name
#' - email
#' - id         El ID interno usado por Ghost. Este sirve para consulta específica
#' - uuid       Adicional a id
#' - suscribed  Si tiene suscripciones o no a newsletters. No lo uso aún
#' - status     Acá todos dirán free. Pero lo dejo para un futuro.
#' 
#' @examples reqGhostMembersPaged(15) -> Devuelve la página 15
getMembers = function(requestPage = 0) {
  
  require(tidyverse)
  require(jsonlite)
  require(httr2)
  require(ghostMethods)
  
  jwt = getJWT()

  url = paste0("https://mercados-para-todos.ghost.io/ghost/api/admin/members/")
  r = request(url) %>%
    req_headers(Authorization = paste0("Ghost ", jwt),
                `Content-Type` = "application/json"
    )
  if (requestPage != 0) {
    r = r %>% req_url_query(page = requestPage)
  } else {
    r = r %>% req_url_query(limit = "all")
  }
  r = r %>% 
    req_method("GET") %>%
    req_perform()
  
  result = fromJSON(rawToChar(r$body))
  
  return (
    list(
      tibble(
        name = result$members$name,
        email = result$members$email,
        id = result$members$id,
        uuid = result$members$uuid,
        suscribed = result$members$subscribed,
        status = result$members$status
      ),
      totalPages = result$meta$pagination$pages,
      totalMembers = result$meta$pagination$total
  )
  )
}

#members = getMembers(0)
