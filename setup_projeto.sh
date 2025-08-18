#!/bin/bash

# =============================================================================
# SETUP DO PROJETO MANUAL INTERATIVO FABLAB UFPB
# Autor: Diogo Rego - Estudante de Estatística UFPB
# =============================================================================

echo "🚀 Iniciando setup do Manual Interativo FABLAB UFPB..."
echo "👨‍💻 Autor: Diogo Rego - Estudante de Estatística UFPB"
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "README.md" ]; then
    echo "❌ Erro: Execute este script no diretório raiz do projeto"
    exit 1
fi

# =============================================================================
# 1. CRIAR ESTRUTURA DE DIRETÓRIOS
# =============================================================================

echo "📁 Criando estrutura de diretórios..."

# Diretórios principais
mkdir -p bookdown/{images/{logos,maquinas,diagramas},data,R}
mkdir -p shiny-app/{www/{css,js,images},modules}
mkdir -p data
mkdir -p assets/{images,css,js}
mkdir -p scripts
mkdir -p docs
mkdir -p tests

echo "✅ Estrutura de diretórios criada"

# =============================================================================
# 2. MOVER ARQUIVOS BAIXADOS
# =============================================================================

echo "📦 Organizando arquivos baixados..."

# Verificar se os arquivos existem no Downloads
DOWNLOADS_DIR="$HOME/Downloads"

if [ -f "$DOWNLOADS_DIR/exemplo_bookdown_fablab.R" ]; then
    cp "$DOWNLOADS_DIR/exemplo_bookdown_fablab.R" scripts/
    echo "✅ exemplo_bookdown_fablab.R copiado para scripts/"
fi

if [ -f "$DOWNLOADS_DIR/exemplo_shiny_fablab (1).R" ]; then
    cp "$DOWNLOADS_DIR/exemplo_shiny_fablab (1).R" shiny-app/app.R
    echo "✅ exemplo_shiny_fablab.R copiado para shiny-app/"
fi

if [ -f "$DOWNLOADS_DIR/GUIA COMPLETO_ LIVRO INTERATIVO DOS MANUAIS FABLAB EM R.md" ]; then
    cp "$DOWNLOADS_DIR/GUIA COMPLETO_ LIVRO INTERATIVO DOS MANUAIS FABLAB EM R.md" docs/guia-completo.md
    echo "✅ Guia completo copiado para docs/"
fi

if [ -f "$DOWNLOADS_DIR/GUIA_COMPLETO_LIVRO_INTERATIVO_DOS_MANUAIS_FABLAB_EM_R.pdf" ]; then
    cp "$DOWNLOADS_DIR/GUIA_COMPLETO_LIVRO_INTERATIVO_DOS_MANUAIS_FABLAB_EM_R.pdf" docs/
    echo "✅ PDF do guia copiado para docs/"
fi

# =============================================================================
# 3. CRIAR ARQUIVOS DE CONFIGURAÇÃO
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

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# IDE
.vscode/
.idea/

# Logs
*.log
logs/

# Temporary files
tmp/
temp/
EOF

# LICENSE (MIT)
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

echo "✅ Arquivos de configuração criados"

# =============================================================================
# 4. CRIAR SCRIPTS R
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
  # Bookdown e RMarkdown
  "bookdown", "rmarkdown", "knitr",
  
  # Shiny e Dashboard
  "shiny", "shinydashboard", "shinyWidgets",
  
  # Visualização
  "DT", "plotly", "ggplot2", "htmlwidgets",
  
  # Manipulação de dados
  "dplyr", "tidyr", "readr", "lubridate",
  
  # Utilitários
  "here", "usethis", "devtools"
)

# Função para instalar pacotes
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  
  if(length(new_packages)) {
    cat("📦 Instalando pacotes:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, dependencies = TRUE)
  } else {
    cat("✅ Todos os pacotes já estão instalados\n")
  }
}

# Instalar pacotes
install_if_missing(packages)

# Carregar bibliotecas principais
library(bookdown)
library(rmarkdown)
library(knitr)

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
bookdown::render_book("bookdown/index.Rmd", "bookdown::gitbook")

cat("✅ Compilação concluída!\n")
cat("🌐 Abra _book/index.html no navegador para visualizar\n")
EOF

# deploy.R
cat > scripts/deploy.R << 'EOF'
# =============================================================================
# DEPLOY SCRIPT - MANUAL INTERATIVO FABLAB UFPB
# Autor: Diogo Rego - Estudante de Estatística UFPB
# =============================================================================

cat("🚀 Preparando deploy do Manual Interativo FABLAB UFPB...\n")

# Compilar livro
source("scripts/build.R")

# Copiar arquivos para docs/ (GitHub Pages)
if (dir.exists("_book")) {
  if (dir.exists("docs")) {
    unlink("docs", recursive = TRUE)
  }
  file.rename("_book", "docs")
  cat("✅ Arquivos copiados para docs/\n")
}

cat("🌐 Pronto para deploy no GitHub Pages!\n")
cat("📋 Próximos passos:\n")
cat("   1. git add .\n")
cat("   2. git commit -m 'Deploy manual interativo'\n")
cat("   3. git push origin main\n")
cat("   4. Ativar GitHub Pages nas configurações do repositório\n")
EOF

echo "✅ Scripts R criados"

# =============================================================================
# 5. CRIAR DOCUMENTAÇÃO ADICIONAL
# =============================================================================

echo "📖 Criando documentação adicional..."

# Guia de instalação
cat > docs/guia-instalacao.md << 'EOF'
# Guia de Instalação

## Pré-requisitos

### 1. Instalar R
- Acesse: https://www.r-project.org/
- Baixe a versão mais recente para macOS
- Execute o instalador

### 2. Instalar RStudio
- Acesse: https://www.rstudio.com/products/rstudio/download/
- Baixe RStudio Desktop (gratuito)
- Execute o instalador

### 3. Instalar Git
- Acesse: https://git-scm.com/download/mac
- Ou use Homebrew: `brew install git`

## Configuração do Projeto

1. Clone o repositório:
```bash
git clone https://github.com/FabLab-UFPB/manual-interativo-fablab-ufpb.git
cd manual-interativo-fablab-ufpb
```

2. Execute o setup:
```bash
chmod +x setup_projeto.sh
./setup_projeto.sh
```

3. Configure o R:
```r
source("scripts/setup.R")
```

4. Compile o livro:
```r
source("scripts/build.R")
```
EOF

# Guia de contribuição
cat > docs/guia-contribuicao.md << 'EOF'
# Guia de Contribuição

## Como Contribuir

1. **Fork** o repositório
2. **Clone** seu fork localmente
3. **Crie** uma branch para sua contribuição
4. **Faça** suas alterações
5. **Teste** suas mudanças
6. **Commit** com mensagem descritiva
7. **Push** para seu fork
8. **Abra** um Pull Request

## Padrões de Código

### R
- Use snake_case para nomes de variáveis
- Comente código complexo
- Siga o style guide do tidyverse

### Markdown
- Use títulos hierárquicos
- Inclua exemplos práticos
- Mantenha linhas com até 80 caracteres

## Estrutura de Commits

```
tipo(escopo): descrição breve

Descrição mais detalhada se necessário.

Fixes #123
```

Tipos:
- `feat`: nova funcionalidade
- `fix`: correção de bug
- `docs`: documentação
- `style`: formatação
- `refactor`: refatoração
- `test`: testes
EOF

# Changelog
cat > docs/changelog.md << 'EOF'
# Changelog

## [1.0.0] - 2024-03-XX

### Adicionado
- Manual interativo completo usando Bookdown
- Aplicação Shiny para funcionalidades avançadas
- Documentação de todos os equipamentos do FABLAB
- Sistema de busca integrado
- Calculadora de filamento para impressão 3D
- Cronogramas de manutenção preventiva
- Guias de solução de problemas

### Equipamentos Documentados
- STORM 1390 (Cortadora a Laser)
- Prusa i3 MK2 (Impressora 3D FDM)
- MakerBot Replicator 2X (Impressora 3D FDM)
- XYZprinting Nobel 1.0A (Impressora 3D SLA)
- Ender 5 Plus (Impressora 3D FDM)
- Router CNC
- Plotter VISUTEC V1380CCD
- Bungard CCD/2/ATC (Fabricação PCB)
EOF

echo "✅ Documentação adicional criada"

# =============================================================================
# 6. CONFIGURAR GIT
# =============================================================================

echo "🔧 Configurando Git..."

# Inicializar repositório se não existir
if [ ! -d ".git" ]; then
    git init
    echo "✅ Repositório Git inicializado"
fi

# Adicionar remote se não existir
if ! git remote get-url origin > /dev/null 2>&1; then
    git remote add origin https://github.com/FabLab-UFPB/manual-interativo-fablab-ufpb.git
    echo "✅ Remote origin adicionado"
fi

# =============================================================================
# 7. FINALIZAÇÃO
# =============================================================================

echo ""
echo "🎉 Setup concluído com sucesso!"
echo ""
echo "📋 Próximos passos:"
echo "   1. Abra o RStudio no diretório do projeto"
echo "   2. Execute: source('scripts/setup.R')"
echo "   3. Execute: source('scripts/build.R')"
echo "   4. Personalize o conteúdo conforme necessário"
echo ""
echo "🚀 Para fazer commit inicial:"
echo "   git add ."
echo "   git commit -m 'Configuração inicial do projeto'"
echo "   git push -u origin main"
echo ""
echo "👨‍💻 Desenvolvido por: Diogo Rego - Estudante de Estatística UFPB"
echo "🏛️ FABLAB - Universidade Federal da Paraíba"

