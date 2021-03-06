#' @title reportDemand
#' @description reports Demand for Food, Feed, Processing, Material, Bioenergy, Seed and Supply Chain Loss
#' 
#' @import magpiesets
#' @export
#' 
#' @param gdx GDX file
#' @param detail if detail=F, the subcategories of groups are not reported (e.g. "soybean" within "oilcrops")
#' @param agmip if agmip=T, additional sector aggregates required for agmip are reported (e.g. "AGR")
#' @return demand as MAgPIE object (Mt DM)
#' @author Benjamin Leon Bodirsky, Isabelle Weindl
#' @examples
#' 
#'   \dontrun{
#'     x <- reportDemand()
#'   }
#' 

reportDemand<-function(gdx,detail=FALSE,agmip=FALSE){
  out <- NULL
  x   <-  demand(gdx,level="regglo")
  getNames(x,dim=1) <- reportingnames(getNames(x,dim=1))
  
  for (type in getNames(x,dim=1)) {
    tmp <- collapseNames(x[,,type],collapsedim = 1)
    # demand.R renamed dim=3.1
    tmp<-reporthelper(x=tmp,level_zero_name = paste0("Demand|",type),detail = detail,dim=3.1)
    getNames(tmp) <- paste(getNames(tmp),"(Mt DM/yr)",sep=" ")
    out <- mbind(out,tmp)
  }
  out <- summationhelper(out)
  
  # Sum over all demands
  sum <- dimSums(x[,,], dim=3.1)
  # demand.R renamed dim=3.1
  sum<-reporthelper(x=sum,level_zero_name = "Demand",detail = detail,dim=3.1)
  sum <- summationhelper(sum)
  if (agmip==T) {
    agr_group <- c("Demand|+|Crops","Demand|+|Livestock products","Demand|+|Pasture") #"Demand|+|Forage"
    agr <- dimSums(sum[,,agr_group], dim=3.1)
    getNames(agr) <- "Demand|Primary agricultural products"
    sum <- mbind(sum,agr)
  }
  getNames(sum)[1]<-"Demand"
  getNames(sum) <- paste(getNames(sum),"(Mt DM/yr)",sep=" ")
  getNames(sum) <- gsub(pattern = "Demand\\|\\+",replacement = "Demand|++",x = getNames(sum))


  out <- mbind(out, sum)
#  out <- out[,,sort(getNames(out))]
  return(out)
}