#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(nbastatR)
library(data.table)
library(tidyverse)
library(ggforce)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    # nbastatR::assign_nba_teams()
    # teams <- df_dict_nba_teams %>%
    #     filter(isNonNBATeam == 0) %>%
    #     filter(idConference > 0) %>%
    #     as.data.frame()
    # 
    # data <- nbastatR::teams_shots(
    #     team_ids = teams$idTeam,
    #     seasons = 2021,
    #     return_message = FALSE
    # )
    
    teams <- fread('teams_data.csv')
    data <- fread('shot_data.csv')
    
    output$select_team <- renderUI({
        selectInput("team", "Select Team", teams$nameTeam)
    })
    
    output$select_player <- renderUI({
        selectInput("player", "Select Player", 
                    unique(data[data$nameTeam == input$team, 'namePlayer']))
    })
    
    surround <- data.frame(
        x = c(-250, -250, 250, 250),
        y = c(-52, 418, 418, -52)
    )
    
    key <- data.frame(
        x = c(-60, -60, 60, 60),
        y = c(-52, 150, 150, -52)
    )
    
    bigger_key <- data.frame(
        x = c(-80, -80, 80, 80),
        y = c(-52, 150, 150, -52)
    )
    
    siz <- 1.2
    
    output$shot_map <- renderPlot({
        ggplot() +
            geom_point(data=data[data$nameTeam == input$team &
                                     data$locationY <= 418 & 
                                     data$namePlayer == input$player,],
                       aes(x=locationX,y=locationY, color=isShotMade, shape=isShotMade)) +
            geom_polygon(data=surround, mapping=aes(x=x, y=y), fill=NA, color='black',size=siz) +
            geom_polygon(data=key, mapping=aes(x=x, y=y), fill=NA, color='black',size=siz) +
            geom_arc(aes(x0=0, y0=150, r=60, start=-pi/2, end=pi/2),size=siz) +
            geom_arc(aes(x0=0, y0=150, r=60, start=pi/2, end=3*pi/2), linetype = 'longdash',size=siz) +
            geom_segment(aes(x=-220, xend=-220, y=-52, yend=-52+140), color='black',size=siz) +
            geom_segment(aes(x=220, xend=220, y=-52, yend=-52+140), color='black',size=siz) +
            geom_polygon(data=bigger_key, mapping=aes(x=x, y=y), fill=NA, color='black',size=siz) +
            geom_arc(aes(x0=0, y0=0, r=237.5, start=-((pi/2)-tan(88/220)+.04), end=((pi/2)-tan(88/220)+.04)), color='black',size=siz) +
            geom_arc(aes(x0=0, y0=418, r=60, start=pi/2, end = 3*pi/2),size=siz) + 
            geom_arc(aes(x0=0, y0=418, r=20, start=pi/2, end = 3*pi/2),size=siz) + 
            geom_segment(aes(x=-30, xend=30, y=-12, yend=-12), size=2) +
            geom_circle(aes(x0=0, y0=0, r=10),size=siz) +
            geom_arc(aes(x0=0, y0=0, r=40, start=-pi/2, end=pi/2),size=siz) +
            geom_segment(aes(x=-40, xend=-40, y=-12, yend=0),size=siz) + 
            geom_segment(aes(x=40, xend=40, y=-12, yend=0),size=siz) + 
            theme_bw() +
            theme(
                axis.ticks = element_blank(), 
                axis.text = element_blank(),
                axis.title = element_blank(),
                legend.position = 'bottom'
            )
    })
})
