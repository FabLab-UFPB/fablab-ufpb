# EXEMPLO SHINY APP: MANUAL INTERATIVO FABLAB
# Aplicação web completa para manuais das máquinas do FABLAB

library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(shinyWidgets)
library(dplyr)
library(ggplot2)

# ============================================================================
# DADOS DE EXEMPLO
# ============================================================================

# Equipamentos
equipamentos <- data.frame(
  id = 1:8,
  nome = c("STORM 1390", "Prusa i3 MK2", "MakerBot Replicator 2X", 
           "XYZprinting Nobel 1.0A", "Ender 5 Plus", "Router CNC",
           "Plotter VISUTEC", "Bungard CCD/2/ATC"),
  categoria = c("Corte a Laser", "Impressão 3D FDM", "Impressão 3D FDM", 
                "Impressão 3D SLA", "Impressão 3D FDM", "Usinagem CNC",
                "Corte de Vinil", "Fabricação PCB"),
  status = c("Operacional", "Operacional", "Manutenção", "Operacional",
             "Operacional", "Operacional", "Operacional", "Operacional"),
  disponibilidade = c(98, 95, 85, 92, 96, 89, 94, 91),
  horas_uso_mes = c(120, 200, 80, 150, 180, 100, 60, 40),
  stringsAsFactors = FALSE
)

# Configurações de materiais para impressoras 3D
materiais_3d <- data.frame(
  material = c("PLA", "ABS", "PETG", "TPU"),
  temp_bico = c(210, 240, 235, 220),
  temp_mesa = c(55, 90, 75, 50),
  velocidade = c(60, 40, 50, 30),
  retração = c(6, 6, 6, 2),
  observacoes = c("Fácil impressão", "Requer ventilação", "Resistente químico", "Material flexível"),
  stringsAsFactors = FALSE
)

# Procedimentos por equipamento
procedimentos <- list(
  "Ender 5 Plus" = list(
    "Preparação" = c("Verificar nivelamento da mesa", "Carregar filamento", "Pré-aquecer equipamento"),
    "Operação" = c("Inserir arquivo G-code", "Iniciar impressão", "Monitorar primeira camada"),
    "Finalização" = c("Aguardar resfriamento", "Remover peça", "Limpar mesa")
  ),
  "STORM 1390" = list(
    "Preparação" = c("Verificar lentes", "Configurar potência", "Posicionar material"),
    "Operação" = c("Carregar arquivo de corte", "Definir origem", "Iniciar corte"),
    "Finalização" = c("Remover material", "Limpar mesa", "Verificar lentes")
  )
)

# ============================================================================
# INTERFACE DO USUÁRIO (UI)
# ============================================================================

ui <- dashboardPage(
  skin = "green",
  
  # Header
  dashboardHeader(
    title = "FABLAB UFPB - Manual Interativo",
    titleWidth = 300
  ),
  
  # Sidebar
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      id = "sidebar",
      menuItem("Dashboard", tabName = "dashboard", icon = icon("tachometer-alt")),
      menuItem("Impressoras 3D", tabName = "impressoras", icon = icon("cube"),
               menuSubItem("Ender 5 Plus", tabName = "ender5"),
               menuSubItem("Prusa i3 MK2", tabName = "prusa"),
               menuSubItem("Configurações", tabName = "config_3d")),
      menuItem("Corte a Laser", tabName = "laser", icon = icon("cut")),
      menuItem("Router CNC", tabName = "cnc", icon = icon("cogs")),
      menuItem("Manutenção", tabName = "manutencao", icon = icon("wrench")),
      menuItem("Relatórios", tabName = "relatorios", icon = icon("chart-bar")),
      menuItem("Ajuda", tabName = "ajuda", icon = icon("question-circle"))
    )
  ),
  
  # Body
  dashboardBody(
    # CSS personalizado
    tags$head(
      tags$style(HTML("
        .main-header .navbar {
          background: linear-gradient(135deg, #8BC34A, #4FC3F7) !important;
        }
        .skin-green .main-sidebar {
          background-color: #f8f9fa;
        }
        .content-wrapper {
          background-color: #f4f4f4;
        }
        .box {
          border-top: 3px solid #8BC34A;
        }
        .value-box-icon {
          background: rgba(139, 195, 74, 0.2) !important;
        }
      "))
    ),
    
    tabItems(
      # ========================================================================
      # TAB: DASHBOARD PRINCIPAL
      # ========================================================================
      tabItem(tabName = "dashboard",
        fluidRow(
          valueBoxOutput("total_equipamentos", width = 3),
          valueBoxOutput("disponibilidade_media", width = 3),
          valueBoxOutput("equipamentos_operacionais", width = 3),
          valueBoxOutput("horas_uso_total", width = 3)
        ),
        
        fluidRow(
          box(title = "Status dos Equipamentos", status = "primary", 
              solidHeader = TRUE, width = 8,
              DT::dataTableOutput("tabela_equipamentos")),
          
          box(title = "Distribuição por Categoria", status = "success", 
              solidHeader = TRUE, width = 4,
              plotlyOutput("grafico_categorias"))
        ),
        
        fluidRow(
          box(title = "Disponibilidade por Equipamento", status = "warning", 
              solidHeader = TRUE, width = 6,
              plotlyOutput("grafico_disponibilidade")),
          
          box(title = "Uso Mensal", status = "info", 
              solidHeader = TRUE, width = 6,
              plotlyOutput("grafico_uso_mensal"))
        )
      ),
      
      # ========================================================================
      # TAB: ENDER 5 PLUS
      # ========================================================================
      tabItem(tabName = "ender5",
        fluidRow(
          box(title = "Ender 5 Plus - Controle", status = "primary", 
              solidHeader = TRUE, width = 4,
              
              h4("🎯 Configuração Rápida"),
              selectInput("material_ender5", "Material:",
                         choices = materiais_3d$material,
                         selected = "PLA"),
              
              hr(),
              
              h4("📊 Status Atual"),
              verbatimTextOutput("status_ender5"),
              
              hr(),
              
              actionButton("aplicar_config_ender5", "Aplicar Configuração", 
                          class = "btn btn-success btn-block"),
              
              br(),
              
              actionButton("iniciar_manutencao", "Iniciar Manutenção", 
                          class = "btn btn-warning btn-block")
          ),
          
          box(title = "Especificações Técnicas", status = "info", 
              solidHeader = TRUE, width = 8,
              
              tabsetPanel(
                tabPanel("Especificações",
                  br(),
                  DT::dataTableOutput("specs_ender5")
                ),
                
                tabPanel("Configurações por Material",
                  br(),
                  DT::dataTableOutput("config_materiais_ender5")
                ),
                
                tabPanel("Procedimentos",
                  br(),
                  uiOutput("procedimentos_ender5")
                )
              )
          )
        ),
        
        fluidRow(
          box(title = "Configurações Atuais", status = "success", 
              solidHeader = TRUE, width = 6,
              plotlyOutput("config_atual_ender5")),
          
          box(title = "Histórico de Uso", status = "warning", 
              solidHeader = TRUE, width = 6,
              plotlyOutput("historico_ender5"))
        )
      ),
      
      # ========================================================================
      # TAB: CONFIGURAÇÕES 3D
      # ========================================================================
      tabItem(tabName = "config_3d",
        fluidRow(
          box(title = "Calculadora de Filamento", status = "primary", 
              solidHeader = TRUE, width = 6,
              
              numericInput("peso_objeto", "Peso do objeto (g):", 
                          value = 50, min = 1, max = 1000),
              
              selectInput("densidade_material", "Material:",
                         choices = list("PLA (1.24 g/cm³)" = 1.24,
                                       "ABS (1.04 g/cm³)" = 1.04,
                                       "PETG (1.27 g/cm³)" = 1.27,
                                       "TPU (1.20 g/cm³)" = 1.20)),
              
              numericInput("diametro_filamento", "Diâmetro do filamento (mm):", 
                          value = 1.75, min = 1.75, max = 3.0, step = 0.05),
              
              actionButton("calcular_filamento", "Calcular", 
                          class = "btn btn-primary"),
              
              br(), br(),
              
              verbatimTextOutput("resultado_calculo")
          ),
          
          box(title = "Comparação de Materiais", status = "success", 
              solidHeader = TRUE, width = 6,
              plotlyOutput("comparacao_materiais"))
        ),
        
        fluidRow(
          box(title = "Configurações Personalizadas", status = "warning", 
              solidHeader = TRUE, width = 12,
              
              h4("Criar Nova Configuração"),
              
              fluidRow(
                column(3,
                  textInput("nome_config", "Nome da Configuração:")
                ),
                column(2,
                  numericInput("temp_bico_custom", "Temp. Bico (°C):", value = 200)
                ),
                column(2,
                  numericInput("temp_mesa_custom", "Temp. Mesa (°C):", value = 60)
                ),
                column(2,
                  numericInput("velocidade_custom", "Velocidade (mm/s):", value = 50)
                ),
                column(3,
                  br(),
                  actionButton("salvar_config", "Salvar Configuração", 
                              class = "btn btn-success")
                )
              ),
              
              br(),
              
              DT::dataTableOutput("configs_salvas")
          )
        )
      ),
      
      # ========================================================================
      # TAB: MANUTENÇÃO
      # ========================================================================
      tabItem(tabName = "manutencao",
        fluidRow(
          box(title = "Agendar Manutenção", status = "primary", 
              solidHeader = TRUE, width = 4,
              
              selectInput("equip_manutencao", "Equipamento:",
                         choices = equipamentos$nome),
              
              dateInput("data_manutencao", "Data:", 
                       value = Sys.Date(), min = Sys.Date()),
              
              selectInput("tipo_manutencao", "Tipo:",
                         choices = c("Preventiva", "Corretiva", "Calibração", "Limpeza")),
              
              numericInput("tempo_estimado", "Tempo estimado (horas):", 
                          value = 1, min = 0.5, max = 8, step = 0.5),
              
              textAreaInput("observacoes_manutencao", "Observações:", 
                           rows = 3, placeholder = "Descreva os procedimentos..."),
              
              actionButton("agendar_manutencao", "Agendar Manutenção", 
                          class = "btn btn-primary btn-block")
          ),
          
          box(title = "Cronograma de Manutenção", status = "success", 
              solidHeader = TRUE, width = 8,
              DT::dataTableOutput("cronograma_manutencao"))
        ),
        
        fluidRow(
          box(title = "Checklist de Manutenção", status = "warning", 
              solidHeader = TRUE, width = 6,
              
              selectInput("equip_checklist", "Selecionar Equipamento:",
                         choices = equipamentos$nome),
              
              br(),
              
              uiOutput("checklist_manutencao")
          ),
          
          box(title = "Histórico de Manutenções", status = "info", 
              solidHeader = TRUE, width = 6,
              plotlyOutput("historico_manutencoes"))
        )
      ),
      
      # ========================================================================
      # TAB: AJUDA
      # ========================================================================
      tabItem(tabName = "ajuda",
        fluidRow(
          box(title = "Como Usar o Manual", status = "primary", 
              solidHeader = TRUE, width = 12,
              
              h3("🎯 Navegação"),
              p("Use o menu lateral para acessar diferentes seções do manual."),
              
              h3("📊 Dashboards Interativos"),
              p("Clique nos gráficos para explorar os dados em detalhes."),
              
              h3("🔧 Configurações"),
              p("Use as ferramentas de configuração para otimizar o uso dos equipamentos."),
              
              h3("📞 Suporte"),
              p("Em caso de dúvidas, entre em contato com a equipe técnica do FABLAB."),
              
              hr(),
              
              h3("📚 Recursos Adicionais"),
              tags$ul(
                tags$li("Manual em PDF (download)"),
                tags$li("Vídeos tutoriais"),
                tags$li("Fórum da comunidade"),
                tags$li("Documentação técnica")
              )
          )
        )
      )
    )
  )
)

# ============================================================================
# SERVIDOR (SERVER)
# ============================================================================

server <- function(input, output, session) {
  
  # ==========================================================================
  # DADOS REATIVOS
  # ==========================================================================
  
  # Configurações salvas (reativo)
  configs_salvas <- reactiveVal(data.frame(
    Nome = character(0),
    Temp_Bico = numeric(0),
    Temp_Mesa = numeric(0),
    Velocidade = numeric(0),
    stringsAsFactors = FALSE
  ))
  
  # Cronograma de manutenção (reativo)
  cronograma <- reactiveVal(data.frame(
    Equipamento = character(0),
    Data = as.Date(character(0)),
    Tipo = character(0),
    Tempo_h = numeric(0),
    Observacoes = character(0),
    stringsAsFactors = FALSE
  ))
  
  # ==========================================================================
  # VALUE BOXES (DASHBOARD)
  # ==========================================================================
  
  output$total_equipamentos <- renderValueBox({
    valueBox(
      value = nrow(equipamentos),
      subtitle = "Total de Equipamentos",
      icon = icon("cogs"),
      color = "green"
    )
  })
  
  output$disponibilidade_media <- renderValueBox({
    valueBox(
      value = paste0(round(mean(equipamentos$disponibilidade), 1), "%"),
      subtitle = "Disponibilidade Média",
      icon = icon("check-circle"),
      color = "blue"
    )
  })
  
  output$equipamentos_operacionais <- renderValueBox({
    operacionais <- sum(equipamentos$status == "Operacional")
    valueBox(
      value = operacionais,
      subtitle = "Equipamentos Operacionais",
      icon = icon("play-circle"),
      color = "yellow"
    )
  })
  
  output$horas_uso_total <- renderValueBox({
    valueBox(
      value = sum(equipamentos$horas_uso_mes),
      subtitle = "Horas de Uso (Mês)",
      icon = icon("clock"),
      color = "purple"
    )
  })
  
  # ==========================================================================
  # TABELAS E GRÁFICOS (DASHBOARD)
  # ==========================================================================
  
  output$tabela_equipamentos <- DT::renderDataTable({
    DT::datatable(equipamentos %>% 
                    select(nome, categoria, status, disponibilidade, horas_uso_mes),
                  colnames = c("Equipamento", "Categoria", "Status", "Disponibilidade (%)", "Uso Mensal (h)"),
                  options = list(pageLength = 10, dom = "tip")) %>%
      DT::formatStyle("status",
                      backgroundColor = DT::styleEqual(c("Operacional", "Manutenção"), 
                                                       c("#d4edda", "#f8d7da")))
  })
  
  output$grafico_categorias <- renderPlotly({
    categoria_count <- equipamentos %>% 
      count(categoria) %>%
      mutate(categoria = gsub("Impressão 3D ", "", categoria))
    
    p <- plot_ly(categoria_count, 
                 labels = ~categoria, 
                 values = ~n, 
                 type = "pie",
                 textinfo = "label+percent",
                 marker = list(colors = c("#8BC34A", "#4FC3F7", "#FFD54F", "#FF6B6B"))) %>%
      layout(title = "Equipamentos por Categoria",
             showlegend = TRUE)
    p
  })
  
  output$grafico_disponibilidade <- renderPlotly({
    p <- plot_ly(equipamentos, 
                 x = ~reorder(nome, disponibilidade), 
                 y = ~disponibilidade, 
                 type = "bar",
                 marker = list(color = ~disponibilidade,
                              colorscale = list(c(0, "#FF6B6B"), c(1, "#8BC34A")))) %>%
      layout(title = "Disponibilidade por Equipamento",
             xaxis = list(title = "Equipamento", tickangle = -45),
             yaxis = list(title = "Disponibilidade (%)"))
    p
  })
  
  output$grafico_uso_mensal <- renderPlotly({
    p <- plot_ly(equipamentos, 
                 x = ~nome, 
                 y = ~horas_uso_mes, 
                 type = "bar",
                 marker = list(color = "#4FC3F7")) %>%
      layout(title = "Uso Mensal por Equipamento",
             xaxis = list(title = "Equipamento", tickangle = -45),
             yaxis = list(title = "Horas de Uso"))
    p
  })
  
  # ==========================================================================
  # ENDER 5 PLUS
  # ==========================================================================
  
  output$status_ender5 <- renderText({
    paste(
      "Status: Operacional\n",
      "Temperatura Bico: 25°C\n",
      "Temperatura Mesa: 25°C\n",
      "Filamento: PLA Carregado\n",
      "Última Manutenção: 15/03/2024"
    )
  })
  
  output$specs_ender5 <- DT::renderDataTable({
    specs <- data.frame(
      Especificação = c("Volume de Impressão", "Resolução de Camada", "Velocidade Máxima",
                        "Temperatura Extrusor", "Temperatura Mesa", "Conectividade"),
      Valor = c("220×220×300 mm", "0.1-0.3 mm", "180 mm/s",
                "260°C máx", "100°C máx", "USB, SD Card"),
      stringsAsFactors = FALSE
    )
    
    DT::datatable(specs, options = list(dom = "t"))
  })
  
  output$config_materiais_ender5 <- DT::renderDataTable({
    DT::datatable(materiais_3d,
                  colnames = c("Material", "Temp. Bico (°C)", "Temp. Mesa (°C)", 
                              "Velocidade (mm/s)", "Retração (mm)", "Observações"),
                  options = list(dom = "t"))
  })
  
  output$procedimentos_ender5 <- renderUI({
    procs <- procedimentos[["Ender 5 Plus"]]
    
    tagList(
      h4("📋 Procedimentos de Operação"),
      
      h5("1. Preparação"),
      tags$ul(
        lapply(procs$Preparação, function(x) tags$li(x))
      ),
      
      h5("2. Operação"),
      tags$ul(
        lapply(procs$Operação, function(x) tags$li(x))
      ),
      
      h5("3. Finalização"),
      tags$ul(
        lapply(procs$Finalização, function(x) tags$li(x))
      )
    )
  })
  
  output$config_atual_ender5 <- renderPlotly({
    material_selecionado <- input$material_ender5
    if (is.null(material_selecionado)) material_selecionado <- "PLA"
    
    config <- materiais_3d[materiais_3d$material == material_selecionado, ]
    
    dados_config <- data.frame(
      Parâmetro = c("Temp. Bico", "Temp. Mesa", "Velocidade"),
      Valor = c(config$temp_bico, config$temp_mesa, config$velocidade),
      Unidade = c("°C", "°C", "mm/s")
    )
    
    p <- plot_ly(dados_config, 
                 x = ~Parâmetro, 
                 y = ~Valor, 
                 type = "bar",
                 text = ~paste(Valor, Unidade),
                 textposition = "outside",
                 marker = list(color = "#8BC34A")) %>%
      layout(title = paste("Configuração para", material_selecionado),
             yaxis = list(title = "Valor"))
    p
  })
  
  # ==========================================================================
  # CONFIGURAÇÕES 3D
  # ==========================================================================
  
  output$comparacao_materiais <- renderPlotly({
    p <- plot_ly(materiais_3d, x = ~material, y = ~temp_bico, 
                 type = "scatter", mode = "lines+markers", name = "Temp. Bico",
                 line = list(color = "#FF6B6B")) %>%
      add_trace(y = ~temp_mesa, name = "Temp. Mesa", line = list(color = "#4FC3F7")) %>%
      layout(title = "Comparação de Temperaturas por Material",
             yaxis = list(title = "Temperatura (°C)"))
    p
  })
  
  # Calculadora de filamento
  observeEvent(input$calcular_filamento, {
    peso <- input$peso_objeto
    densidade <- as.numeric(input$densidade_material)
    diametro <- input$diametro_filamento
    
    # Cálculo do comprimento de filamento
    volume_cm3 <- peso / densidade
    area_secao <- pi * (diametro/2)^2  # mm²
    area_secao_cm2 <- area_secao / 100  # cm²
    comprimento_cm <- volume_cm3 / area_secao_cm2
    comprimento_m <- comprimento_cm / 100
    
    output$resultado_calculo <- renderText({
      paste(
        "📊 RESULTADO DO CÁLCULO\n",
        "━━━━━━━━━━━━━━━━━━━━━━━━\n",
        "Peso do objeto:", peso, "g\n",
        "Volume necessário:", round(volume_cm3, 2), "cm³\n",
        "Comprimento de filamento:", round(comprimento_m, 2), "metros\n",
        "Custo estimado (PLA):", paste0("R$ ", round(comprimento_m * 0.15, 2))
      )
    })
  })
  
  # Salvar configuração personalizada
  observeEvent(input$salvar_config, {
    if (input$nome_config != "") {
      nova_config <- data.frame(
        Nome = input$nome_config,
        Temp_Bico = input$temp_bico_custom,
        Temp_Mesa = input$temp_mesa_custom,
        Velocidade = input$velocidade_custom,
        stringsAsFactors = FALSE
      )
      
      configs_atuais <- configs_salvas()
      configs_salvas(rbind(configs_atuais, nova_config))
      
      showNotification("Configuração salva com sucesso!", type = "success")
      
      # Limpar campos
      updateTextInput(session, "nome_config", value = "")
      updateNumericInput(session, "temp_bico_custom", value = 200)
      updateNumericInput(session, "temp_mesa_custom", value = 60)
      updateNumericInput(session, "velocidade_custom", value = 50)
    }
  })
  
  output$configs_salvas <- DT::renderDataTable({
    DT::datatable(configs_salvas(), 
                  options = list(pageLength = 5, dom = "tip"))
  })
  
  # ==========================================================================
  # MANUTENÇÃO
  # ==========================================================================
  
  # Agendar manutenção
  observeEvent(input$agendar_manutencao, {
    nova_manutencao <- data.frame(
      Equipamento = input$equip_manutencao,
      Data = input$data_manutencao,
      Tipo = input$tipo_manutencao,
      Tempo_h = input$tempo_estimado,
      Observacoes = input$observacoes_manutencao,
      stringsAsFactors = FALSE
    )
    
    cronograma_atual <- cronograma()
    cronograma(rbind(cronograma_atual, nova_manutencao))
    
    showNotification("Manutenção agendada com sucesso!", type = "success")
    
    # Limpar campos
    updateTextAreaInput(session, "observacoes_manutencao", value = "")
  })
  
  output$cronograma_manutencao <- DT::renderDataTable({
    DT::datatable(cronograma(), 
                  options = list(pageLength = 10, dom = "tip"))
  })
  
  # Checklist de manutenção
  output$checklist_manutencao <- renderUI({
    equip <- input$equip_checklist
    if (is.null(equip)) return(NULL)
    
    # Checklist básico (pode ser personalizado por equipamento)
    itens_checklist <- c(
      "Verificação visual geral",
      "Limpeza externa",
      "Verificação de cabos",
      "Teste de funcionamento",
      "Lubrificação (se necessário)",
      "Calibração básica"
    )
    
    checkboxes <- lapply(1:length(itens_checklist), function(i) {
      checkboxInput(paste0("check_", i), itens_checklist[i], value = FALSE)
    })
    
    tagList(
      h4(paste("Checklist -", equip)),
      checkboxes,
      br(),
      actionButton("finalizar_checklist", "Finalizar Checklist", 
                  class = "btn btn-success")
    )
  })
  
  # ==========================================================================
  # NOTIFICAÇÕES E EVENTOS
  # ==========================================================================
  
  # Aplicar configuração Ender 5
  observeEvent(input$aplicar_config_ender5, {
    material <- input$material_ender5
    showNotification(
      paste("Configuração aplicada para", material, "na Ender 5 Plus"),
      type = "success",
      duration = 3
    )
  })
  
  # Iniciar manutenção
  observeEvent(input$iniciar_manutencao, {
    showModal(modalDialog(
      title = "Iniciar Manutenção",
      "Tem certeza que deseja iniciar a manutenção da Ender 5 Plus?",
      "Isso irá marcar o equipamento como indisponível.",
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_manutencao", "Confirmar", class = "btn btn-warning")
      )
    ))
  })
  
  observeEvent(input$confirmar_manutencao, {
    removeModal()
    showNotification("Manutenção iniciada. Equipamento marcado como indisponível.", 
                    type = "warning", duration = 5)
  })
  
  # Finalizar checklist
  observeEvent(input$finalizar_checklist, {
    showNotification("Checklist finalizado com sucesso!", type = "success")
  })
}

# ============================================================================
# EXECUTAR APLICAÇÃO
# ============================================================================

# Para executar a aplicação:
# shinyApp(ui = ui, server = server)

# Para deploy no shinyapps.io:
# library(rsconnect)
# rsconnect::deployApp()

cat("🚀 Aplicação Shiny carregada com sucesso!\n")
cat("📱 Para executar, use: shinyApp(ui = ui, server = server)\n")

