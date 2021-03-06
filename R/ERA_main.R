#===================================================================
#GENERAL INFORMATION
#This is an attempt to reproduce a version of the ERA program i the CIS database.
#This file is a simplified version of the current progam  and is not intended to replace the current method
#Comments fro original version of the model were preserved.
# Code was also written to maximize similarity between this version and the
# original VB version, functions are equivalent to the SUBs in the original code
#Author: Catarina Wor 
#Date: October 2018
# written in long form and with the intent to closely match the available vb code as an exercise
#===================================================================





#===================================================================
#VARIABLE DEFINTIONS -- this needs work

#-----------------#
#Indices/counters
#-----------------#
#ERAStock counter for user selected ERA stocks. 
#


#-----------------#
#Controls and flags
#-----------------#
#ArithmeticMeanFlag <- 1
#isTraceCalc <- FALSE
#isTraceByBroodYr <- TRUE
#isTraceByCalendarYr <- FALSE
#traceThisShakerMethod <- "C"




#-----------------#
#data
#-----------------#
#number stocks being modelled

#ERAStockArray
#maximum year in the data analysis


#-----------------#
#model variables
#-----------------#
#No idea if this is differnt from the MaxCalendarYear


#===================================================================

#load in all the sub functions
#this was only useful before this became a package
#funclib<- getwd()
#func_files <- list.files(funclib,pattern="func_",full.name=TRUE)

#for(fn in 1:length(func_files)){
#	source(func_files[fn])
#}

#***********************
#Settings
#####Average_Maturation_Rate
#LongTermAverage
#SelectNumberCompleteBroods

#####Mean type for Maturation rates
#ArithmeticMean
#GeometricMean

#I do not know what this is check the: Proportion non vulnerable 
###PNV Algorythm 
#StockSpecific
#FisherySpecific

#####IncompleteYearAlgorithm
#New
#Historic

#==========================================
#list of packages required to run this model
#RODBC



#initial list of settings
M <- list(
    isCombineAge2And3=c(TRUE,
    isCombineAge5And6=FALSE,
    isReplicateCohShak = FALSE,
    StockListView =c("HAR","ATN"),
    datbse="../data/CIS2018_Pilot_Small.accdb",
    ArithmeticMeanFlag = TRUE,
    MaxCalendarYear=2017,
    isTraceCalc = FALSE,
    isTraceByBroodYr = TRUE,
    isTraceByCalendarYr = FALSE,
    traceThisShakerMethod = "C",
    Average_Maturation_Rate = "SelectNumberCompleteBroods",
    LastCompleteBroodsUsed = 9,
    MeanMatType = "ArithmeticMean",
    PNVAlgorithm = "FisherySpecific",
    ShakerMethod ="C",
    IncompleteYearAlgorithm= "New",
    RoundRecoveriesByTagCode= TRUE
    )



#load in all accessory functions - to be deleted if/when we turn this into a package
funcfiles <- list.files(getwd(),pattern="func",full.names=TRUE)
    
for(i in 1:length(funcfiles)){
    
    source(funcfiles[i])

}





#' @title StartCohortAnalysis_Click
#'
#' @description  This function writes the Settings log file, i.e.: which ERA options did you choose for
#'  Average_Maturation_Rate, MeanMatType,PNVAlgorithm,ShakerMethod, IncompleteYearAlgorithm, and 
#' RoundRecoveriesByTagCode. It also retrieves additional data from the database using the following sub 
#' routines: GetPSCFisheries, GetERAFisheries, GetCalendarYears, GetERAStocks.
#'    
#'
#' @param M A list with inital settings to be used in the ERA
#'
#' @details
#'
#' @return A list containing all initial settings contained in M plus additional data gathered from other 
#' subfunctions: GetPSCFisheries, GetERAFisheries, GetCalendarYears, GetERAStocks
#' 
#' 
#' @export
#'
#' @examples
#' 
#' 
StartCohortAnalysis_Click <- function(M){

    #=====================================



    sink("../logs/Settings.log")
    cat("You have selected the following settings:\n")

    if(M$Average_Maturation_Rate == "LongTermAverage"){

        cat("Average Maturation Rate: Long Term Average\n")

    }else if(M$Average_Maturation_Rate == "SelectNumberCompleteBroods" ){
    
        cat(paste("Selected to use the last", M$LastCompleteBroodsUsed,"Brood Years \n"))
    
    }


    if(M$MeanMatType=="ArithmeticMean"){
    
        cat("Arithmetic Average Maturity Rates \n")
    
    }else{
    
       cat("Geometic Average Maturity Rates \n")
    
    }

    if(M$PNVAlgorithm=="StockSpecific"){

        cat("Proportion Not Vulnerable setting: Stock Specific \n")

    }else if(M$PNVAlgorithm=="FisherySpecific"){

        cat("Proportion Not Vulnerable setting: Fishery Specific \n")

    }

    if(M$ShakerMethod == 1){

        cat("Using Shaker Method 1 \n")
    
    }else if(M$ShakerMethod == 4){
    
        cat("Using Shaker Method 4 \n")
    
    }

    if(M$IncompleteYearAlgorithm=="New"){

        cat("Use new incomplete brood year algorithm")

    }else if(M$IncompleteYearAlgorithm=="Historic"){

        cat("Use historic incomplete brood year algorithm")

    }
    
    if(M$RoundRecoveriesByTagCode== TRUE){
       
        cat("Round recoveries as in CAS CFiles \n")
        M$isReplicateCohShak <- TRUE

    }else{

        cat("Do NOT round recoveries")
        M$isReplicateCohShak <- FALSE


    }

    cat("If you need to change these settings, please chanbe options in the input list M and re-sun the program.\n")

    sink()


    d <- GetPSCFisheries(M)
    M2 <- append(M,d)

    if(M$isReplicateCohShak){

        d1 <- GetERAFisheries(M2)
        M2 <- append(M2,d1)

    }

    d2 <- GetCalendarYears(M2)
    M2 <- append(M2,d2)

    d3 <- GetERAStocks(M2)
    M2 <- append(M2,d3)

   


    return(M2)




    # Version of the ERA used
    #    Dim SettingsMsg As MsgBoxResult
    #    'verify settings with user before continuing to run program
    #    If LongTermAverage.Checked = True Then
    #        SettingsSelected = SettingsSelected & vbCr & vbCr & "Average Maturation Rate: Long Term Average"
    #        SaveSettings = "Avg Mat Rate: Long Term Avg; "
    #    Else
    #        SettingsSelected = SettingsSelected & vbCr & vbCr & "Average Maturation Rate: Last " & MatRateNumberBroods.NumBroodsUpDown.Value & " Complete Broods"
    #        SaveSettings = "Avg Mat Rate: Last " & MatRateNumberBroods.NumBroodsUpDown.Value & " Complete Broods; "
    #    End If
    #    If StockSpecificPNV.Checked = True Then
    #        SettingsSelected = SettingsSelected & vbCr & "PNV setting: Stock Specific"
    #        SaveSettings = SaveSettings & "Stock Specific PNV; "
    #    Else
    #        SettingsSelected = SettingsSelected & vbCr & "PNV setting: Fishery Specific"
    #        SaveSettings = SaveSettings & "Fishery Specific PNV; "
    #    End If
    #
    #    If ArithmeticMean.Checked = True Then
    #        SettingsSelected = SettingsSelected & vbCr & "Arithmetic Average Maturity Rates"
    #        SaveSettings = SaveSettings & "Arithmetic Avg Mat Rates; "
    #    Else
    #        SettingsSelected = SettingsSelected & vbCr & "Geometic Average Maturity Rates"
    #        SaveSettings = SaveSettings & "Geometic Avg Mat Rates; "
    #    End If
    #
    #    If ShakerMethod1Menu.Checked = True Then
    #        SettingsSelected = SettingsSelected & vbCr & "Shaker Method 1"
    #        SaveSettings = SaveSettings & "Shaker Method 1; "
    #    Else
    #        SettingsSelected = SettingsSelected & vbCr & "Shaker Method 4"
    #        SaveSettings = SaveSettings & "Shaker Method 4; "
    #    End If
    #
    #    If NewIncBYRadio.Checked = True Then
    #        SettingsSelected = SettingsSelected & vbCr & "Use new incomplete brood year algorithm"
    #        SaveSettings = SaveSettings & "New Incomplete Brood Year Algorithm; "
    #    Else
    #        SettingsSelected = SettingsSelected & vbCr & "Use historic incomplete brood year algorithm"
    #        SaveSettings = SaveSettings & "Historic Incomplete Brood Year Algorithm; "
    #    End If

    #   If chkRoundRecoveriesByTagCode.Checked = True Then
    #       SettingsSelected = SettingsSelected & vbCr & "Round recoveries as in CAS CFiles"
    #       SaveSettings = SaveSettings & "Round recoveries as in CAS CFiles; "
    #       isReplicateCohShak = True
    #   ElseIf chkDoNOTRoundRecoveriesByTagCode.Checked = True Then
    #       SettingsSelected = SettingsSelected & vbCr & "Do NOT round recoveries"
    #       SaveSettings = SaveSettings & "Do NOT round recoveries; "
    #        isReplicateCohShak = False
    #    End If

    #    SettingsSelected = SettingsSelected & vbCr & vbCr & "If you need to change these settings, please click cancel and make the changes in the Settings menu, otherwise click ok."
    #    SettingsMsg = MsgBox(SettingsSelected, MsgBoxStyle.OkCancel, "Settings Selected")
    #    If SettingsMsg = MsgBoxResult.Cancel Then
    #        Exit Sub
    #    End If
    #    DatabaseNameLabel.Visible = False
    #    PluginLabel.Visible = False
    #    Me.Cursor = Cursors.WaitCursor
    #    If CISDBConnection.State = ConnectionState.Closed Then
    #        CISDBConnection.Open()
    #    End If
    #    Call GetPSCFisheries()
    #    If isReplicateCohShak = True Then Call GetERAFisheries()
    #    Call GetCalendarYears()
    #    Call GetERAStocks()
    #    MenuStrip1.Visible = False
    #    LastYearCheckedListBox.Visible = True
    #    StockListView.Visible = True
    #    RunYearLabel.Visible = True
    #    StocksToRunLabel.Visible = True
    #    AllStocksCheckBox.Visible = True
    #    CalculateButton.Visible = True
    #    Me.Cursor = Cursors.Default



}




#' @title CalculateButton_Click 
#'
#' @description  
#' 
#' 
#'
#' @param M A list. Otput of StartCohortAnalysis_Click()
#'
#' @details  This function calls the maisn ERA routine. utputs a few log files if there are any errors relating
#'
#' @return A list containing all initial M items plus additional output from MainSub
#' 
#' 
#' 
#' @export
#'
#' @examples
#' 
#' 
CalculateButton_Click  <- function(M){(

   do.call(file.remove, list(list.files("../logs", full.names = TRUE)))

    if(is.na(M$LastYearCheckedListBox)){

        sink("../logs/YearSelectionError.log")
        cat("Error: You must select a year before continuing.\n")
        sink()

    }

    if(is.na(M$StockListBox)){

        sink("../logs/StockListError.log")
        cat("Error: You must select at least one stock before continuing.\n")
        sink()

    }

    LastCalendarYear <- M$LastYearCheckedListBox
    MaxCalendarYear <- M$LastCalendarYear
    
    ERAStockArray <- vector(length=length(M$StockListBox)) 

    if(length(M$isCombineAge2And3 != length(M$StockListBox)){
        
        sink("../logs/CombineAge.log")
        cat("Error: You must state if isCombineAge2And3 for each stock \n")
        sink()

    }

    if(length(M0$isCombineAge5And6 != length(M$StockListBox)){

        sink("../logs/CombineAge.log")
        cat("Error: You must state if isCombineAge5And6 for each stock \n")
        sink()
        
    }

    ERAStockArray <- as.character(M$ERAStockTable[M$StockListBox,1])
    
    NumStocks <- length(ERAStockArray)


    D <-list(     
        ERAStockArray=ERAStockArray, #array of Stock names (acronyms)
        NumStocks = NumStocks    
    )
    
    M<-append(M,D)

    D1<- MainSub(M)
    
    return(D1)

    # Original Version of the ERA 
    # If LastYearCheckedListBox.CheckedItems.Count = 0 Then
    #
    #        MsgBox("You must select a year before continuing.", , "Error")
    #        Exit Sub
    #    End If
    #    If StockListView.CheckedItems.Count = 0 Then
    #        MsgBox("You must select at least one stock before continuing.", , "Error")
    #        Exit Sub
    #    End If
    #    LastCalendarYear = LastYearCheckedListBox.CheckedItems(0)
    #    MaxCalendarYear = LastCalendarYear
    #    ReDim ERAStockArray(StockListView.CheckedItems.Count - 1)
    #    ReDim isCombineAge2And3(StockListView.CheckedItems.Count - 1)
    #    ReDim isCombineAge5And6(StockListView.CheckedItems.Count - 1)
    #    For stk As Integer = 0 To StockListView.CheckedItems.Count - 1
    #        ERAStockArray(stk) = StockListView.CheckedItems(stk).Text
    #        If StockListView.CheckedItems(stk).SubItems.Item(1).Text = Chr(254) Then 'checked
    #            isCombineAge2And3(stk) = True
    #        ElseIf StockListView.CheckedItems(stk).SubItems.Item(1).Text = Chr(168) Then 'unchecked
    #            isCombineAge2And3(stk) = False
    #        End If
    #
    #        If StockListView.CheckedItems(stk).SubItems.Item(2).Text = Chr(254) Then 'checked
    #            isCombineAge5And6(stk) = True
    #        ElseIf StockListView.CheckedItems(stk).SubItems.Item(2).Text = Chr(168) Then 'unchecked
    #            isCombineAge5And6(stk) = False
    #        End If
    #
    #        'for this to work, need to get OceanStartAge from SuperStock
    #        'If isCombineAge2And3(stk) = True Then
    #        '    If OceanStartAge <> 3 Then
    #        '        MsgBox("Coshak will NOT combine age 2 and 3 if start age in SuperStock table = 2")
    #        '        isCombineAge2And3(stk) = False
    #        '    Else
    #        '        UserSettings = UserSettings & "Combine age 2 and 3"
    #        '    End If
    #        'End If

    #        'If isCombineAge5And6(stk) = True Then
    #        '    If OceanStartAge <> 2 Then
    #        '        MsgBox("Coshak will NOT combine age 5 and 6 if start age in SuperStock table = 3")
    #        '        isCombineAge5And6(stk) = False
    #        '    Else
    #        '        UserSettings = UserSettings & "Combine age 5 and 6"
    #        '    End If
    #        'End If

    #    Next
    #    NumStocks = ERAStockArray.Length
    #    CalculateButton.Visible = False
    #    RunYearLabel.Visible = False
    #    LastYearCheckedListBox.Visible = False
    #    StockListView.Visible = False
    #    StocksToRunLabel.Visible = False
    #    AllStocksCheckBox.Visible = False
    #    Call MainSub()
    
   



}



#' @title MainSub 
#'
#' @description  Main routine that calculates the ERA, It calls a long list of subroutines 
#' 
#' 
#'
#' @param M A list. Output of StartCohortAnalysis_Click()
#'
#' @details
#'
#' @return A list ??? maybe something else? 
#' 
#' 
#' 
#' @export
#'
#' @examples
#' 
#' 
MainSub<-function(M){




    for(ERAStock in 1:M$NumStocks){


        # Testing run - to be deleted
        # ERAStock <- 1

    	#CW Rfresh note
    	#potentially something relating to "read from database" or read from user inputs
 		#read in or refresh all user and database specified inputs
 		# Me.Refresh() 


 		#set TimePeriod to 1 for now, adjust code later when timesteps are functional
        TimePeriod <- 1

        #' timestep is only used when printing to output table, I think it is redundant with TimePeriod
        TimeStep <- 1 
            
        #'set the current stock from the user selected ERAStock array
        CurrentStock <- M$ERAStockArray[ERAStock]
        
        #'reset LastCalendarYear to MaxCalendarYear for each stock, LastCalendarYear is adjusted in GETIMDATA for some stocks
        LastCalendarYear <- M$MaxCalendarYear
        
        #'Loop through CalendarYear shaker method and BroodYear Shaker method
		
		#This part of the code outputs details about a total mortality calculations to a log file
		#-------------------------------------------------------------------------
        # "logfile Note:  all catches and escapements were expanded to the maximum level of release found for all brood years by the variable named RelRatio(BY) = MaxRelease/CWTRelease(BY)
        #This is to prevent bias resulting from differential levels of marking between brood years when the sub-legal CNR mortalities and Ocean Exploitation Rate are calculated.  This is because
        # CWT catch is compared to Actual Catch to calculate the proportion of the total catch assigned to the CWT stock.  If one brood year is under- or over- represented, it will bias the over-all assignment of sub-legal mortalities.  RelRatio is removed. e.g. catch(BY) = catch(BY)/RelRatio(BY), in the data below and in the database tables.
         
        #the following found in the ERA_Output_BroodYearExploitationRate table can be reconstructed from the data below
        #Cohort is after natural mortality")
        #totalMortality = LandedCatch + LegalDropoffMortality + SublegalShakerMortalities + SublegalDropoffMortalities + LegalCNRMortality + LegalCNRDropoffs + SubLegalCNRMortality + SubLegalCNRDropoffs")
        #Escapement includes Cost Rec, Pers Use, Sub, and Terminal Fishery Stray but does not include Esc Stray
        #AEQLandedCatchTotalRun = (AEQ * LandedCatch) + Escape
        #AEQTotalMortTotalRun = (AEQ * TotalMort) + Escape
        #LandedCatchTerminalRun = Catch + Escape
        #TotalMortTerminalRun = TotalMort + Escape
        #AEQPreterminalLandedCatchAllAges = AEQLandedCatchTotalRun - TerminalLandedCatchAllAges - Escape
        #AEQPreterminalTotalMortsAllAges = AEQTotalMortTotalRun - TerminalTotalMortsAllAges - Escape
        #TerminalLandedCatchAllAges = Terminal LandedCatch
        #TerminalTotalMortsAllAges = Terminal TotalMort

        #This is not the data that is being written, isntead just headers to a csv
        #Log_TotalMortDetails_ID<-data.frame("ShakerMethod"=ShakerMethod, "BY"=BY, "Age"=Age, "Fishery"=Fishery, "Total"=Total, "LandedCatch"=LandedCatch, 
        #	"LegalDropoffMortality"=LegalDropoffMortality, 
        #	"SublegalShakerMortalities"= SublegalShakerMortalities, 
        #	"SublegalDropoffMortalities"=SublegalDropoffMortalities,
        #	"LegalCNRMortality"=LegalCNRMortality, "LegalCNRDropoffs"=LegalCNRDropoffs, 
        #	"SubLegalCNRMortality"=SubLegalCNRMortality, 
        #	"SubLegalCNRDropoffs"=SubLegalCNRDropoffs, 
        #	"CohortAfterNatMort"=CohortAfterNatMort, "TermRun"=TermRun,
        #    "Escape"=Escape, "CanadaEscStray"=CanadaEscStray, "USEscStray"=USEscStray, 
        #    "AEQ"=AEQ, "RelRatio"=RelRatio)

         
        #This part of the code writes out another log file for fish that are observed to be older than the user set maximum age  
        #-------------------------------------------------------------------------  
         
        #build a log for fish that are observed to be older than the user set maximum age -- the following are older than MaxAge or younger than OceanStartAge specified in the CIS table named SuperStock
        Log_OlderThanMaxAge_ID <- paste0(CurrentStock,"_OlderThanMaxAge.log")
        sink(Log_OlderThanMaxAge_ID)
        cat("the following are older than MaxAge or younger than OceanStartAge specified in the CIS table named SuperStock.\n")
        cat("ShakerMethod BY age fishery \n")
        sink()
            
        #Log_OlderThanMaxAge_ID <- data.frame("ShakerMethod"ShakerMethod, "BY"=BY, "age"=age, "fishery"=fishery)
		#-------------------------------------------------------------------------  
        
        #I think these are only here to ensure that testing and comparison with CAs is efficient
        M$isTraceCalc <- FALSE
        M$isTraceByBroodYr <- TRUE
        M$isTraceByCalendarYr <- FALSE
        M$traceThisShakerMethod <- "C"

        if(isTraceCalc){

        	traceThisYear <- 1981
            traceThisFishery <- 58
            traceThisAge <-2
        	
        	#the vb code then creates and leave open a bunch of debug files 

            debug_calcEstmCohrtID <- list()
            debug_CalYrCatchID <- list()
            debug_AvgMatRteID <- list()
            debug_totCatAgeID <- list()
            debug_EncounterRateID <- list()
            debug_LegalDropoffID <- list()
            debug_CalYrShakersID <- list()
            debug_ShakerID <- list()
            debug_subLegalCNRID <- list()
            debug_LegalCNRID <- list()
            debug_CatchID <- list()
            debug_CohortID <- list()
            debug_Cohort_IncompleteBroodID <- list()
            debug_EscapeID <- list()
            debug_CNRNoDirID <- list()
            debug_MatRteID <- list()
            debug_SumMatAgeCatID <- list()
            debug_terminalFlagID <- list()
            debug_matShakersID <- list()
            debug_terminalCatchID <- list()


        }

        for(ShakCalcFlg in 1:2){

            #to be deleted
            ShakCalcFlg<- 1            

        	#loop through once using the brood year method and then again using the calendar year method

        	#This version does not need a progress bar
         	#SetupProgressBar()

         	if(ShakCalcFlg == 1){

         		ShakerMethod <- "C"

         	}else if(ShakCalcFlg == 2) {

         		 ShakerMethod <- "B"

         	}

         	#reset CASStockString between shaker methods'
            CASStockString <- NA
                
            #reset LastCompleteBroodYear to nothing between shaker methods and stocks

            LastCompleteBroodYear <- NA

            #reset pass between shaker methods and stocks
            pass <- 0
            
            #update stock label as progress is made - use this inestead of progerss bar
            ERAStockLabel.Text <- paste("Stock:", CurrentStock, "(", ERAStock , "of", NumStocks, ") Shaker Method:", ShakerMethod)
            print(ERAStockLabel.Text)
            #ERAStockLabel.Visible <- TRUE
            #lblStatus.Visible <- FALSE

            CASStockString<-GetCASStocks(curr_stk=CurrentStock,dbse=M$datbse)
            
            #Get TermNetSwitchAge,OceanStartAge ,  MaxAge, SuperStock 
            D<-GetSuperStockData(CurrentStock,M$datbse)
            TermNetSwitchAge <- D$TermNetSwitchAge
            OceanStartAge  <- D$OceanStartAge 
            MaxAge  <- D$MaxAge 
            SuperStock  <- D$SuperStock

                
            if(M$isCombineAge2And3[ERAStock]){
            	
            	if(D$OceanStartAge != 3){
            		
            		print(paste("Coshak will NOT combine age 2 and 3 for",CurrentStock, "if OceanStartAge in SuperStock table = 2.  Hint:  Look in ERA_Stock to find the corresponding SuperStock."))
            		M$isCombineAge2And3[ERAStock] <- FALSE
            	
            	}else if(!M$isCombineAge5And6[ERAStock]){

            		if(M$ShakCalcFlg == 1){
            			#IDK -  what is this line doing? Just resetting the user setting?
            			# this seems unnecessary to me. 
            			#UserSettings = SaveSettings & "Combine age 2 & 3"
                        M$isCombineAge2And3[ERAStock] <- TRUE
            		}
            	}
            }

            if(M$isCombineAge5And6[ERAStock]){
            	if(D$OceanStartAge!= 2){
            		 print(paste("Coshak will NOT combine age 5 and 6 ", CurrentStock, " if OceanStartAge in SuperStock table = 3.  Hint:  Look in ERA_Stock to find the corresponding SuperStock."))
            		M$isCombineAge5And6[ERAStock] = FALSE
            	}else if(!M$isCombineAge2And3[ERAStock]){

            		if(M$ShakCalcFlg == 1){
            			#IDK -  what is this line doing? Just resetting the user setting?
            			# this seems unnecessary to me. 
            			#UserSettings = SaveSettings & "Combine age 5 & 6"
                        M$isCombineAge5And6[ERAStock] = TRUE
            		}
            	}
            }

            if(M$isCombineAge2And3[ERAStock]& M$isCombineAge5And6[ERAStock]){
                if(ShakCalcFlg == 1){
                  # UserSettings = SaveSettings & "Combine age 2 & 3; Combine age 5 & 6"  
                }
            }

            print("Get First and Last Brood Year")
            GetFirstAndLastBY(dbse=M$datbse,
                            CASStockString=CASStockString,
                            LastCalendarYear,
                            OceanStartAge=D$OceanStartAge)
            GetMaxReleaseSize()
            RedimensionArrays()

            print("Get Tagged Release By Brood")
            GetTaggedReleaseByBrood()
            GetInterDamSurvival()
            GetSurvivalRates()
            GetWithinBYWeightFlagAndPNVRegionAndAvgMatRates() #get within by flag, average mat rates, PNVregion
            
            print(" Get PSL Data")
            
            GetIMData(CurrentStock, PNVRegion)
            if(StockSpecificPNV){
                GetMeanLength()
                GetSizeLimitLengthVulnerable()
                CreatePNV()
            }
            #        Call GetMeanLength()
            #        Call GetSizeLimitLengthVulnerable()
            #        Call CreatePNV()
            #    End If
            #    Call SetTerminalFishery()

            #lblStatus.Text = " Get First and Last Brood Year"
            #    lblStatus.Visible = True
            #    Me.Refresh()
            #    Call GetFirstAndLastBY()
            #    Call GetMaxReleaseSize()
            #    Call RedimensionArrays()
            #    lblStatus.Text = " Get Tagged Release By Brood"
            #    lblStatus.Visible = True
            #    Me.Refresh()
            #    Call GetTaggedReleaseByBrood()
            #    Call GetInterDamSurvival()
            #    Call GetSurvivalRates()
            #    Call GetWithinBYWeightFlagAndPNVRegionAndAvgMatRates() 'get within by flag, average mat rates, PNVregion
            #    lblStatus.Text = " Get PSL Data"
            #    lblStatus.Visible = True 
            

            

        } #next ShakCalcFlg

    } #next ERAStock
}

    










