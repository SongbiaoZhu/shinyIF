install.packages('rsconnect')
rsconnect::setAccountInfo(name = 'songbiaozhu',
                          token = 'C4E9DEFAC55C200BC5E4BF634D754503',
                          secret = 'rNit4DC3TUg62e6vNtUWwWyS1I21U5aXqOCIYF1V')

library(rsconnect)
rsconnect::deployApp('E:\\analysis\\shinyIF')
