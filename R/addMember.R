#' Agregar un user a Ghost
#'
#' Esta función agrega un usuario a Ghost.
#'
#' @param name El nombre del usuario
#' @param email El email del usuario
#' @return Devuelve un tibble con los siguientes campos:
#' - status El código de status de la respuesta
#' - memberID El ID del miembro creado
#' @examples addMember("Juan Perez", "juan@perez.com"
#'
#' @export
#' @importFrom httr2 request req_headers req_body_json req_method req_perform
#' @importFrom jsonlite fromJSON
#' @importFrom tidyr %>%
#' @importFrom ghostMethods getJWT
#'
addMember = function(name, email) {

    require(httr2)
    require(tidyr)
    require(jsonlite)
    #require(ghostMethods)

    jwt = getJWT(integration = "admin")

    url = paste0("https://mercados-para-todos.ghost.io/ghost/api/admin/members/")

    body = list(
        members = list(
            list(
                name = name,
                email = email
            )
        )
    )

    r = request(url) %>%
        req_headers(Authorization = paste0("Ghost ", jwt),
                `Content-Type` = "application/json"
        ) %>%
        req_body_json(body) %>%
        req_method("POST") %>%
        req_perform()

    if (r$status_code == 201) {
        result = fromJSON(rawToChar(r$body))
        return(list(status = r$status_code,
                    memberID = result$members$id))
    } else {
        return(status = r$status_code,
                memberID = "Error al agregar el miembro.")
    }
}
