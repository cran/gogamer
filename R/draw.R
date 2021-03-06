

#' Add stones to go board
#' @param gg  \code{ggplot} object
#' @param x,y integer vectors of stone locations
#' @param color integer vector of stone colors
#' @param number integer vector of numbers on stones
#' @param ... graphic parameters
#' @return \code{\link{ggoban}} object
#' @export
#' @seealso \code{\link{ggoban}}, \code{\link{graphic_parameters}}
#' @examples
#' ggoban(19) %>%
#'   addstones(c(10, 11), c(10, 10), c(1, 2), c(10, 11))
addstones <- function(gg, x, y, color, number = NULL, ...)
{
  if (is.ggoban(gg)) {
    graphic_param <- update_graphic_param(attr(gg, "graphic_param"), ...)
  } else {
    graphic_param <- set_graphic_param(...)
  }

  if (!all(color %in% c(BLACK, WHITE)))
    stop("color must be ", BLACK, " or ", WHITE)

  # prepare data
  dat <- data.frame(x = x, y = y)
  if (!is.null(number)) dat$label <- number

  # draw stones
  for (j in unique(color))
  {
    if (j == BLACK) {
      stonecolor <- graphic_param$blackcolor
    } else {
      stonecolor <- graphic_param$whitecolor
    }
    dat2 <- dat[color == j,]
    # filter the points by the bordlimit
    dat2 <- dat2 %>%
      dplyr::filter_(~x >= graphic_param$endogenous$boardxlim[1],
                     ~x <= graphic_param$endogenous$boardxlim[2],
                     ~y >= graphic_param$endogenous$boardylim[1],
                     ~y <= graphic_param$endogenous$boardylim[2])

    gg <- gg +
      ggplot2::geom_point(
        data = dat2, ggplot2::aes_string(x = "x", y = "y"),
        shape = 21,
        size = graphic_param$endogenous$stonesize,
        color = graphic_param$stonelinecolor,
        alpha = graphic_param$stonealpha,
        fill = stonecolor,
        stroke = graphic_param$stonelinewidth)

    if (!is.null(number)) {
      if (j == BLACK) {
        numbercolor <- graphic_param$blacknumbercolor
      } else {
        numbercolor <- graphic_param$whitenumbercolor
      }

      gg <- gg +
        ggplot2::geom_text(
          data = dat2, ggplot2::aes_string(x = "x", y = "y", label = "label"),
          size = graphic_param$endogenous$numbersize,
          color = numbercolor)
    }
  }

  return(gg)
}


#' Add text label on board
#' @param gg  \code{ggplot} object
#' @param x,y integer vectors of stone locations
#' @param label character vector of labels
#' @param color integer vector of stone colors
#' @param ... graphic parameters
#' @return \code{\link{ggoban}} object
#' @export
#' @seealso \code{\link{ggoban}}, \code{\link{graphic_parameters}}
#' @examples
#' ggoban(19) %>%
#'   addstones(c(16, 4), c(16, 3), c(1, 2)) %>%
#'   addlabels(c(4, 3), c(17, 16), c("a", "b"))
addlabels <- function(gg, x, y, label, color = NULL, ...)
{
  if (is.ggoban(gg)) {
    graphic_param <- update_graphic_param(attr(gg, "graphic_param"), ...)
  } else {
    graphic_param <- set_graphic_param(...)
  }

  dat <- data.frame(x = x, y = y, label = label)
  if (is.null(color)) {
    # filter the points by the bordlimit
    dat <- dat %>%
      dplyr::filter_(~x >= graphic_param$endogenous$boardxlim[1],
                     ~x <= graphic_param$endogenous$boardxlim[2],
                     ~y >= graphic_param$endogenous$boardylim[1],
                     ~y <= graphic_param$endogenous$boardylim[2])
    gg <- gg +
      ggplot2::geom_point(
        data = dat, ggplot2::aes_string(x = "x", y = "y"),
        size = graphic_param$endogenous$emptylabelshadowsize,
        color = graphic_param$boardcolor) +
      ggplot2::geom_text(
        data = dat, ggplot2::aes_string(x = "x", y = "y", label = "label"),
        size = graphic_param$endogenous$labelsize,
        color = graphic_param$emptylabelcolor)
  } else {
    if (!all(color %in% c(BLACK, WHITE)))
      stop("color must be ", BLACK, " or ", WHITE)
    for (j in unique(color))
    {
      if (j == BLACK) {
        labelcolor <- graphic_param$blacklabelcolor
      } else {
        labelcolor <- graphic_param$whitelabelcolor
      }
      dat2 <- dat[color == j,]
      # filter the points by the bordlimit
      dat2 <- dat2 %>%
        dplyr::filter_(~x >= graphic_param$endogenous$boardxlim[1],
                       ~x <= graphic_param$endogenous$boardxlim[2],
                       ~y >= graphic_param$endogenous$boardylim[1],
                       ~y <= graphic_param$endogenous$boardylim[2])
      gg <- gg +
        ggplot2::geom_text(
          data = dat2, ggplot2::aes_string(x = "x", y = "y", label = "label"),
          size = graphic_param$endogenous$labelsize, color = labelcolor)
    }
  }

  return(gg)
}


#' Add territory markers
#' @param gg  \code{ggplot} object
#' @param x,y integer vectors of stone locations
#' @param color integer vector of stone colors
#' @param ... graphic paramters
#' @return \code{\link{ggoban}} object
#' @seealso \code{\link{ggoban}}, \code{\link{graphic_parameters}}
#' @export
addterritory <- function(gg, x, y, color, ...)
{
  if (is.ggoban(gg)) {
    graphic_param <- update_graphic_param(attr(gg, "graphic_param"), ...)
  } else {
    graphic_param <- set_graphic_param(...)
  }

  if (!all(color %in% c(BLACK, WHITE)))
    stop("color must be ", BLACK, " or ", WHITE)
  if (!(graphic_param$territoryshape %in% 21:25))
    warning("territory may not be shown properly with ",
            "'territoryshape' not in 21-25")

  # prepare data
  dat <- data.frame(x = x, y = y)

  # fill stones
  for (j in unique(color))
  {
    if (j == BLACK) {
      stonecolor <- graphic_param$blackcolor
    } else {
      stonecolor <- graphic_param$whitecolor
    }
    dat2 <- dat[color == j,]
    # filter the points by the bordlimit
    dat2 <- dat2 %>%
      dplyr::filter_(~x >= graphic_param$endogenous$boardxlim[1],
                     ~x <= graphic_param$endogenous$boardxlim[2],
                     ~y >= graphic_param$endogenous$boardylim[1],
                     ~y <= graphic_param$endogenous$boardylim[2])
    gg <- gg +
      ggplot2::geom_point(
        data = dat2, ggplot2::aes_string(x = "x", y = "y"),
        shape = graphic_param$territoryshape,
        size = graphic_param$endogenous$territorysize,
        color = graphic_param$territorylinecolor,
        alpha = graphic_param$stonealpha,
        fill = stonecolor,
        stroke = graphic_param$territorylinewidth)
  }

  return(gg)
}


#' Add markers
#' @param gg  \code{ggplot} object
#' @param x,y integer vectors of stone locations
#' @param color integer vector of stone colors
#' @param marker scalar integer indicating the shape of marker
#' @param ... graphic parameters
#' @return \code{\link{ggoban}} object
#' @seealso \code{\link{ggoban}}, \code{\link{graphic_parameters}}
#' @export
#' @examples
#' ggoban(19) %>%
#'   addstones(10, 10, 1) %>%
#'   addmarkers(10, 10, 1)
addmarkers <- function(gg, x, y, color, marker = 17, ...)
{
  if (is.ggoban(gg)) {
    graphic_param <- update_graphic_param(attr(gg, "graphic_param"), ...)
  } else {
    graphic_param <- set_graphic_param(...)
  }


  if (!all(color %in% c(BLACK, WHITE)))
    stop("color must be ", BLACK, " or ", WHITE)

  # prepare data
  dat <- data.frame(x = x, y = y)

  # draw markers
  for (j in unique(color))
  {
    if (j == BLACK) {
      markercolor <- graphic_param$blackmarkercolor
    } else {
      markercolor <- graphic_param$whitemarkercolor
    }
    dat2 <- dat[color == j,]
    # filter the points by the bordlimit
    dat2 <- dat2 %>%
      dplyr::filter_(~x >= graphic_param$endogenous$boardxlim[1],
                     ~x <= graphic_param$endogenous$boardxlim[2],
                     ~y >= graphic_param$endogenous$boardylim[1],
                     ~y <= graphic_param$endogenous$boardylim[2])

    gg <- gg +
      ggplot2::geom_point(
        data = dat2, ggplot2::aes_string(x = "x", y = "y"),
        size = graphic_param$endogenous$markersize,
        color = markercolor,
        shape = marker)
  }

  return(gg)
}




#' Get location of stars
#' @param boardsize integer of boardsize
#' @return \code{data.frame} with variables \code{x} and \code{y}
star_position <- function(boardsize)
{
  if (boardsize >= 13L) {
    a <- seq(4L, boardsize - 4L + 1, length = 3)
    a <- a[a %% 1 == 0]
  } else {
    a <- seq(3L, boardsize - 3L + 1, length = 2)
    a <- a[a %% 1 == 0]
  }
  out <- expand.grid(x = a, y = a)
  if (boardsize < 13L && boardsize %% 2 == 1)
    out <- rbind(out, data.frame(x = (boardsize+1)/2, y = (boardsize+1)/2))

  return(out)
}
