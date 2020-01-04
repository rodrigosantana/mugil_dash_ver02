######################################################################
## Description: Dashboard para Gestao da Pesca de Tainha Mugil liza,
## estoque Sudeste e Sul do Brasil...
##
## Maintainer: OCEANA Brasil
## Author: Rodrigo Sant'Ana
## Created: Qui Mar 24 15:38:33 2016 (-0300)
## Last-Updated: sáb jan 27 00:22:18 2018 (-0200)
##           By: Rodrigo Sant'Ana
##     Update #: 204
##
## URL:
##
### Commentary: Modelo de dashboard baseado em
### http://www.showmeshiny.com/nrl-dashboard/
##
### Code:
######################################################################

########################################################################
### Pacotes necessarios
library(shiny)
library(plotly)
library(shinydashboard)

########################################################################
## Interface do usuario (ui.R)...
### Title:

header <- dashboardHeader(
    title = img(src="logo_pt.png", width = 200)
    ## dropdownMenuOutput("messageMenu")
)

### SideBar:
sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Séries Temporais de Dados", tabName = "cap",
                 icon = icon("line-chart")),
        ## menuItem("Série SST", tabName = "sst",
        ##          icon = icon("fa fa-circle")),
        menuItem("Modelos de DB Bayesianos", tabName = "db",
                 icon = icon("mortar-board")),
        menuItem("Pontos de Referência", tabName = "PBR",
                 icon = icon("star")),
        menuItem("Sobre", tabName = "about",
                 icon = icon("fa fa-info-circle"))
    )
)


### Dashboard:
body <- dashboardBody(
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css",
                  href = "custom.css")
        ),

### Tabintes:
    tabItems(
########################################################################
### TAB 1 = DADOS DE CAPTURA E CPUE...
        tabItem(tabName = "cap",
                fluidRow(
                    box(width = 12,
                            title = "Série Temporal de Captura",
                            solidHeader = TRUE, status = "primary",
                        plotlyOutput(outputId = "prod"))),
                fluidRow(
                    #mainPanel(
                        box(width = 12,
                            title = "Séries Temporais de CPUE Nominal",
                            solidHeader = TRUE, status = "primary",
                            tabsetPanel(type = "tabs",
                                tabPanel("Série I",
                                         plotlyOutput("cpue1")),
                                tabPanel("Série II",
                                         plotlyOutput("cpue2")),
                                tabPanel("Série III",
                                         plotlyOutput("cpue3")),
                                tabPanel("Série IV",
                                         plotlyOutput("cpue4")),
                                tabPanel("Série V",
                                         plotlyOutput("cpue5")),
                                tabPanel("Série VI",
                                         plotlyOutput("cpue6")),
                                tabPanel("Série VII",
                                         plotlyOutput("cpue7")),
                                tabPanel("Série VIII",
                                         plotlyOutput("cpue8")),
                                tabPanel("Série IX",
                                         plotlyOutput("cpue9")),
                                tabPanel("Série X",
                                         plotlyOutput("cpue10")),
                                tabPanel("Série XI",
                                         plotlyOutput("cpue11"))
                                )
                            )),
                    fluidRow(
                        box(width = 6,
                            title = "Série Temporal de Captura",
                            solidHeader = TRUE, status = "warning",
                            dataTableOutput(outputId = "Summ.cap")),

                        box(width = 6,
                            title = "Séries Temporais de CPUE Nominal",
                            solidHeader = TRUE, status = "warning",
                            dataTableOutput(outputId = "Summ.cpue")))
                ),

########################################################################
### TAB 2 = DB Bayesianos...
      tabItem(tabName = "db",
              fluidRow(
                  box(width = 4,
                      title = "Predição de Cenários",
                      solidHeader = TRUE, status = "primary",
                      "Considere um cenário de predição para",
                      "os próximos 8 anos de pesca de Tainha",
                      "no Sudeste e Sul do Brasil.", br(), br(),
                      sliderInput(inputId = "cap01",
                                  label = paste("Selecione um cenário",
                                                "de captura para os",
                                                "2018 e 2019:",
                                                sep = " "),
                                  min = 0, max = 10000, value = 3000),
                      sliderInput(inputId = "cap02",
                                  label = paste("Selecione um cenário",
                                                "de captura para os",
                                                "2020 e 2021:",
                                                sep = " "),
                                  min = 0, max = 10000, value = 3000),
                      sliderInput(inputId = "cap03",
                                  label = paste("Selecione um cenário",
                                                "de captura para os",
                                                "2022 e 2023:",
                                                sep = " "),
                                  min = 0, max = 10000, value = 3000),
                      sliderInput(inputId = "cap04",
                                  label = paste("Selecione um cenário",
                                                "de captura para os",
                                                "2024 e 2025:",
                                                sep = " "),
                                  min = 0, max = 10000, value = 3000)
                      ## sliderInput(inputId = "cap05",
                      ##             label = paste("Selecione um cenário",
                      ##                           "de captura para os",
                      ##                           "2026 e 2027:",
                      ##                           sep = " "),
                      ##             min = 0, max = 10000, value = 3000)
                      ),
                  box(width = 8,
                      title =
                          "Cenário predito para pesca de Tainha - Modelo 0",
                      solidHeader = TRUE, status = "primary",
                      plotlyOutput(outputId = "pred0"),
                      "Linha sólida roxa - estimação P = B/K para a",
                      "faixa temporal de dados; Faixa roxa - Intervalo",
                      " de credibilidade de 95%; Linha sólida azul -",
                      " predição futura baseada na média dos",
                      "Parâmetros do modelo.")
              ),
              fluidRow(
                column(width = 4),
                box(width = 8,
                    title =
                        "Cenário predito para pesca de Tainha - Modelo 2",
                    solidHeader = TRUE, status = "primary",
                    plotlyOutput(outputId = "pred1"),
                    "Linha sólida roxa - estimação P = B/K para a",
                    "faixa temporal de dados; Faixa roxa - Intervalo",
                    " de credibilidade de 95%; Linha sólida azul -",
                    " predição futura baseada na média dos",
                    "Parâmetros do modelo.")
              ),
              fluidRow(
                column(width = 4),
                box(width = 8,
                    title =
                        "Cenário predito para pesca de Tainha - Modelo 4",
                    solidHeader = TRUE, status = "primary",
                    plotlyOutput(outputId = "pred2"),
                    "Linha sólida roxa - estimação P = B/K para a",
                    "faixa temporal de dados; Faixa roxa - Intervalo",
                    " de credibilidade de 95%; Linha sólida azul -",
                    " predição futura baseada na média dos",
                    "Parâmetros do modelo.")
              )),

########################################################################
### TAB 3 = Pontos de Referência...
    tabItem(tabName = "PBR",
            fluidRow(
                box(width = 12,
                    title = "Pontos Biológicos de Referência",
                    status = "info", solidHeader = TRUE,
                    dataTableOutput(outputId = "pbr"))
            ),
            fluidRow(
                box(width = 6,
                    title = "Função de Perda",
                    status = "info", solidHeader = TRUE,
                    plotlyOutput(outputId = "perda")),
                box(width = 6,
                    title = "Diagrama de Decisão",
                    status = "info", solidHeader = TRUE,
                    shiny::includeMarkdown("IMAGE.md"))
            )),

########################################################################
### TAB 4 = About...
    tabItem(tabName = "about",
            fluidPage(
                box(width = 10, status = "success",
                    shiny::includeMarkdown("README.md"))
            ))
    )
)

ui <- dashboardPage(header, sidebar, body, title = "Stock Assessment",
                    skin = "blue")

######################################################################
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or (at
## your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
##
######################################################################
