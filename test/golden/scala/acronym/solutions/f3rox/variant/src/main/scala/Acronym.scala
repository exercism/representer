object Acronym:
  val abbreviate: String => String = _.split(Array(' ', '-')).flatMap(_.headOption).mkString.toLowerCase