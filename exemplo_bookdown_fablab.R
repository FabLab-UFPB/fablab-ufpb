# EXEMPLO PRÁTICO: LIVRO INTERATIVO FABLAB EM R
# Este script demonstra como criar um livro interativo usando bookdown

# ============================================================================
# 1. INSTALAÇÃO E CONFIGURAÇÃO INICIAL
# ============================================================================

# Instalar pacotes necessários (executar apenas uma vez)
install_packages <- function() {
  packages <- c(
    "bookdown",      # Para criar livros
    "rmarkdown",     # Para documentos R Markdown
    "knitr",         # Para processamento de código
    "DT",            # Para tabelas interativas
    "plotly",        # Para gráficos interativos
    "htmlwidgets",   # Para widgets HTML
    "flexdashboard", # Para dashboards
    "shiny",         # Para aplicações web
    "shinydashboard",# Para dashboards Shiny
    "dplyr",         # Para manipulação de dados
    "ggplot2",       # Para gráficos
    "lubridate",     # Para datas
    "readr",         # Para leitura de dados
    "stringr"        # Para manipulação de strings
  )
  
  # Verificar quais pacotes não estão instalados
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  
  # Instalar pacotes não instalados
  if(length(new_packages)) {
    install.packages(new_packages, dependencies = TRUE)
  }
  
  cat("✅ Todos os pacotes foram instalados com sucesso!\n")
}

# Executar instalação (descomente a linha abaixo se necessário)
# install_packages()

# Carregar bibliotecas
library(bookdown)
library(rmarkdown)
library(knitr)
library(DT)
library(plotly)
library(dplyr)
library(ggplot2)

# ============================================================================
# 2. FUNÇÃO PARA CRIAR ESTRUTURA DO PROJETO
# ============================================================================

criar_projeto_fablab <- function(caminho = "manual_fablab_ufpb") {
  
  # Criar diretório principal
  if (!dir.exists(caminho)) {
    dir.create(caminho, recursive = TRUE)
  }
  
  # Criar subdiretórios
  subdirs <- c("images", "images/logos", "images/maquinas", "images/diagramas", "data", "R")
  for (subdir in subdirs) {
    dir.create(file.path(caminho, subdir), recursive = TRUE, showWarnings = FALSE)
  }
  
  # Criar arquivo de configuração _bookdown.yml
  bookdown_yml <- '
book_filename: "manual_fablab_ufpb"
language:
  ui:
    chapter_name: "Capítulo "
    
delete_merged_file: true

rmd_files: [
  "index.Rmd",
  "01-introducao.Rmd",
  "02-impressoras-3d.Rmd",
  "03-laser.Rmd",
  "04-router-cnc.Rmd",
  "05-plotter.Rmd",
  "06-pcb.Rmd",
  "07-manutencao.Rmd",
  "08-troubleshooting.Rmd"
]
'
  writeLines(bookdown_yml, file.path(caminho, "_bookdown.yml"))
  
  # Criar arquivo de configuração _output.yml
  output_yml <- '
bookdown::gitbook:
  css: style.css
  config:
    toc:
      before: |
        <li><a href="./">Manual FABLAB UFPB</a></li>
      after: |
        <li><a href="https://github.com/rstudio/bookdown" target="blank">Powered by bookdown</a></li>
    edit: https://github.com/fablab-ufpb/manual/edit/master/%s
    download: ["pdf", "epub"]
    search: yes
    sharing:
      facebook: yes
      github: yes
      twitter: yes
      linkedin: yes
      weibo: no
      instapaper: no
      vk: no
      all: [\'facebook\', \'github\', \'twitter\', \'linkedin\']

bookdown::pdf_book:
  includes:
    in_header: preamble.tex
  latex_engine: xelatex
  citation_package: natbib
  keep_tex: yes

bookdown::epub_book: default
'
  writeLines(output_yml, file.path(caminho, "_output.yml"))
  
  # Criar CSS personalizado
  css_content <- '
/* Estilos personalizados para o manual FABLAB */

:root {
  --fablab-green: #8BC34A;
  --fablab-blue: #4FC3F7;
  --fablab-gray: #757575;
}

.book .book-header {
  background: linear-gradient(135deg, var(--fablab-green), var(--fablab-blue));
  color: white;
}

.book .book-summary {
  background: #f8f9fa;
  border-right: 2px solid var(--fablab-green);
}

.book .book-summary ul.summary li.active > a {
  color: var(--fablab-green);
  font-weight: bold;
}

.dataTables_wrapper {
  margin: 20px 0;
}

.btn-primary {
  background-color: var(--fablab-green);
  border-color: var(--fablab-green);
}

.alert-info {
  border-left: 4px solid var(--fablab-blue);
}

pre {
  background: #f8f9fa;
  border-left: 4px solid var(--fablab-green);
  padding: 15px;
}

@media (max-width: 768px) {
  .book .book-body .page-wrapper .page-inner {
    padding: 10px;
  }
}
'
  writeLines(css_content, file.path(caminho, "style.css"))
  
  cat("✅ Estrutura do projeto criada em:", caminho, "\n")
  return(caminho)
}

# ============================================================================
# 3. FUNÇÃO PARA CRIAR DADOS DE EXEMPLO
# ============================================================================

criar_dados_exemplo <- function(caminho_projeto) {
  
  # Dados dos equipamentos
  equipamentos <- data.frame(
    id = 1:8,
    nome = c("STORM 1390", "Prusa i3 MK2", "MakerBot Replicator 2X", 
             "XYZprinting Nobel 1.0A", "Ender 5 Plus", "Router CNC",
             "Plotter VISUTEC V1380CCD", "Bungard CCD/2/ATC"),
    categoria = c("Corte a Laser", "Impressão 3D FDM", "Impressão 3D FDM", 
                  "Impressão 3D SLA", "Impressão 3D FDM", "Usinagem CNC",
                  "Corte de Vinil", "Fabricação PCB"),
    volume_trabalho = c("1300×900 mm", "250×210×200 mm", "246×152×155 mm",
                        "128×128×200 mm", "220×220×300 mm", "600×400×100 mm",
                        "1380×1000 mm", "160×100 mm"),
    status = c("Operacional", "Operacional", "Manutenção", "Operacional",
               "Operacional", "Operacional", "Operacional", "Operacional"),
    data_aquisicao = as.Date(c("2020-03-15", "2019-08-20", "2018-11-10",
                               "2021-02-28", "2022-01-15", "2020-09-05",
                               "2019-12-03", "2021-06-18")),
    stringsAsFactors = FALSE
  )
  
  # Dados de manutenção
  manutencoes <- data.frame(
    equipamento_id = sample(1:8, 50, replace = TRUE),
    data_manutencao = sample(seq(as.Date("2024-01-01"), Sys.Date(), by = "day"), 50),
    tipo = sample(c("Preventiva", "Corretiva", "Calibração"), 50, replace = TRUE),
    tempo_horas = round(runif(50, 0.5, 4), 1),
    custo = round(runif(50, 50, 500), 2),
    tecnico = sample(c("João Silva", "Maria Santos", "Pedro Costa", "Ana Lima"), 50, replace = TRUE),
    observacoes = sample(c("Manutenção rotineira", "Substituição de peça", "Calibração realizada",
                          "Limpeza geral", "Atualização de software"), 50, replace = TRUE),
    stringsAsFactors = FALSE
  )
  
  # Dados de uso
  uso_diario <- data.frame(
    data = rep(seq(as.Date("2024-01-01"), Sys.Date(), by = "day"), each = 8),
    equipamento_id = rep(1:8, length(seq(as.Date("2024-01-01"), Sys.Date(), by = "day"))),
    horas_uso = round(runif(8 * length(seq(as.Date("2024-01-01"), Sys.Date(), by = "day")), 0, 8), 1),
    projetos = sample(1:5, 8 * length(seq(as.Date("2024-01-01"), Sys.Date(), by = "day")), replace = TRUE),
    stringsAsFactors = FALSE
  )
  
  # Salvar dados
  save(equipamentos, manutencoes, uso_diario, 
       file = file.path(caminho_projeto, "data", "dados_fablab.RData"))
  
  # Criar CSV para fácil acesso
  write.csv(equipamentos, file.path(caminho_projeto, "data", "equipamentos.csv"), row.names = FALSE)
  write.csv(manutencoes, file.path(caminho_projeto, "data", "manutencoes.csv"), row.names = FALSE)
  write.csv(uso_diario, file.path(caminho_projeto, "data", "uso_diario.csv"), row.names = FALSE)
  
  cat("✅ Dados de exemplo criados e salvos\n")
  return(list(equipamentos = equipamentos, manutencoes = manutencoes, uso_diario = uso_diario))
}

# ============================================================================
# 4. FUNÇÃO PARA CRIAR ARQUIVO INDEX.RMD
# ============================================================================

criar_index_rmd <- function(caminho_projeto) {
  
  index_content <- '---
title: "Manual Interativo das Máquinas"
subtitle: "FABLAB - Universidade Federal da Paraíba"
author: "Equipe FABLAB UFPB"
date: "`r Sys.Date()`"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib]
biblio-style: apalike
link-citations: yes
description: "Manual completo e interativo das máquinas do FABLAB UFPB"
---

# Bem-vindos ao FABLAB UFPB {-}

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE)
library(DT)
library(plotly)
library(knitr)
library(dplyr)

# Carregar dados
load("data/dados_fablab.RData")
```

<div style="text-align: center;">
  <img src="images/logos/fablab_logo.png" alt="FABLAB UFPB" width="300" style="margin: 20px 0;"/>
</div>

## Sobre este Manual {-}

Este manual interativo contém todas as informações necessárias para operar, manter e solucionar problemas das máquinas do FABLAB UFPB.

### Características do Manual {-}

- 📱 **Responsivo**: Funciona em desktop, tablet e mobile
- 🔍 **Busca Integrada**: Encontre informações rapidamente
- 📊 **Conteúdo Interativo**: Gráficos, tabelas e simulações
- 📥 **Download**: Disponível em PDF e EPUB
- 🔗 **Referências Cruzadas**: Navegação inteligente entre seções

### Como Usar {-}

1. **Navegação**: Use o menu lateral para acessar capítulos
2. **Busca**: Digite termos na caixa de busca no topo
3. **Interatividade**: Clique em gráficos e tabelas para explorar
4. **Download**: Use os botões no topo para baixar versões offline

---

## Equipamentos do FABLAB {-}

```{r equipamentos-tabela}
DT::datatable(equipamentos %>% 
                select(nome, categoria, volume_trabalho, status), 
              colnames = c("Equipamento", "Categoria", "Volume de Trabalho", "Status"),
              options = list(pageLength = 10, dom = "tip"),
              caption = "Equipamentos disponíveis no FABLAB UFPB") %>%
  DT::formatStyle("status",
                  backgroundColor = DT::styleEqual(c("Operacional", "Manutenção"), 
                                                   c("#d4edda", "#f8d7da")))
```

## Status Atual dos Equipamentos {-}

```{r status-grafico}
status_summary <- equipamentos %>%
  count(status) %>%
  mutate(percentage = round(n/sum(n)*100, 1))

p <- plot_ly(status_summary, 
             labels = ~status, 
             values = ~n, 
             type = "pie",
             textinfo = "label+percent",
             marker = list(colors = c("#8BC34A", "#FF6B6B"))) %>%
  layout(title = "Status dos Equipamentos",
         showlegend = TRUE)

p
```

## Uso Mensal dos Equipamentos {-}

```{r uso-mensal}
uso_mensal <- uso_diario %>%
  left_join(equipamentos, by = c("equipamento_id" = "id")) %>%
  mutate(mes = format(data, "%Y-%m")) %>%
  group_by(mes, nome) %>%
  summarise(total_horas = sum(horas_uso, na.rm = TRUE), .groups = "drop") %>%
  filter(mes >= format(Sys.Date() - 90, "%Y-%m"))  # Últimos 3 meses

p2 <- plot_ly(uso_mensal, 
              x = ~mes, 
              y = ~total_horas, 
              color = ~nome,
              type = "scatter",
              mode = "lines+markers") %>%
  layout(title = "Uso Mensal dos Equipamentos (Últimos 3 Meses)",
         xaxis = list(title = "Mês"),
         yaxis = list(title = "Horas de Uso"))

p2
```
'
  
  writeLines(index_content, file.path(caminho_projeto, "index.Rmd"))
  cat("✅ Arquivo index.Rmd criado\n")
}

# ============================================================================
# 5. FUNÇÃO PARA CRIAR CAPÍTULO DE IMPRESSORAS 3D
# ============================================================================

criar_capitulo_impressoras <- function(caminho_projeto) {
  
  capitulo_content <- '# Impressoras 3D {#impressoras-3d}

```{r impressoras-setup, include=FALSE}
# Carregar dados específicos das impressoras
impressoras_3d <- equipamentos %>% 
  filter(grepl("Impressão 3D", categoria))
```

## Visão Geral

O FABLAB UFPB possui quatro impressoras 3D com diferentes tecnologias:

- **FDM (Fused Deposition Modeling)**: Prusa i3 MK2, MakerBot Replicator 2X, Ender 5 Plus
- **SLA (Stereolithography)**: XYZprinting Nobel 1.0A

```{r impressoras-tabela}
DT::datatable(impressoras_3d %>% 
                select(nome, categoria, volume_trabalho, status),
              colnames = c("Impressora", "Tecnologia", "Volume de Impressão", "Status"),
              options = list(pageLength = 5, dom = "t"),
              caption = "Impressoras 3D disponíveis")
```

## Ender 5 Plus {#ender-5-plus}

### Especificações Técnicas

```{r ender5-specs}
specs_ender5 <- data.frame(
  Especificação = c("Volume de Impressão", "Resolução de Camada", "Velocidade Máxima",
                    "Temperatura Extrusor", "Temperatura Mesa", "Filamentos Suportados",
                    "Conectividade", "Precisão"),
  Valor = c("220×220×300 mm", "0.1-0.3 mm", "180 mm/s",
            "260°C máx", "100°C máx", "PLA, ABS, PETG, TPU",
            "USB, SD Card", "±0.1 mm"),
  stringsAsFactors = FALSE
)

knitr::kable(specs_ender5, caption = "Especificações Técnicas - Ender 5 Plus")
```

### Configurações por Material

```{r materiais-config}
materiais <- data.frame(
  Material = c("PLA", "ABS", "PETG", "TPU"),
  Temp_Bico = c("200-220°C", "230-250°C", "220-250°C", "210-230°C"),
  Temp_Mesa = c("50-60°C", "80-100°C", "70-80°C", "40-60°C"),
  Velocidade = c("60 mm/s", "40 mm/s", "50 mm/s", "30 mm/s"),
  Retração = c("6 mm", "6 mm", "6 mm", "2 mm"),
  Observações = c("Fácil impressão", "Requer ventilação", "Resistente químico", "Material flexível"),
  stringsAsFactors = FALSE
)

DT::datatable(materiais, 
              options = list(pageLength = 5, dom = "t"),
              caption = "Configurações recomendadas por tipo de material")
```

### Procedimento de Operação

#### 1. Preparação da Impressora

```{r checklist-pre-impressao, echo=TRUE, eval=FALSE}
# Checklist pré-impressão
checklist_pre_impressao <- function() {
  checklist <- c(
    "Mesa nivelada",
    "Filamento carregado", 
    "Bico limpo",
    "Arquivo G-code preparado",
    "Temperatura configurada"
  )
  
  for(item in checklist) {
    cat("✓", item, "\n")
  }
}

checklist_pre_impressao()
```

#### 2. Passos de Operação

1. **Ligar a impressora** e aguardar inicialização (2-3 minutos)
2. **Verificar nivelamento** da mesa usando papel sulfite
3. **Carregar filamento** no extrusor até sair material
4. **Pré-aquecer** mesa e bico conforme material selecionado
5. **Iniciar impressão** via SD card ou USB

### Manutenção Preventiva

#### Cronograma de Manutenção

```{r manutencao-cronograma}
cronograma_ender5 <- data.frame(
  Atividade = c("Limpeza do bico", "Lubrificação dos eixos", "Calibração da mesa", 
                "Verificação das correias", "Limpeza geral", "Atualização firmware"),
  Frequência = c("Semanal", "Mensal", "Quinzenal", "Mensal", "Semanal", "Trimestral"),
  Tempo_min = c(15, 30, 20, 15, 25, 45),
  Prioridade = c("Alta", "Média", "Alta", "Média", "Baixa", "Baixa"),
  stringsAsFactors = FALSE
)

p <- plot_ly(cronograma_ender5, 
             x = ~Atividade, 
             y = ~Tempo_min, 
             color = ~Prioridade, 
             type = "bar",
             text = ~paste("Frequência:", Frequência),
             textposition = "outside") %>%
  layout(title = "Cronograma de Manutenção - Ender 5 Plus",
         xaxis = list(title = "Atividade", tickangle = -45),
         yaxis = list(title = "Tempo (minutos)"))

p
```

### Solução de Problemas

```{r troubleshooting-ender5}
problemas_ender5 <- data.frame(
  Problema = c("Primeira camada não adere", "Filamento não sai", "Impressão com falhas",
               "Ruído excessivo", "Aquecimento irregular", "Camadas desalinhadas"),
  Causa_Provável = c("Mesa desnivelada", "Bico entupido", "Configuração incorreta",
                     "Correias frouxas", "Termistor defeituoso", "Correias frouxas"),
  Solução = c("Nivelar mesa com papel", "Limpar/trocar bico", "Revisar configurações slicer",
              "Ajustar tensão das correias", "Verificar conexões", "Tensionar correias"),
  Urgência = c("Alta", "Média", "Média", "Baixa", "Alta", "Média"),
  Tempo_Solução = c("10 min", "20 min", "15 min", "5 min", "30 min", "10 min"),
  stringsAsFactors = FALSE
)

DT::datatable(problemas_ender5, 
              options = list(pageLength = 10, scrollX = TRUE),
              caption = "Guia de solução de problemas - Ender 5 Plus")
```

## Prusa i3 MK2 {#prusa-i3}

### Características Especiais

A Prusa i3 MK2 é conhecida por sua confiabilidade e qualidade de impressão superior.

```{r prusa-features}
# Comparação de características
comparacao <- data.frame(
  Aspecto = c("Precisão", "Velocidade", "Facilidade de Uso", "Confiabilidade", "Qualidade"),
  Prusa_i3 = c(9, 7, 8, 9, 9),
  Ender_5 = c(8, 8, 7, 8, 8),
  MakerBot = c(7, 6, 9, 7, 7),
  stringsAsFactors = FALSE
)

p2 <- plot_ly(comparacao, x = ~Aspecto, y = ~Prusa_i3, 
              type = "scatter", mode = "lines+markers", name = "Prusa i3 MK2",
              line = list(color = "#8BC34A")) %>%
  add_trace(y = ~Ender_5, name = "Ender 5 Plus", line = list(color = "#4FC3F7")) %>%
  add_trace(y = ~MakerBot, name = "MakerBot 2X", line = list(color = "#FFD54F")) %>%
  layout(title = "Comparação de Performance das Impressoras",
         yaxis = list(title = "Pontuação (1-10)", range = c(0, 10)))

p2
```

### Auto-nivelamento

A Prusa i3 MK2 possui sistema de auto-nivelamento que facilita a operação:

1. **Ativar auto-nivelamento** no menu da impressora
2. **Aguardar processo** (aproximadamente 3 minutos)
3. **Verificar resultado** - mesa deve estar perfeitamente nivelada
4. **Iniciar impressão** normalmente

## XYZprinting Nobel 1.0A (SLA) {#nobel-sla}

### Tecnologia SLA

A impressora SLA utiliza resina líquida curada por luz UV, oferecendo:

- **Alta precisão**: Detalhes de até 0.025mm
- **Acabamento superior**: Superfície lisa
- **Materiais especiais**: Resinas flexíveis, transparentes, biocompatíveis

### Cuidados Especiais

```{r cuidados-sla}
cuidados_sla <- data.frame(
  Aspecto = c("Ventilação", "EPI", "Limpeza", "Armazenamento", "Descarte"),
  Cuidado = c("Sempre usar em área ventilada", "Luvas nitrílicas obrigatórias",
              "Álcool isopropílico para limpeza", "Resina em local escuro e fresco",
              "Resina curada pode ir no lixo comum"),
  Importância = c("Crítica", "Crítica", "Alta", "Média", "Média"),
  stringsAsFactors = FALSE
)

DT::datatable(cuidados_sla,
              options = list(pageLength = 5, dom = "t"),
              caption = "Cuidados especiais para impressão SLA") %>%
  DT::formatStyle("Importância",
                  backgroundColor = DT::styleEqual(c("Crítica", "Alta", "Média"), 
                                                   c("#ffebee", "#fff3e0", "#f3e5f5")))
```
'
  
  writeLines(capitulo_content, file.path(caminho_projeto, "02-impressoras-3d.Rmd"))
  cat("✅ Capítulo de Impressoras 3D criado\n")
}

# ============================================================================
# 6. FUNÇÃO PRINCIPAL PARA CRIAR PROJETO COMPLETO
# ============================================================================

criar_projeto_completo <- function(caminho = "manual_fablab_ufpb") {
  
  cat("🚀 Iniciando criação do projeto FABLAB...\n\n")
  
  # 1. Criar estrutura
  caminho_projeto <- criar_projeto_fablab(caminho)
  
  # 2. Criar dados de exemplo
  dados <- criar_dados_exemplo(caminho_projeto)
  
  # 3. Criar arquivos principais
  criar_index_rmd(caminho_projeto)
  criar_capitulo_impressoras(caminho_projeto)
  
  # 4. Criar outros capítulos básicos
  criar_outros_capitulos(caminho_projeto)
  
  cat("\n✅ Projeto criado com sucesso!\n")
  cat("📁 Localização:", normalizePath(caminho_projeto), "\n")
  cat("🔧 Para compilar o livro, execute:\n")
  cat("   setwd('", caminho_projeto, "')\n", sep = "")
  cat("   bookdown::render_book('index.Rmd', 'bookdown::gitbook')\n")
  cat("📖 Para servir localmente durante desenvolvimento:\n")
  cat("   bookdown::serve_book()\n\n")
  
  return(caminho_projeto)
}

# ============================================================================
# 7. FUNÇÃO PARA CRIAR OUTROS CAPÍTULOS
# ============================================================================

criar_outros_capitulos <- function(caminho_projeto) {
  
  # Capítulo de Introdução
  intro_content <- '# Introdução {#introducao}

## História do FABLAB UFPB

O FABLAB (Fabrication Laboratory) da Universidade Federal da Paraíba foi criado em 2018 com o objetivo de democratizar o acesso às tecnologias de fabricação digital.

## Missão

Promover a inovação, criatividade e aprendizado através do acesso a ferramentas de fabricação digital de última geração.

## Equipamentos Disponíveis

```{r intro-equipamentos}
knitr::kable(equipamentos %>% 
               select(nome, categoria, status) %>%
               arrange(categoria),
             caption = "Lista completa de equipamentos")
```
'
  writeLines(intro_content, file.path(caminho_projeto, "01-introducao.Rmd"))
  
  # Capítulo de Manutenção
  manutencao_content <- '# Manutenção Preventiva {#manutencao}

## Cronograma Geral

```{r cronograma-geral}
# Análise de manutenções por equipamento
manutencao_summary <- manutencoes %>%
  left_join(equipamentos, by = c("equipamento_id" = "id")) %>%
  group_by(nome, tipo) %>%
  summarise(
    total_manutencoes = n(),
    custo_total = sum(custo, na.rm = TRUE),
    tempo_total = sum(tempo_horas, na.rm = TRUE),
    .groups = "drop"
  )

DT::datatable(manutencao_summary,
              colnames = c("Equipamento", "Tipo", "Total Manutenções", "Custo Total (R$)", "Tempo Total (h)"),
              options = list(pageLength = 10)) %>%
  DT::formatCurrency("custo_total", currency = "R$ ")
```

## Custos de Manutenção

```{r custos-manutencao}
custos_mensais <- manutencoes %>%
  mutate(mes = format(data_manutencao, "%Y-%m")) %>%
  group_by(mes, tipo) %>%
  summarise(custo_total = sum(custo, na.rm = TRUE), .groups = "drop") %>%
  filter(mes >= format(Sys.Date() - 180, "%Y-%m"))  # Últimos 6 meses

p <- plot_ly(custos_mensais, x = ~mes, y = ~custo_total, color = ~tipo,
             type = "scatter", mode = "lines+markers") %>%
  layout(title = "Evolução dos Custos de Manutenção",
         xaxis = list(title = "Mês"),
         yaxis = list(title = "Custo (R$)"))

p
```
'
  writeLines(manutencao_content, file.path(caminho_projeto, "07-manutencao.Rmd"))
  
  # Outros capítulos básicos
  capitulos <- list(
    "03-laser.Rmd" = "# Cortadora a Laser STORM 1390 {#laser}\n\n## Em desenvolvimento...",
    "04-router-cnc.Rmd" = "# Router CNC {#router-cnc}\n\n## Em desenvolvimento...",
    "05-plotter.Rmd" = "# Plotter de Corte {#plotter}\n\n## Em desenvolvimento...",
    "06-pcb.Rmd" = "# Fabricação de PCB {#pcb}\n\n## Em desenvolvimento...",
    "08-troubleshooting.Rmd" = "# Solução de Problemas {#troubleshooting}\n\n## Em desenvolvimento..."
  )
  
  for (arquivo in names(capitulos)) {
    writeLines(capitulos[[arquivo]], file.path(caminho_projeto, arquivo))
  }
  
  cat("✅ Capítulos adicionais criados\n")
}

# ============================================================================
# 8. EXEMPLO DE USO
# ============================================================================

# Para criar o projeto completo, execute:
# projeto <- criar_projeto_completo("meu_manual_fablab")

# Para compilar o livro:
# setwd("meu_manual_fablab")
# bookdown::render_book("index.Rmd", "bookdown::gitbook")

# Para desenvolvimento com servidor local:
# bookdown::serve_book()

cat("📚 Script carregado com sucesso!\n")
cat("🚀 Para criar o projeto, execute: criar_projeto_completo()\n")

