#' Graphic parameters for go game images
#' @description Customize go images
#' @examples
#' ggoban(19, boardcolor = "yellow", gridcolor = "blue") %>%
#'   addstones(c(10, 11), c(10, 10), c(1, 2), c(1, 2),
#'             blackcolor = "green", whitecolor = "red",
#'             blacknumbercolor = "black",
#'             whitenumbercolor = "black")
#' @details Go game images can be customized flexibly by passing appropriate
#' graphic parameters to functions that create images.
#' The complete list of available parameters are given below
#' (default values in parentheses).
#' \describe{
#' \item{\code{targetwidth}}{Width to be used when exporting the image.
#' Other size parameters are adjusted in accordance with this parameter (\code{5})}
#' \item{\code{colortheme}}{Predefined color template. Currently supports:
#' \code{"standard"}, \code{"bw"}, \code{"pastel"}, \code{"dark"}
#' and \code{"crystal"} (\code{NULL})}
#' \item{\code{boardsize}}{Size of board (\code{19})}
#' \item{\code{xlim}, \code{ylim}}{Use to draw a partial board image
#' (\code{NULL}, \code{NULL})}
#'
#' \item{\code{boardcolor}}{Color of board (\code{"#ecf0b7"})}
#' \item{\code{boardalpha}}{Transparency of board (\code{1})}
#' \item{\code{gridcolor}}{Color of grid lines (\code{"#262626"})}
#' \item{\code{starcolor}}{Color of stars on board (\code{"#262626"})}
#' \item{\code{starsize}}{Size of stars on board (\code{1.5})}
#' \item{\code{axislabelcolor}}{Color of axis labels (\code{"#262626"})}
#' \item{\code{axislabelsize}}{(Size of axis labels \code{3.5})}
#' \item{\code{xlables}, \code{ylabels}}{Axis labels
#' (\code{LETTERS[-9]}, \code{as.character(1:25)})}
#' \item{\code{axislabels}}{If true, axis labels are added (\code{TRUE})}
#'
#' \item{\code{blackcolor}, \code{whitecolor}}{Stone colors on the board
#' (\code{"#111111"}, \code{"#f5f5f5"})}
#' \item{\code{stonealpha}}{Transparency of stones (\code{1})}
#' \item{\code{stonesize}}{Size of stones (\code{6})}
#' \item{\code{stonelinecolor}}{Color of stone line (\code{"#101010"})}
#' \item{\code{stonelinewidth}}{Width of stone line (\code{0.7})}
#'
#' \item{\code{blacknumbercolor}, \code{whitenumbercolor}}{
#' Color of numbers on stones (\code{"#f0f0f0"}, \code{"#0f0f0f"})}
#' \item{\code{numbersize}}{Size of numbers on stones (\code{3})}
#'
#' \item{\code{blacklabelcolor}, \code{whitelabelcolor}, \code{emptylabelcolor}}{
#' Colors of labels put on stones and empty points
#' (\code{"#f0f0f0"}, \code{"#0f0f0f"}, \code{"#262626"})}
#' \item{\code{labelsize}}{Size of labels (\code{3.5})}
#' \item{\code{emptylabelshadowsize}}{Size of background for labels
#' put on empty points (\code{5})}
#'
#' \item{\code{blackmarkercolor}, \code{whitemarkercolor}, \code{emptymarkercolor}}{
#' Colors of markers put on stones and empty points
#' (\code{"#f0f0f0"}, \code{"#0f0f0f"}, \code{"#262626"})}
#' \item{\code{markersize}}{Size of markers (\code{2.5})}
#'
#' \item{\code{lastmovemarker}}{Shape of marker indicating the last move (\code{3})}
#'
#' \item{\code{territorysize}}{Size of territory indicators (\code{2})}
#' \item{\code{territoryshape}}{Shape of territory indicators. Recommended
#' to use an integer between 21 and 25 (\code{21})}
#' \item{\code{territorylinecolor}}{Color of lines of territory indicators (\code{"#262626"})}
#' \item{\code{territorylinewidth}}{Line width of territory indicators (\code{0.5})}
#'
#' \item{\code{blackmark}, \code{whitemark}, \code{emptymark}}{Letters used to indicate
#' stones and empty points when printing on console (\code{"@"}, \code{"O"}, \code{"+"})}
#'
#' \item{\code{notebackcolor}}{Background color of outside note for kifu (\code{"#eff7df"})}
#' \item{\code{notetextcolor}}{Color of text used in outside note for kifu (\code{"#101010"})}
#' \item{\code{notestonesize}}{Size of stones in outside note for kifu (\code{5})}
#' \item{\code{notenumbersize}}{Size of numbers on stones in outside note for kifu (\code{2.5})}
#' \item{\code{notetextsize}}{Size of texts in outside note for kifu (\code{3})}
#' \item{\code{moveperrow}}{Number of moves shown for each line of outside note for kifu (\code{8})}
#' \item{\code{adjustorigin}}{If true, move numbers are deducted by a multiple of hundred
#' when appropriate (\code{TRUE})}
#'
#' \item{\code{adjustsizeonboard}}{Adjust all sizes for go board image in
#' accordance with the board size. Not recommended to change (\code{TRUE})}
#' \item{\code{adjustsizeonnote}}{Adjust all sizes for outside note in
#' accordance with the board size (\code{FALSE})}
#' }
#' @name gogame_graphics
#' @aliases graphic_parameters
NULL


set_graphic_param <- function(...)
{
  # Set graphic parameters for go board
  # for internal use
  #
  # we use .default_graphic_param as a default, and
  # update parameters specified by ...
  #
  # Args:
  #   ...  graphic paramters
  #
  # Returns:
  #   a list of graphic paramters
  #


  out <- as.list(.default_graphic_param)
  args <- list(...)

  # if specified, apply colortheme
  if (!is.null(args$colortheme)) {
    color_theme <- .color_themes[[args$colortheme]]
    tochange <- intersect(names(out), names(color_theme))
    out[tochange] <- color_theme[tochange]
  }

  tochange <- intersect(names(out), names(args))
  out[tochange] <- args[tochange]



  # set endogenous parameters
  # boardlimit
  if (is.null(out$xlim)) {
    boardxlim <- c(1L, out$boardsize)
  } else {
    boardxlim <- out$xlim
  }
  if (is.null(out$ylim)) {
    boardylim <- c(1L, out$boardsize)
  } else {
    boardylim <- out$ylim
  }

  # determine the margin size
  # if axislabel is not added, the margin size depends on the boardlimits
  # since stones are so big that they may not fit in the image for small board
  m <- 0.2 + 0.03 * (18 - diff(boardxlim))
  m <- max(m, 0)
  xmar <- c(-m, m)
  m <- 0.2 + 0.03 * (18 - diff(boardylim))
  m <- max(m, 0)
  ymar <- c(-m, m)
  if (out$axislabels) {
    # add 1 if axislabels = true and the limit is to the edge
    if (boardxlim[1] == 1L)            xmar[1] <- -1L
    if (boardxlim[2] == out$boardsize) xmar[2] <- 1L
    if (boardylim[1] == 1L)            ymar[1] <- -1L
    if (boardylim[2] == out$boardsize) ymar[2] <- 1L
  }

  boardxlim <- boardxlim + xmar
  boardylim <- boardylim + ymar
  out$endogenous$boardxlim <- boardxlim
  out$endogenous$boardylim <- boardylim


  # size parameters
  # get size parameter names
  sizevars <- setdiff(names(out), "boardsize")
  sizevars <- sizevars[grep("size$", sizevars)]
  gobansizevars <- sizevars[regexpr("^note", sizevars) < 0]
  notesizevars <- sizevars[regexpr("^note", sizevars) > 0]

  # initialize size parameters
  out$endogenous[sizevars] <- out[sizevars]

  # adjust size based on the effective boardsize
  effective_boardsize <- diff(boardxlim)
  ratio <- (effective_boardsize - 20)/19 + 1
  if (out$adjustsizeonboard && is.numeric(out$boardsize)) {
    for (v in gobansizevars)
      out$endogenous[[v]] <- out$endogenous[[v]] / ratio
  }
  if (out$adjustsizeonnote && is.numeric(out$boardsize)) {
    for (v in notesizevars)
      out$endogenous[[v]] <- out$endogenous[[v]] / out$boardsize * 18
  }

  # adjust size based on the target width
  # here is magic formula for the size adjustment
  ratio <- 0.25 * (out$targetwidth - 4.8) + 1
  for (v in sizevars)
    out$endogenous[[v]] <- out$endogenous[[v]] * ratio

  return(out)
}


update_graphic_param <- function(params, ...)
{
  # Update graphic paramters
  # for internal use.
  #
  # Args:
  #   params  a list of graphic paramters
  #   ...     graphic parameters to update
  #
  # Returns:
  #   a list of graphic parameters

  newparams <- list(...)
  toappend <- setdiff(names(params), names(newparams))
  args <- c(newparams, params[toappend])
  out <- do.call(set_graphic_param, args = args)
  return(out)
}



