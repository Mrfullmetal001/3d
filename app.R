#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(bio3d)
library("rgl")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("3D"),

    # Sidebar with a slider input for number of bins 
        sidebarPanel(
            fileInput("pdbfile", "Choose PDB  File"
            ),
        mainPanel(
          tableOutput("contents")
        )
    
    )
)

    


# Define server logic required to draw a histogram
server <- function(input, output) {
    output$contents <- renderTable({
        inFile <- input$pdbfile
        
        if (is.null(inFile))
            return(NULL)
        
        pdb<-read.pdb(inFile$datapath)
        x<-pdb$atom$x
        y<-pdb$atom$y
        z<-pdb$atom$z
        pdbdata<-data.frame(x,y,z)
        init <- function(new.device = FALSE, bg = "white", width = 640) { 
            if( new.device | rgl.cur() == 0 ) {
                rgl.open()
                par3d(windowRect = 50 + c( 0, 0, width, width ) )
                rgl.bg(color = bg )
            }
            rgl.clear(type = c("shapes", "bboxdeco"))
            rgl.viewpoint(theta = 15, phi = 20, zoom = 0.7)
        }
        init()
        rgl.spheres(pdbdata$x,pdbdata$y,pdbdata$z , r = 0.5, color = "green") 
        rgl.bbox(color=c("#333377","black"), emission="#333377",
                 specular="#3333FF" ) 
        
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
