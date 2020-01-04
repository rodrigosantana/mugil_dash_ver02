######################################################################
## Description: Dashboard para Gestao da Pesca de Tainha Mugil liza,
## estoque Sudeste e Sul do Brasil...
##
## Maintainer: OCEANA Brasil
## Author: Rodrigo Sant'Ana & Paul Gerhard Kinas
## Created: Qui Mar 24 16:16:17 2016 (-0300)
## Last-Updated: qua jan 31 02:57:34 2018 (-0200)
##           By: Rodrigo Sant'Ana
##     Update #: 203
##
## URL:
##
### Commentary:
##
### Code:
######################################################################

########################################################################
### Carregando pacotes...
library(shiny)
library(ggplot2)
library(shinydashboard)
library(plotly)
library(grid)
library(markdown)
library(ggExtra)
library(DT)

########################################################################
### Configuracoes iniciais do R...

### Padronizacao de tema para grafico - meu theme ggplot2...
seta <- grid::arrow(length = grid::unit(0.2, "cm"), type = "open")
my_theme <- function (base_size = 14, base_family = "Arial") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(axis.ticks = element_blank(),
          axis.line = element_line(arrow = seta),
          legend.background = element_blank(),
          legend.key = element_blank(),
          panel.background = element_blank(),
          panel.border = element_blank(),
          strip.background = element_blank(),
          plot.background = element_blank(),
          plot.title = element_text(hjust = 1),
          complete = TRUE)
}

server <- function(input, output) {

########################################################################
### Carregando base de dados...
    DBprod <- reactive({
        ## input$refresh
        ## input$refresh2
        load("data/prod.RData")
        DBprod <- tmp
    })

    DBcpue <- reactive({
        load("data/cpue.RData")
        DBcpue <- U
    })

    DBpred0 <- reactive({
        load("data/pred0.RData")
        DBpred0 <- params0
    })

    DBpred1 <- reactive({
        load("data/pred1.RData")
        DBpred1 <- params1
    })

    DBpred2 <- reactive({
        load("data/pred2.RData")
        DBpred2 <- params2
    })

    DBpost0 <- reactive({
        load("data/post0.RData")
        DBpost0 <- post0
    })

    DBpost1 <- reactive({
        load("data/post1.RData")
        DBpost1 <- post1
    })

    DBpost2 <- reactive({
        load("data/post2.RData")
        DBpost2 <- post2
    })

    DBref <- reactive({
        load("data/ref.RData")
        DBref <- ref
    })

    DBpbrs <- reactive({
        load("data/pbrs.RData")
        DBpbrs <- tab
    })

    DBperda <- reactive({
        load("data/perda.RData")
        DBperda <- perda
    })

########################################################################
### Funcoes ...
    predict.spm <- function(P, K, r, z, Y, cap, years = 8){
        pred <- c(P[length(P)], rep(NA, years))
        cap <- c(Y[length(Y)], cap)
        for(t in 2:(years+1)){
            pred[t] <- pred[t-1]+r*pred[t-1]*(1-(pred[t-1]^z)) - cap[t-1]/K
        }
        return(pred)
    }

########################################################################
### Header...
    ## output$messageMenu <- renderMenu({
    ##     msgs <- apply(messageData, 1, function(row) {
    ##         messageItem(from = row[["from"]], message = row[["message"]])
    ##     })

    ##     dropdownMenu(type = "messages", .list = msgs)
    ## })

########################################################################
### TAB 1 = DADOS DE CAPTURA E CPUE...
    ## Figura "prod"
    output$prod <- renderPlotly({
        p <- ggplot(data = DBprod(),
                    aes(x = ANO, y = TONELADAS, fill = FONTE,
                        text = paste("ANO:", ANO))) +
            geom_bar(stat = "identity", position = "dodge",
                     colour = "black", size = 0.2) +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            scale_y_continuous(breaks = seq(0, 25000, 5000),
                               limits = c(0, 25000),
                               expand = c(0, 0)) +
            scale_fill_manual("Fonte", values = c("black", "white")) +
            labs(x = "Ano", y = "Captura (t)") +
            my_theme() +
            theme(legend.justification = c(1, 1),
                  legend.position = c(1, 1))
        ggplotly(p, tooltip = c("text", "TONELADAS")) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 1"
    output$cpue1 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 1")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 2"
    output$cpue2 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 2")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 3"
    output$cpue3 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 3")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 4"
    output$cpue4 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 4")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 5"
    output$cpue5 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 5")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 6"
    output$cpue6 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 6")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 7"
    output$cpue7 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 7")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 8"
    output$cpue8 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 8")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 9"
    output$cpue9 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 9")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 10"
    output$cpue10 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 10")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Figura "CPUE 10"
    output$cpue11 <- renderPlotly({
        dt <- DBcpue()
        dt <- dplyr::filter(dt, DB == "Série 11")
        p <- ggplot(data = dt, aes(x = ANO, y = CPUE)) +
            geom_line(colour = "red") +
            geom_point(alpha = 0.8, colour = "red", fill = "white",
                       size = 3, pch = 21) +
            labs(title = unique(dt$FONTE),
                 x = "Ano", y = "Captura por Unidade de Esforço") +
            scale_x_continuous(breaks = seq(2000, 2017, 1)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    ## Sumário estatístico dos dados de Captura
    output$Summ.cap <- renderDataTable(
        DBprod(), options = list(
                      searchable = TRUE, searching = TRUE,
                      pageLength = 10))

    ## Sumário estatístico dos dados de CPUE
    output$Summ.cpue <- renderDataTable(
        DBcpue(), options = list(
                      searchable = TRUE, searching = TRUE,
                      pageLength = 10))

########################################################################
### Tab 3 - Modelos DB...
    output$pred0 <- renderPlotly({
        ## Entrada dos dados...
        dt <- DBpost0()
        dt2 <- DBpred0()
        ## Carregando os parametros...
        cap <- c(rep(input$cap01, 2), rep(input$cap02, 2),
                 rep(input$cap03, 2), rep(input$cap04, 2))
        ## P medio...
        P <- apply(dt[,1:18], 2, function(x) mean(x))
        ## P intervalo de credibilidade para os anos 2000 a 2015...
        P.l <- apply(dt[,1:18], 2, function(x)
            quantile(x, probs = .025))
        P.u <- apply(dt[,1:18], 2, function(x)
            quantile(x, probs = .975))
        ## Parametros medianos...
        K <- mean(dt$K0.post)
        r <- mean(dt$r0.post)
        z <- mean(dt$z0.post)
        ## Predicao para os proximos 10 anos baseada na mediana dos
        ## parametros...
        pred <- predict.spm(P = P, K = K, r = r,
                            z = z, Y = dt2$Y, cap = cap)
        pred.l <- predict.spm(P = P.l, K = K, r = r,
                              z = z, Y = dt2$Y, cap = cap)
        pred.u <- predict.spm(P = P.u, K = K, r = r,
                              z = z, Y = dt2$Y, cap = cap)
        ## Organizando a tabela de predicao baseada na mediana...
        dt.pred0 <- data.frame(ANO = 2000:2025, P = c(dt2$P[-18], pred),
                               P.l = c(P.l, rep(NA, 8)),
                               P.u = c(P.u, rep(NA, 8)))
        p <- ggplot() +
            geom_ribbon(data = subset(dt.pred0, ANO <= 2017),
                        aes(x = ANO, ymin = P.l, ymax = P.u),
                        alpha = 0.2, fill = "purple") +
            geom_line(data = subset(dt.pred0, ANO < 2018),
                      aes(x = ANO, y = P), colour = "purple",
                      size = 1.2) +
            geom_line(data = subset(dt.pred0, ANO > 2016),
                      aes(x = ANO, y = P), colour = "blue",
                      fill = "blue", size = 1.2) +
            geom_point(data = subset(dt.pred0, ANO < 2018),
                       aes(x = ANO, y = P), alpha = 0.8,
                       colour = "purple", fill = "white",
                       size = 4, pch = 21) +
            geom_point(data = subset(dt.pred0, ANO > 2016),
                       aes(x = ANO, y = P), alpha = 0.8,
                       colour = "blue", fill = "white",
                       size = 4, pch = 21) +
            geom_hline(yintercept = 0.5, colour = "black",
                       linetype = "dashed") +
            geom_hline(yintercept = 0, colour = "red") +
            scale_x_continuous(breaks = seq(2000, 2025, 1)) +
            scale_y_continuous(limits = c(-0.2, 1.5), expand = c(0, 0)) +
            labs(x = "Ano", y = "Proporção da Biomassa do Estoque") +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })

    output$pred1 <- renderPlotly({
        ## Entrada dos dados...
        dt3 <- DBpost1()
        dt4 <- DBpred1()
        ## Carregando os parametros...
        cap <- c(rep(input$cap01, 2), rep(input$cap02, 2),
                 rep(input$cap03, 2), rep(input$cap04, 2))
        ## P medio...
        P1 <- apply(dt3[,1:18], 2, function(x) mean(x))
        ## P intervalo de credibilidade para os anos 2000 a 2015...
        P1.l <- apply(dt3[,1:18], 2, function(x)
            quantile(x, probs = .025))
        P1.u <- apply(dt3[,1:18], 2, function(x)
            quantile(x, probs = .975))
        ## Parametros medianos...
        K1 <- mean(dt3$K1.post)
        r1 <- mean(dt3$r1.post)
        z1 <- mean(dt3$z1.post)
        ## Predicao para os proximos 10 anos baseada na mediana dos
        ## parametros...
        pred1 <- predict.spm(P = P1, K = K1, r = r1,
                             z = z1, Y = dt4$Y, cap = cap)
        pred1.l <- predict.spm(P = P1.l, K = K1, r = r1,
                               z = z1, Y = dt4$Y, cap = cap)
        pred1.u <- predict.spm(P = P1.u, K = K1, r = r1,
                               z = z1, Y = dt4$Y, cap = cap)
        ## Organizando a tabela de predicao baseada na mediana...
        dt.pred1 <- data.frame(ANO = 2000:2025, P = c(dt4$P[-18], pred1),
                               P.l = c(P1.l, rep(NA, 8)),
                               P.u = c(P1.u, rep(NA, 8)))
        p <- ggplot() +
            geom_ribbon(data = subset(dt.pred1, ANO <= 2017),
                        aes(x = ANO, ymin = P.l, ymax = P.u),
                        alpha = 0.2, fill = "purple") +
            geom_line(data = subset(dt.pred1, ANO < 2018),
                      aes(x = ANO, y = P), colour = "purple",
                      size = 1.2) +
            geom_line(data = subset(dt.pred1, ANO > 2016),
                      aes(x = ANO, y = P), colour = "blue",
                      fill = "blue", size = 1.2) +
            geom_point(data = subset(dt.pred1, ANO < 2018),
                       aes(x = ANO, y = P), alpha = 0.8,
                       colour = "purple", fill = "white",
                       size = 4, pch = 21) +
            geom_point(data = subset(dt.pred1, ANO > 2016),
                       aes(x = ANO, y = P), alpha = 0.8,
                       colour = "blue", fill = "white",
                       size = 4, pch = 21) +
            geom_hline(yintercept = 0.5, colour = "black",
                       linetype = "dashed") +
            geom_hline(yintercept = 0, colour = "blue") +
            scale_x_continuous(breaks = seq(2000, 2025, 1)) +
            scale_y_continuous(limits = c(-0.2, 1.5), expand = c(0, 0)) +
            labs(x = "Ano", y = "Proporção da Biomassa do Estoque") +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
  })

    output$pred2 <- renderPlotly({
        ## Entrada dos dados...
        dt5 <- DBpost2()
        dt6 <- DBpred2()
        ## Carregando os parametros...
        cap <- c(rep(input$cap01, 2), rep(input$cap02, 2),
                 rep(input$cap03, 2), rep(input$cap04, 2))
        ## P medio...
        P2 <- apply(dt5[,1:18], 2, function(x) mean(x))
        ## P intervalo de credibilidade para os anos 2000 a 2015...
        P2.l <- apply(dt5[,1:18], 2, function(x)
            quantile(x, probs = .025))
        P2.u <- apply(dt5[,1:18], 2, function(x)
            quantile(x, probs = .975))
        ## Parametros medianos...
        K2 <- mean(dt5$K2.post)
        r2 <- mean(dt5$r2.post)
        z2 <- mean(dt5$z2.post)
        ## Predicao para os proximos 10 anos baseada na mediana dos
        ## parametros...
        pred2 <- predict.spm(P = P2, K = K2, r = r2,
                             z = z2, Y = dt6$Y, cap = cap)
        pred2.l <- predict.spm(P = P2.l, K = K2, r = r2,
                               z = z2, Y = dt6$Y, cap = cap)
        pred2.u <- predict.spm(P = P2.u, K = K2, r = r2,
                               z = z2, Y = dt6$Y, cap = cap)
        ## Organizando a tabela de predicao baseada na mediana...
        dt.pred2 <- data.frame(ANO = 2000:2025, P = c(dt6$P[-18], pred2),
                               P.l = c(P2.l, rep(NA, 8)),
                               P.u = c(P2.u, rep(NA, 8)))
        p <- ggplot() +
            geom_ribbon(data = subset(dt.pred2, ANO < 2018),
                        aes(x = ANO, ymin = P.l, ymax = P.u),
                        alpha = 0.2, fill = "purple") +
            geom_line(data = subset(dt.pred2, ANO < 2018),
                      aes(x = ANO, y = P), colour = "purple",
                      size = 1.2) +
            geom_line(data = subset(dt.pred2, ANO > 2016),
                      aes(x = ANO, y = P), colour = "blue",
                      fill = "blue", size = 1.2, linetype = "solid") +
            geom_point(data = subset(dt.pred2, ANO < 2018),
                       aes(x = ANO, y = P), alpha = 0.8,
                       colour = "purple", fill = "white",
                       size = 4, pch = 21) +
            geom_point(data = subset(dt.pred2, ANO > 2016),
                       aes(x = ANO, y = P), alpha = 0.8,
                       colour = "blue", fill = "white",
                       size = 4, pch = 21) +
            geom_hline(yintercept = 0.5, colour = "black",
                       linetype = "dashed") +
            geom_hline(yintercept = 0, colour = "blue") +
            scale_x_continuous(breaks = seq(2000, 2025, 1)) +
            scale_y_continuous(limits = c(-0.2, 1.5), expand = c(0, 0)) +
            labs(x = "Ano", y = "Proporção da Biomassa do Estoque") +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
  })


    output$pbr <- renderDataTable(
        DBpbrs(), options = list(
                      searchable = FALSE, searching = FALSE,
                      paging = FALSE))

    output$perda <- renderPlotly({
        p <- ggplot(data = DBperda(), aes(x = Penalização, y = Q)) +
            geom_line() +
            geom_hline(yintercept = 0.3, colour = "red") +
            labs(x = "Excedente de penalização por superestimação (k)",
                 y = "Estimativa do percentil do RMS") +
            scale_x_continuous(limits = c(1, 8),
                               breaks = seq(1, 8, 1)) +
            scale_y_continuous(limits = c(0.20, 0.55),
                       breaks = seq(0.20, 0.55, 0.05)) +
            my_theme()
        ggplotly(p) %>%
            layout(autosize = TRUE)
    })
}

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
