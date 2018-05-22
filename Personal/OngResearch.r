if("ggplot2" %in% rownames(installed.packages()) == FALSE)
{install.packages("ggplot2", repos="http://cran.rstudio.com/")}
if("reshape2" %in% rownames(installed.packages()) == FALSE)
{install.packages("reshape2", repos="http://cran.rstudio.com/")}
if("dplyr" %in% rownames(installed.packages()) == FALSE)
{install.packages("dplyr", repos="http://cran.rstudio.com/")}
library(ggplot2)
library(reshape2)
library(dplyr)

# TODO: Write a function in R to make a swimmers plot of how long patients were on a particular therapy?
# TODO: Write a function in R to plot Kaplan-Meier survival curves.

#' Title calculateDates
#'    Calculates the difference in time between two dates when given pairs of start and end dates.
#'    Specifying a date of "Current" will replace the entry with the time at code compilation.
#' @param date_list a list of string vectors that represent dates. Must be an even number of columns.
#' @param date_format a matrix/list of integers representing days elapsed between each pair of columns in date_list.
#'
#' @return matrix/list of integers representing days elapsed between each pair of columns in date_list.
#'
#' @examples calculateDates(list("12/14/96","12/14/97"))
calculateDates <- function(date_list, date_format = "%m/%d/%y")
{
  # note: supply date_list in format of start, end, start end, etc.
  stopifnot(!(length(date_list) %% 2), length(date_list) > 1) # an even list, greater than 1
  tryCatch(matrix(unlist(date_list),ncol=length(date_list)),
           warning = function(w){stop("List cannot be jagged - all columns must be same length.")})
  date_list <- lapply(date_list, function(x)
    gsub("current|Current", format(as.Date(substring(Sys.time(),1,10)),date_format),x))
  start_dates <- date_list[which(as.logical((1:length(date_list)) %% 2))] # grab odd indices of date_list
  end_dates <- date_list[which(!as.logical((1:length(date_list)) %% 2))] # grab evens indices of date_list
  start_dates <- sapply(start_dates, function(x) as.Date(x,date_format)) # format dates
  end_dates <- sapply(end_dates, function(x) as.Date(x,date_format))
  result <- end_dates - start_dates
  unname(result)
  return(result)
}

# generate random data
# set.seed(1996)
numParticipants <- 20
randDates <- format(sample(seq(as.Date('1/1/10',"%m/%d/%y"), # range of data
                               as.Date('1/1/12',"%m/%d/%y"), by="day"), numParticipants),"%m/%d/%y")
randTreatmentLength <- sample(60:365,numParticipants, replace=TRUE)
randResponseLength <- sapply(randTreatmentLength, function(x) sample(20:(x-20),1)) #guaranteed to be shorter
randResponseStartOffset <- sapply(randTreatmentLength - randResponseLength, function(x) sample(15:x, 1))

df <- data.frame(
  Patient.ID = 1:numParticipants,
  Disease.Stage = sample(1:4, numParticipants, replace = TRUE),
  Response.Type = sample(c("Complete", "Partial"), numParticipants, replace = TRUE),
  Therapy.Start = randDates,
  Therapy.End = unlist(format(as.Date(randDates,"%m/%d/%y") + randTreatmentLength,"%m/%d/%y")),
  Response.Start = unlist(format(as.Date(randDates,"%m/%d/%y") + randResponseStartOffset,"%m/%d/%y")),
  Response.End = format(as.Date(randDates,"%m/%d/%y")
                        + randResponseStartOffset
                        + randResponseLength,format="%m/%d/%y"),
  stringsAsFactors = FALSE)

dat <- df %>% select(Patient.ID, Disease.Stage, Response.Type)
dat <- dat %>% mutate(
  Response.Start = drop(calculateDates(list(df$Therapy.Start,df$Response.Start))),
  Response.End = drop(calculateDates(list(df$Therapy.Start,df$Response.End))),
  Therapy.Length = drop(calculateDates(list(df$Therapy.Start,df$Therapy.End))),
  Durable = sapply(drop(calculateDates(list(df$Response.Start,df$Response.End)) > 183),
                   function(x) if(x) return(-1) else return(NA)), # 6 months = 183 days
  Continued = sample(c(1,NA),numParticipants, replace = TRUE)
)
# Order Patient.IDs by Therapy.Length
dat$Patient.ID <- factor(dat$Patient.ID, levels=dat$Patient.ID[order(dat$Therapy.Length)])
# Scale the placement of the durability marker (will change with size of x-axis)
dat$Durable <- dat$Durable*as.integer(substring(as.character(max(dat$Therapy.Length)),1,1))*3
# cast and melt so as to be able to supply symbol coordinates
dat <- dcast(dat, Patient.ID + Disease.Stage + Response.Start + Response.End + Durable
             + Therapy.Length + Continued ~ Response.Type, value.var = "Response.Start")
dat.m <- melt(dat, id=names(dat)[!(names(dat) %in% c("Complete","Partial", "Response.End", "Durable"))])
dat.m <- dat.m[!is.na(dat.m$value),] # remove NA

ggplot(dat,
       aes(Patient.ID, Therapy.Length)) +
  geom_bar(stat="identity", aes(fill=factor(Disease.Stage)), width=0.7) +
  geom_point(data=dat.m,  aes(Patient.ID, value,
                              colour=variable, shape=variable), size=3) +
  geom_segment(data=dat.m %>% filter(Continued == 1),
               aes(x=Patient.ID, xend=Patient.ID, y=Therapy.Length + 0.1, yend=Therapy.Length + 10),
               arrow=arrow(type="closed", length=unit(0.1,"in"))) +
  coord_flip(ylim=c(-3,max(dat$Therapy.Length))) +
  # http://www.sthda.com/sthda/RDoc/images/points-symbols.png
  scale_shape_manual(values=c(8,15,16,10))+
  scale_fill_manual(values=hcl(seq(15,375,length.out=5)[1:4],100,70)) +
  scale_colour_manual(values=c("red","black","forestgreen","darkgreen")) +
  scale_y_continuous(breaks=seq(0,max(dat$Therapy.Length),30)) +
  labs(fill="Disease Stage", colour="", shape="", x="Subject Received Study Drug") + theme_bw() +
  theme(panel.grid.minor=element_blank(),panel.grid.major=element_blank(),
        axis.text.y=element_blank(),axis.ticks.y=element_blank())

# dput(dat)
