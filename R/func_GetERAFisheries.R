#=======================================================
#ERA function GetPSCFisheries()
#Translated from VB ERA CIS code
#November 2018
#Author: Catarina Wor
#=======================================================

#=======================================================


#source(utils.R)


GetERAFisheries <- function(M){


	#    'Get number of ERAFisheries
    dta <- RODBC::odbcConnectAccess2007(M$datbse)   #specifies the file path
   # ERASQL <- "SELECT MAX(ID) from ERA_ERAFishery"

    #NumberERAFisheries <-  RODBC::sqlQuery( dta , query = ERASQL )[1,1]

    #    'Get name,number,gear of ERAFisheries
   
    ERASQL2 <- "SELECT ID,Name from ERA_ERAFishery"
	  
    NumberERAFisheries <- nrow(df1)
	names(df1) <- c("ERAFisheryNumber","ERAFisheryName")

   	D <- list( NumberERAFisheries= NumberERAFisheries,
   	ERAFisheryNumber = df1$ERAFisheryNumber,
   	ERAFisheryName = df1$ERAFisheryName)
	
	return(D)


	#Original ERA code
	#NumberERAFisheries = 0
    #    'Get number of ERAFisheries
    #    ERASQL = "SELECT MAX(ID) from ERA_ERAFishery"
    #    ERACommand = New OleDbCommand(ERASQL, CISDBConnection)
    #    CISDataReader = ERACommand.ExecuteReader()
    #    CISDataReader.Read()
    #    NumberERAFisheries = CISDataReader(0)
    #    CISDataReader.Close()
    #    'Get name,number,gear of ERAFisheries
    #    ReDim ERAFisheryName(NumberERAFisheries)
    #    ERASQL = "SELECT ID,Name from ERA_ERAFishery"
    #    ERACommand = New OleDbCommand(ERASQL, CISDBConnection)
    #    CISDataReader = ERACommand.ExecuteReader()
    #    Do While CISDataReader.Read()
    #        Dim ERAFisheryNumber As Integer
    #        ERAFisheryNumber = CISDataReader(0)
    #        ERAFisheryName(ERAFisheryNumber) = CISDataReader(1)
    #    Loop
    #    CISDataReader.Close()

} 




