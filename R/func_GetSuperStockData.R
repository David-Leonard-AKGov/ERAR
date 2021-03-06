#=======================================================
#ERA function GetCASStocks()
#Translated from VB ERA CIS code
#October 2018
#Author: Catarina Wor
#=======================================================

#Read in data straight from SQL database

#=======================================================





#' @title GetSuperStockData
#'
#' @description  
#' 
#' 
#'
#' @param M A list passed to MainSub
#'
#' @details
#'
#' @return D: A list 
#' 
#' 
#' 
#' @export
#'
#' @examples
#' 
#' 
GetSuperStockData <- function(curr_stk,dbse){

    dta <- RODBC::odbcConnectAccess2007(dbse)   #specifies the file path   

    ERASQL = paste0("Select TerminalNetAge,OceanStartAge,MaxAge,SuperStock.SuperStock from SuperStock INNER JOIN ERA_Stock ON SuperStock.SuperStock = ERA_Stock.SuperStock Where ERA_Stock.ERAStock = '",curr_stk,"'")
    df1 <- RODBC::sqlQuery( dta , query = ERASQL )

    D<-list(TermNetSwitchAge = df1[[1]],
        OceanStartAge = df1[[2]],
        MaxAge = df1[[3]],
        SuperStock = df1[[4]])

	# 'Get Terminal Net Switch Age, OceanStartAge, and MaxAge for the ERAstock
    #    ERASQL = "Select TerminalNetAge,OceanStartAge,MaxAge,SuperStock.SuperStock from SuperStock INNER JOIN ERA_Stock ON SuperStock.SuperStock = ERA_Stock.SuperStock Where ERA_Stock.ERAStock = '" & CurrentStock & "'"
    #    ERACommand = New OleDbCommand(ERASQL, CISDBConnection)
    #    CISDataReader = ERACommand.ExecuteReader()
    #    CISDataReader.Read()
    #    TermNetSwitchAge = CISDataReader(0)
    #    OceanStartAge = CISDataReader(1)
    #    MaxAge = CISDataReader(2)
    #    SuperStock = CISDataReader(3)
    #    CISDataReader.Close()

    return(D)
	 

} 



