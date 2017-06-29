# sources: Center for American Progress State-wide Medicaid insurance coverage losses for 2026
# CAP link: https://www.americanprogress.org/issues/healthcare/news/2017/06/27/435112/coverage-losses-state-senate-health-care-repeal-bill/
# MACPAC full enrollment numbers for fiscal year 2013: https://www.macpac.gov/publication/medicaid-full-year-equivalent-enrollment-by-state-and-eligibility-group-2/
# Google docs version of CAP spreadsheet: https://docs.google.com/spreadsheets/d/1OzV8bQ5YDCd-1MIHdea5jLGgYr-JFC8VZU66FZYM2ZQ/edit?usp=sharing
# Geofacet vingette: https://hafen.github.io/geofacet/
# Geofacet Github repo: https://github.com/hafen/geofacet

install.packages("devtools")
# install geofacet dev version from github
devtools::install_github("hafen/geofacet")
install.packages("ggplot2","googlesheets")
library(ggplot2)
library(googlesheets)
library(reshape2)
library(plyr)
library(geofacet)
# the googlesheets package allows us to grab the data from the google sheet above
# that sheet is called "CAP_BCRA" and the tab we want is "for_r"

gs_ls() # lists your sheets, in order of last edited. this sheet should be near the top.
# in order for this to work, you need to copy the sheet into your own drive folder and "make it your own"
# you'll also have to authenticate your google account if you haven't already used googlesheets
# it will give you directions for copy/pasting a URL into your browser, if it doesn't go automatically.
# then you will authenticate, and it'll give you a hash to paste back in to R
# after doing that, you should be all set

# grab the sheet and makes it an object that we can refer to later
CAP_BCRA <- gs_title("CAP_BCRA")

# read in the data and turn it into a data frame, with the top column as our variable labels
cap_bcra_state_losses <- gs_read(CAP_BCRA, ws = "for_r", stringsAsFactors=FALSE)
# if you edit the sheet, it's very important that the name and code columns stay named as they are

#limit the dataset in r to just the columns we want (those with percentages)
cap_bcra_state_losses_pct <- cap_bcra_state_losses[,c(1,2,5,8,11,14,17)]

# rename our columns so they read better on the visualization
cap_bcra_state_losses_pct <- rename(cap_bcra_state_losses_pct, 
                                    c("Total Pct Lost" = "Total Non-Elderly",
                                      "Adult Pct Lost" = "Adult",
                                      "Children Pct Lost" = "Children",
                                      "Disabled Pct Lost" = "Disabled",
                                      "Elderly Pct Lost" = "Elderly"))

#convert to percentages while keeping the variable continuous (don't do this in excel/ghseets)
cap_bcra_state_losses_pct$`Total Non-Elderly` <- cap_bcra_state_losses_pct$`Total Non-Elderly`*100
cap_bcra_state_losses_pct$Adult <- cap_bcra_state_losses_pct$Adult*100
cap_bcra_state_losses_pct$Children <- cap_bcra_state_losses_pct$Children*100
cap_bcra_state_losses_pct$Disabled <- cap_bcra_state_losses_pct$Disabled*100
cap_bcra_state_losses_pct$Elderly <- cap_bcra_state_losses_pct$Elderly*100

# transform the data from wide data into long data; geofacet needs it long for visualization
# have to make the ID a combination of state and abbreviation, so those stay intact for the multiple rows
cap_bcra_state_losses_pct <- melt(cap_bcra_state_losses_pct, id = c("name","code"))

# create the visualization using geofacet package
ggplot(cap_bcra_state_losses_pct, aes(variable, value, fill = variable)) +
  geom_col() +
  scale_y_continuous(limits = c(0,50), breaks = c(10, 20, 30, 40, 50)) +
  coord_flip() +
  theme_bw() +
  labs(title = "Percent Loss in Health Ins Coverage for 2026, by State and Type",
       caption = "Data Source: Center for American Progress & MACPAC.
       ID, LA, RI inestimable due to unreliable MACPAC data on total enrollees.
       Visualization by @NateApathy",
       x = "Coverage Type",
       y = "Percent of Medcaid Enrollees Losing Coverage") +
  facet_geo(~ code, label = "name")
