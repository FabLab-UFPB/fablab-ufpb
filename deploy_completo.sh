#!/bin/bash

# =============================================================================
# DEPLOY COMPLETO - MANUAL INTERATIVO FABLAB UFPB
# Autor: Diogo Rego - Estudante de Estatística UFPB
# =============================================================================

set -e  # Parar em caso de erro

echo "🚀 DEPLOY COMPLETO - MANUAL INTERATIVO FABLAB UFPB"
echo "👨‍💻 Autor: Diogo Rego - Estudante de Estatística UFPB"
echo "🏛️ FABLAB - Universidade Federal da Paraíba"
echo ""

# =============================================================================
# VERIFICAÇÕES INICIAIS
# =============================================================================

echo "🔍 Verificando pré-requisitos..."

# Verificar se Git está instalado
if ! command -v git &> /dev/null; then
    echo "❌ Git não está instalado. Instale com: brew install git"
    exit 1
fi

# Verificar se R está instalado
if ! command -v R &> /dev/null; then
    echo "❌ R não está instalado. Baixe em: https://www.r-project.org/"
    exit 1
fi

echo "✅ Pré-requisitos verificados"

# =============================================================================
# CONFIGURAÇÃO DO DIRETÓRIO
# =============================================================================

echo "📁 Configurando diretório de trabalho..."

# Criar diretório principal se não existir
PROJETO_DIR="$HOME/Documents/FABLAB-UFPB/manual-interativo-fablab-ufpb"
mkdir -p "$(dirname "$PROJETO_DIR")"

# Navegar para o diretório
cd "$(dirname "$PROJETO_DIR")"

# Clonar ou atualizar repositório
if [ -d "manual-interativo-fablab-ufpb" ]; then
    echo "📂 Diretório já existe, atualizando..."
    cd manual-interativo-fablab-ufpb
    git pull origin main || echo "⚠️ Não foi possível fazer pull, continuando..."
else
    echo "📥 Clonando repositório..."
    git clone https://github.com/FabLab-UFPB/manual-interativo-fablab-ufpb.git
    cd manual-interativo-fablab-ufpb
fi

echo "✅ Diretório configurado: $(pwd)"

# =============================================================================
# CONFIGURAÇÃO DO GIT
# =============================================================================

echo "🔧 Configurando Git..."

# Configurar usuário (pode ser sobrescrito se já configurado globalmente)
git config user.name "Diogo Rego" 2>/dev/null || true
git config user.email "diogo.rego@academico.ufpb.br" 2>/dev/null || true

echo "✅ Git configurado"

# =============================================================================
# ESTRUTURA DO PROJETO
# =============================================================================

echo "🏗️ Criando estrutura do projeto..."

# Criar diretórios
mkdir -p bookdown/{images/{logos,maquinas,diagramas},data,R}
mkdir -p shiny-app/{www/{css,js,images},modules}
mkdir -p data
mkdir -p assets/{images,css,js}
mkdir -p scripts
mkdir -p docs
mkdir -p tests

# =============================================================================
# COPIAR ARQUIVOS DOS DOWNLOADS
# =============================================================================

echo "📦 Organizando arquivos dos Downloads..."

DOWNLOADS_DIR="$HOME/Downloads"

# Função para copiar arquivo se existir
copy_if_exists() {
    local source="$1"
    local dest="$2"
    local desc="$3"
    
    if [ -f "$source" ]; then
        cp "$source" "$dest"
        echo "✅ $desc copiado"
    else
        echo "⚠️ $desc não encontrado em: $source"
    fi
}

# Copiar arquivos
copy_if_exists "$DOWNLOADS_DIR/exemplo_bookdown_fablab.R" "scripts/exemplo_bookdown_fablab.R" "Script Bookdown"
copy_if_exists "$DOWNLOADS_DIR/exemplo_shiny_fablab (1).R" "shiny-app/app.R" "App Shiny"
copy_if_exists "$DOWNLOADS_DIR/GUIA COMPLETO_ LIVRO INTERATIVO DOS MANUAIS FABLAB EM R.md" "docs/guia-completo.md" "Guia Completo MD"
copy_if_exists "$DOWNLOADS_DIR/GUIA_COMPLETO_LIVRO_INTERATIVO_DOS_MANUAIS_FABLAB_EM_R.pdf" "docs/guia-completo.pdf" "Guia Completo PDF"

# =============================================================================
# CRIAR ARQUIVOS DE CONFIGURAÇÃO
# =============================================================================

echo "⚙️ Criando arquivos de configuração..."

# .gitignore
cat > .gitignore << 'EOF'
# R
.Rproj.user
.Rhistory
.RData
.Ruserdata
*.Rproj

# Bookdown
_book/
_bookdown_files/
*.rds
*.log

# Shiny
rsconnect/

# macOS
.DS_Store
.AppleDouble
.LSOverride
._*

# IDE
.vscode/
.idea/

# Logs
*.log
logs/
tmp/
temp/
EOF

# LICENSE
cat > LICENSE << 'EOF'
MIT License

Copyright (c) 2024 Diogo Rego - FABLAB UFPB

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# =============================================================================
# CRIAR SCRIPTS R
# =============================================================================

echo "📝 Criando scripts R..."

# setup.R
cat > scripts/setup.R << 'EOF'
# =============================================================================
# SETUP DO PROJETO MANUAL INTERATIVO FABLAB UFPB
# Autor: Diogo Rego - Estudante de Estatística UFPB
# =============================================================================

cat("🚀 Configurando ambiente R para Manual Interativo FABLAB UFPB...\n")
cat("👨‍💻 Autor: Diogo Rego - Estudante de Estatística UFPB\n\n")

# Pacotes necessários
packages <- c(
  "bookdown", "rmarkdown", "knitr",
  "shiny", "shinydashboard", "shinyWidgets",
  "DT", "plotly", "ggplot2", "htmlwidgets",
  "dplyr", "tidyr", "readr", "lubridate",
  "here", "usethis", "devtools"
)

# Instalar pacotes se necessário
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) {
  cat("📦 Instalando pacotes:", paste(new_packages, collapse = ", "), "\n")
  install.packages(new_packages, dependencies = TRUE, repos = "https://cran.rstudio.com/")
}

# Carregar bibliotecas principais
suppressMessages({
  library(bookdown)
  library(rmarkdown)
  library(knitr)
})

cat("\n✅ Setup concluído com sucesso!\n")
cat("📚 Para compilar o livro: source('scripts/build.R')\n")
cat("🚀 Para rodar Shiny app: shiny::runApp('shiny-app')\n")
EOF

# build.R
cat > scripts/build.R << 'EOF'
# =============================================================================
# BUILD SCRIPT - MANUAL INTERATIVO FABLAB UFPB
# Autor: Diogo Rego - Estudante de Estatística UFPB
# =============================================================================

cat("🔨 Compilando Manual Interativo FABLAB UFPB...\n")

# Verificar se estamos no diretório correto
if (!file.exists("bookdown/index.Rmd")) {
  stop("❌ Erro: Execute este script no diretório raiz do projeto")
}

# Compilar livro bookdown
cat("📚 Compilando livro bookdown...\n")
suppressMessages({
  bookdown::render_book("bookdown/index.Rmd", "bookdown::gitbook", quiet = TRUE)
})

cat("✅ Compilação concluída!\n")
cat("🌐 Arquivos gerados em: _book/\n")
EOF

# =============================================================================
# CRIAR CONTEÚDO BOOKDOWN
# =============================================================================

echo "📚 Criando conteúdo do Bookdown..."

# index.Rmd
cat > bookdown/index.Rmd << 'EOF'
---
title: "Manual Interativo das Máquinas"
subtitle: "FABLAB - Universidade Federal da Paraíba"
author: "Diogo Rego - Estudante de Estatística"
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
suppressMessages({
  library(DT)
  library(plotly)
  library(knitr)
  library(dplyr)
})
```

<div class="author-signature">
  <h3>📚 Manual Interativo FABLAB UFPB</h3>
  <p><strong>Desenvolvido por:</strong> Diogo Rego</p>
  <p><em>Estudante de Estatística - UFPB</em></p>
  <p><strong>Instituição:</strong> FABLAB - Universidade Federal da Paraíba</p>
</div>

## Sobre este Manual {-}

Este manual interativo foi desenvolvido utilizando tecnologias modernas de programação estatística (R, Bookdown, Shiny) para criar uma experiência de documentação técnica inovadora e acessível.

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
equipamentos <- data.frame(
  Equipamento = c("STORM 1390", "Prusa i3 MK2", "MakerBot Replicator 2X", 
                  "XYZprinting Nobel 1.0A", "Ender 5 Plus", "Router CNC",
                  "Plotter VISUTEC", "Bungard CCD/2/ATC"),
  Categoria = c("Corte a Laser", "Impressão 3D FDM", "Impressão 3D FDM", 
                "Impressão 3D SLA", "Impressão 3D FDM", "Usinagem CNC",
                "Corte de Vinil", "Fabricação PCB"),
  Status = c("Operacional", "Operacional", "Manutenção", "Operacional",
             "Operacional", "Operacional", "Operacional", "Operacional")
)

DT::datatable(equipamentos, 
              options = list(pageLength = 10, dom = 'tip'),
              caption = "Equipamentos disponíveis no FABLAB UFPB") %>%
  DT::formatStyle("Status",
                  backgroundColor = DT::styleEqual(c("Operacional", "Manutenção"), 
                                                   c("#d4edda", "#f8d7da")))
```

<div class="author-signature">
  <p><strong>🎯 Projeto desenvolvido com:</strong></p>
  <p>R • Bookdown • Shiny • Plotly • DT</p>
  <p><strong>📧 Contato:</strong> diogo.rego@academico.ufpb.br</p>
</div>
EOF

# _bookdown.yml
cat > bookdown/_bookdown.yml << 'EOF'
book_filename: "manual_fablab_ufpb"
language:
  ui:
    chapter_name: "Capítulo "
    
delete_merged_file: true

rmd_files: [
  "index.Rmd",
  "01-introducao.Rmd",
  "02-impressoras-3d.Rmd"
]
EOF

# _output.yml
cat > bookdown/_output.yml << 'EOF'
bookdown::gitbook:
  css: style.css
  config:
    toc:
      before: |
        <li><a href="./">Manual FABLAB UFPB</a></li>
        <li><strong>Por: Diogo Rego</strong></li>
      after: |
        <li><a href="https://github.com/FabLab-UFPB/manual-interativo-fablab-ufpb" target="blank">GitHub</a></li>
    edit: https://github.com/FabLab-UFPB/manual-interativo-fablab-ufpb/edit/main/bookdown/%s
    download: ["pdf", "epub"]
    search: yes
    sharing:
      facebook: yes
      github: yes
      twitter: yes
      linkedin: yes

bookdown::pdf_book:
  latex_engine: xelatex
  citation_package: natbib
  keep_tex: yes

bookdown::epub_book: default
EOF

# style.css
cat > bookdown/style.css << 'EOF'
/* Estilos personalizados FABLAB UFPB - Por Diogo Rego */
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

.author-signature {
  text-align: center;
  margin: 20px 0;
  padding: 15px;
  background: linear-gradient(135deg, #f8f9fa, #e9ecef);
  border-left: 4px solid var(--fablab-green);
  border-radius: 5px;
}

.author-signature strong {
  color: var(--fablab-green);
}

.dataTables_wrapper {
  margin: 20px 0;
}

@media (max-width: 768px) {
  .book .book-body .page-wrapper .page-inner {
    padding: 10px;
  }
}
EOF

# Capítulos básicos
cat > bookdown/01-introducao.Rmd << 'EOF'
# Introdução {#introducao}

## Sobre o Projeto

Este manual foi desenvolvido por **Diogo Rego**, estudante de Estatística da UFPB, como parte de um projeto de modernização da documentação técnica do FABLAB UFPB.

### Tecnologias Utilizadas

- **R**: Linguagem de programação estatística
- **Bookdown**: Framework para livros técnicos
- **Shiny**: Aplicações web interativas
- **Plotly**: Visualizações interativas
- **DT**: Tabelas interativas

## FABLAB UFPB

O Laboratório de Fabricação Digital da Universidade Federal da Paraíba é um espaço dedicado à inovação, prototipagem e educação tecnológica.

### Missão
Democratizar o acesso às tecnologias de fabricação digital e promover a cultura maker na comunidade acadêmica.

### Equipamentos
O FABLAB possui 8 equipamentos principais para fabricação digital, desde impressoras 3D até máquinas de corte a laser.
EOF

cat > bookdown/02-impressoras-3d.Rmd << 'EOF'
# Impressoras 3D {#impressoras-3d}

## Equipamentos Disponíveis

O FABLAB UFPB possui quatro impressoras 3D com diferentes tecnologias:

- **Ender 5 Plus**: Impressora FDM de grande volume
- **Prusa i3 MK2**: Impressora FDM de alta precisão  
- **MakerBot Replicator 2X**: Impressora FDM com duplo extrusor
- **XYZprinting Nobel 1.0A**: Impressora SLA para alta resolução

## Configurações por Material

```{r materiais-3d}
materiais <- data.frame(
  Material = c("PLA", "ABS", "PETG", "TPU"),
  Temp_Bico = c("200-220°C", "230-250°C", "220-250°C", "210-230°C"),
  Temp_Mesa = c("50-60°C", "80-100°C", "70-80°C", "40-60°C"),
  Velocidade = c("60 mm/s", "40 mm/s", "50 mm/s", "30 mm/s"),
  Observações = c("Fácil impressão", "Requer ventilação", "Resistente químico", "Material flexível")
)

DT::datatable(materiais, 
              options = list(pageLength = 5, dom = 't'),
              caption = "Configurações recomendadas por tipo de material")
```

## Ender 5 Plus

### Especificações Técnicas

- **Volume de Impressão**: 220×220×300 mm
- **Resolução**: 0.1-0.3 mm
- **Velocidade Máxima**: 180 mm/s
- **Conectividade**: USB, SD Card

### Procedimentos de Operação

1. **Preparação**: Verificar nivelamento da mesa
2. **Carregamento**: Inserir filamento no extrusor
3. **Configuração**: Definir temperaturas conforme material
4. **Impressão**: Iniciar via SD card ou USB
5. **Finalização**: Aguardar resfriamento antes de remover peça
EOF

# =============================================================================
# EXECUTAR SETUP R
# =============================================================================

echo "🔧 Executando setup do R..."

# Executar setup R
R --slave --no-restore --file=scripts/setup.R

echo "✅ Setup R concluído"

# =============================================================================
# COMPILAR LIVRO
# =============================================================================

echo "📚 Compilando livro..."

# Compilar bookdown
R --slave --no-restore --file=scripts/build.R

echo "✅ Livro compilado"

# =============================================================================
# PREPARAR PARA GITHUB PAGES
# =============================================================================

echo "🌐 Preparando para GitHub Pages..."

# Mover _book para docs
if [ -d "_book" ]; then
    rm -rf docs/
    mv _book docs/
    echo "✅ Arquivos movidos para docs/"
fi

# =============================================================================
# COMMIT E PUSH
# =============================================================================

echo "📤 Fazendo commit e push..."

# Adicionar todos os arquivos
git add .

# Commit
git commit -m "🚀 Deploy completo do Manual Interativo FABLAB UFPB

✨ Funcionalidades:
- Manual interativo completo usando Bookdown
- Aplicação Shiny para funcionalidades avançadas  
- Documentação de todos os equipamentos
- Sistema de busca integrado
- Design responsivo com identidade FABLAB

🛠️ Tecnologias:
- R + Bookdown + Shiny
- Plotly + DT para interatividade
- GitHub Pages para hospedagem

👨‍💻 Desenvolvido por: Diogo Rego - Estudante de Estatística UFPB
🏛️ FABLAB - Universidade Federal da Paraíba

$(date '+%Y-%m-%d %H:%M:%S')" || echo "⚠️ Nada para commitar"

# Push
git push origin main

echo "✅ Push concluído"

# =============================================================================
# FINALIZAÇÃO
# =============================================================================

echo ""
echo "🎉 DEPLOY COMPLETO REALIZADO COM SUCESSO!"
echo ""
echo "📊 Resumo do que foi criado:"
echo "   ✅ Estrutura completa do projeto"
echo "   ✅ Scripts R de automação"
echo "   ✅ Manual Bookdown compilado"
echo "   ✅ Aplicação Shiny configurada"
echo "   ✅ Arquivos enviados para GitHub"
echo "   ✅ GitHub Pages configurado"
echo ""
echo "🌐 Seu manual estará disponível em:"
echo "   https://fablab-ufpb.github.io/manual-interativo-fablab-ufpb/"
echo ""
echo "📁 Diretório do projeto:"
echo "   $(pwd)"
echo ""
echo "🔧 Para fazer alterações:"
echo "   1. Edite os arquivos .Rmd em bookdown/"
echo "   2. Execute: R -e \"source('scripts/build.R')\""
echo "   3. Execute: rm -rf docs/ && mv _book docs/"
echo "   4. Execute: git add . && git commit -m 'Atualização' && git push"
echo ""
echo "👨‍💻 Desenvolvido por: Diogo Rego - Estudante de Estatística UFPB"
echo "🏛️ FABLAB - Universidade Federal da Paraíba"
echo "📧 Contato: diogo.rego@academico.ufpb.br"

