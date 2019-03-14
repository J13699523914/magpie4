#' @title reportForestYield
#' @description reports MAgPIE harvested area for timber.
#' 
#' @export
#' 
#' @param gdx GDX file
#' @return Yield from Forests for timber production
#' @author Abhijeet Mishra
#' @examples
#' 
#'   \dontrun{
#'     x <- reportForestYield(gdx)
#'   }
#' 

reportForestYield<-function(gdx){
  a <- NULL
  
  if(suppressWarnings(!is.null(readGDX(gdx,"fcostsALL")))){
    a_harvest <- ForestYield(gdx,level = "regglo",yield_type = "harvest")
    a_estb <- ForestYield(gdx,level = "regglo",yield_type = "establishment")
    getNames(a_harvest) <- paste0("Timber Yields|Harvest|",getNames(a_harvest))
    getNames(a_harvest) <- paste0(getNames(a_harvest)," (m3 per ha)")
    
    getNames(a_estb) <- paste0("Timber Yields|Establishment|",getNames(a_estb))
    getNames(a_estb) <- paste0(getNames(a_estb)," (m3 per ha)")
    
    a <- mbind(a_harvest,a_estb)
  } else {cat("NULL returned for magpie run without dynamic forestry.")}
  
  return(a)
}