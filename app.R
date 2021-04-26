# Load R packages
library(tidyverse)
require(shiny)
require(shinythemes)
library(plotly)
library(gsheet)
  # Define UI
  ui <- fluidPage(theme = shinytheme("paper"),
                  navbarPage("Political Compass"),
                  tabPanel("VentoFlame",
                           sidebarPanel(
                             h4("Lib Unity"),
                             p("Se volete contribuire a questo survey potete eseguire il test su", HTML("<a href='https://www.politicalcompass.org' target='_blank'>PoliticalCompass.com</a>"), "e inserire le vostre coordinate su questo", HTML("<a href='https://docs.google.com/spreadsheets/d/1_lqW4dMcublen0_iYm4OI6_e4B8zh8C_L1ABf5VcPgQ/edit?usp=sharing' target='_blank'>Google Sheet</a>"),". Ricordatevi soltanto di inserire un apostrofo prima della cordinata (E.g. scirvete '6 per indicare 6)."),
                             actionButton('ok','Reload'),
                             
                             #img(src = "libuni.png", height = 600, width = 372)
                             ),
                           
                           mainPanel(
                             plotlyOutput(outputId = "PC")
                             )
                           )
                  )
                  


  
  server <- function(input, output) {
    testo <- read_delim(gsheet2text("https://docs.google.com/spreadsheets/d/1_lqW4dMcublen0_iYm4OI6_e4B8zh8C_L1ABf5VcPgQ/edit?usp=sharing"),
                        escape_double = F, delim = ",", locale = locale(decimal_mark = ","), 
                        trim_ws = TRUE)
  
    output$PC <- renderPlotly({
      plot_ly(data = testo, y = ~soclibauth, x= ~ecoleftright, type = 'scatter', marker = list(color = 'MidnightBlue'),
              text = ~paste(testo$nome, testo$cognome)) %>% 
        layout(height=800,
               width=800,
               title = "Authoritarian",
               xaxis = list(
                 title = "Libertarian",
                 nticks = 0
               ),
               yaxis = list(
                 scaleanchor = "1:1",
                 title = ""
                 ),
               shapes = list(list(type=rect, 
                                  x0 = -10, 
                                  x1 = 0, 
                                  y0=-10, 
                                  y1=0, 
                                  fillcolor='lightgreen', 
                                  layer='below'),
                             list(type=rect, 
                                  x0 = 0, 
                                  x1 = 10, 
                                  y0 = -10, 
                                  y1 = 0, 
                                  fillcolor='Plum', 
                                  layer='below'),
                             list(type=rect, 
                                  x0 = 0, 
                                  x1 = 10, 
                                  y0 = 0, 
                                  y1 = 10, 
                                  fillcolor='SteelBlue', 
                                  layer='below'),
                             list(type=rect, 
                                  x0 = -10, 
                                  x1 = 0, 
                                  y0 = 0, 
                                  y1 = 10, 
                                  fillcolor='IndianRed ', 
                                  layer='below')))                                                                    
      
    })
    
  
    
    upload <- function(testo){
      testo <- read_delim(gsheet2text("https://docs.google.com/spreadsheets/d/1_lqW4dMcublen0_iYm4OI6_e4B8zh8C_L1ABf5VcPgQ/edit?usp=sharing"),
                          escape_double = F, delim = ",", locale = locale(decimal_mark = ","), 
                          trim_ws = TRUE)
    }
    
    datas <- eventReactive(input$ok,{
      upload(testo)
      
    })
    
    
  }
  
  # Create Shiny app ----
  shinyApp(ui = ui, server = server)
  