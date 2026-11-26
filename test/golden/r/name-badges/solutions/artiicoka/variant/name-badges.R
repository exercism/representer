print_name_badge <- function(id, name, department) {
  parts <- c()
  if (!is.na(id)) {
    parts <- c(parts, paste0('[', id, '] -'))
  }
  parts <- c(parts, name)
  if (is.null(department)) {
    parts <- c(parts, '- OWOER')
  } else {
    parts <- c(parts, paste0('- ', toupper(department)))
  }
  paste(parts, collapse=' ')
}

salaries_no_id <- function(ids, salaries) {
  sum(salaries[is.na(ids)])
}
