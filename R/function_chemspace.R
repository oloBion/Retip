

#' Extract information from msp file downloaded from MoNA
#' @export chem.space
#' @param db_rt A user library dataframe with chemical descriptors calculated
#' @param t Target database to be compared. Choice with: "ALL",  "HMDB",  "KNAPSACK",
#' @return  plot chemical space between user library and target database
#' @examples
#' \donttest{
#' chem.space(db_rt,t="HMDB")}

chem.space <- function (db_rt,t="HMDB"){

  retip_lib_v1 <- data.frame(Retip::retip_lib_head,Retiplib::retip_lib_v1)

  if ("ALL" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,1] != "N/A")
  }else if ("HMDB" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,7] != "N/A")
  }else if ("KNAPSACK" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,8] != "N/A")
  }else if ("CHEBI" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,9] != "N/A")
  }else if ("DRUGBANK" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,10] != "N/A")
  }else if ("SMPDB" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,11] != "N/A")
  }else if ("YMDB" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,12] != "N/A")
  }else if ("T3DB" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,13] != "N/A")
  }else if ("FOODB" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,14] != "N/A")
  }else if ("NANPDB" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,15] != "N/A")
  }else if ("STOFF" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,16] != "N/A")
  }else if ("BMDB" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,17] != "N/A")
  }else if ("LIPIDMAPS" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,18] != "N/A")
  }else if ("URINE" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,19] != "N/A")
  }else if ("SALIVA" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,20] != "N/A")
  }else if ("FECES" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,21] != "N/A")
  }else if ("ECMDB" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,22] != "N/A")
  }else if ("CSF" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,23] != "N/A")
  }else if ("SERUM" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,24] != "N/A")
  }else if ("PLANTCYC" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,26] != "N/A")
  }else if ("UNPD" %in% t){target <- dplyr::filter(retip_lib_v1 , retip_lib_v1[,27] != "N/A")
  }else {target <- t}

  db_rt <- db_rt
  db_rt$RT <- NULL

  db <- target[names(target) %in% names(db_rt)]

  ncoldb <- ncol(db_rt)


  pca_model <-  caret::preProcess(db, method = c("pca"))

  pca_db <-  stats::predict(pca_model, db)

  pca_db_rt <- stats::predict(pca_model, db_rt)

  graphics::plot(pca_db[,1],pca_db[,2],type = "p",col="blue",pch=4,xlab="", ylab="", xlim=c(-20, 50), ylim=c(-30, 30))
  graphics::par(new=TRUE)
  graphics::plot(pca_db_rt[,1],pca_db_rt[,2],type = "p",pch=5,col="green",xlab="PCA1", ylab="PCA2", xlim=c(-20, 50), ylim=c(-30, 30))


}

