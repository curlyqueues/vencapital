#reads the data into a data.frame called "Data". 
Data = read.csv("/Users/Jordan/Desktop/venturedata0721.csv", stringsAsFactors = FALSE)

#Changes Data into a data.table. I like them better. To find out more, run ?data.table or ?data.frame
library(data.table)
Data = data.table(Data)

#Just focus on one guy for now! The "3" means third column. with=FALSE means use column 3, not the number 3. 
#For the fourth column, replace 3 with 4.
OneGuy = Data[,30, with=FALSE]
setnames(OneGuy, "theData") #sets column name to "theData". Necessary for next step

#chops the table up in rows of 5 and turns each of those five into a column. So it would turn a 
# 1x50 (column x row) table into a 5 x 10.
OneGuy[,1, with=FALSE] #just shows the one guys data all in a column by itself.
OneGuyMatrix = matrix(OneGuy$theData, ncol=5, byrow=TRUE)
OneGuyDataTable = data.table(OneGuyMatrix)

## Gets rid of empty rows. The apply function is saying "Go through each row, if any cell in that row has anything 
#besides "" (i.e. nothing), then return TRUE. All "TRUE"s means use that row. Any FALSE gets omitted
OneGuyDataTable = OneGuyDataTable[apply(OneGuyDataTable, 1, function(x) any(x != ""))]
setnames(OneGuyDataTable, c("Date", "Year", "Company", "InvestmentInfo", "InvesterInfo"))

#Combine the date and year
FullDate = paste(OneGuyDataTable$Date, OneGuyDataTable$Year, sep = " ")
FullDate = as.Date(FullDate, format="%d-%b %Y")
OneGuyDataTable$FullDate = FullDate
setkey(OneGuyDataTable, FullDate) #Order by date, earliest to latest

OneGuyDataTable #see everything

RoundTypes = c("undisclosed amount Seed", "Seed", "Angel", "Venture", paste0("undisclosed amount Series ", c(LETTERS[1:7])),"undisclosed amount Venture", "undisclosed amount Angel",paste0("Series ", c(LETTERS[1:7]))) #lots of variations, may be worth sorting by lead investor later on
Type = sapply(OneGuyDataTable$InvestmentInfo, function(y) RoundTypes[which(sapply(RoundTypes, function(x) grepl(x, y)))])
Type = unlist(lapply(Type, function(x) ifelse(length(x) == 0, "Other", x)))
OneGuyDataTable$Type = Type

Money = lapply(OneGuyDataTable$InvestmentInfo, function(x) strsplit(x, " ")[[1]][1])

MoneyToNumber = function(String)
{
  String = sub("\\$", "", String)
  Multipliers = c("k", "M", "B")
  PowerOfTen = 1000 ^ which(Multipliers == gsub("*[0-9|.]", "", String))
  Number = as.numeric(gsub("[A-Z|a-z]*", "", String))
  return(Number * PowerOfTen)
}

Amount = mapply(MoneyToNumber, String = Money)
Amount = lapply(Amount, function(x) ifelse(length(x) == 0, NA, x))
OneGuyDataTable$Amount = unlist(Amount) #R does weird things with data tables when formatted as a list
#OneGuyDataTable[,mean(Amount),keyby=Type] to see averages 

