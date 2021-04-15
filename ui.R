
library(shiny)
library(shinydashboard)
library(nbastatR)
library(data.table)
library(tidyverse)

# dashboardPage(
#     dashboardHeader(title='Shot Map'),
#     dashboardSidebar(),
#     dashboardBody(
#         box(
#             htmlOutput("team_select"),
#             htmlOutput("player_select")
#         )
#     )
# )

fluidPage(
    titlePanel("Shot Map"),
    sidebarPanel(
        uiOutput("select_team"),
        uiOutput("select_player")
    ),
    mainPanel(
        plotOutput('shot_map')
    )
)