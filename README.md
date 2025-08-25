## Manual Interativo

📄 Clique aqui para acessar o Manual Interativo do FabLab UFPB

Manual Interativo FABLAB UFPB

<div align="center">

Documentação técnica interativa e moderna para os equipamentos do FABLAB UFPB

📖 Acessar Manual • 🚀 Demo Shiny • 📊 Apresentação

</div>




📋 Sobre o Projeto

O Manual Interativo FABLAB UFPB é uma iniciativa de modernização da documentação técnica dos equipamentos do Laboratório de Fabricação Digital da Universidade Federal da Paraíba. Este projeto transforma manuais estáticos em uma experiência interativa, acessível e colaborativa.

🎯 Objetivos

•
Modernizar a documentação técnica dos equipamentos

•
Facilitar o acesso às informações de operação e manutenção

•
Promover a colaboração na criação e atualização de conteúdo

•
Otimizar o processo de treinamento de novos usuários

•
Centralizar conhecimento técnico em uma plataforma única

🏭 Equipamentos Documentados

EquipamentoCategoriaStatusDocumentaçãoSTORM 1390Corte a Laser✅ Completo📖 ManualEnder 5 PlusImpressão 3D FDM✅ Completo📖 ManualPrusa i3 MK2Impressão 3D FDM✅ Completo📖 ManualMakerBot Replicator 2XImpressão 3D FDM✅ Completo📖 ManualXYZprinting Nobel 1.0AImpressão 3D SLA✅ Completo📖 ManualRouter CNCUsinagem✅ Completo📖 ManualPlotter VISUTEC V1380CCDCorte de Vinil✅ Completo📖 ManualBungard CCD/2/ATCFabricação PCB✅ Completo📖 ManualBungard Compacta 40LFabricação PCB✅ Completo📖 Manual

🚀 Tecnologias Utilizadas

Linguagens e Frameworks

•
R - Linguagem principal para análise e visualização

•
Shiny - Aplicações web interativas

•
Bookdown - Documentação técnica estruturada

•
Quarto - Apresentações e relatórios modernos

•
HTML/CSS/JavaScript - Interface web responsiva

Bibliotecas Especializadas

•
Plotly - Visualizações interativas

•
DT - Tabelas dinâmicas

•
Flexdashboard - Painéis de controle

•
Knitr - Integração de código e documentação

Infraestrutura

•
GitHub Pages - Hospedagem gratuita

•
Shinyapps.io - Deploy de aplicações Shiny

•
GitHub Actions - CI/CD automatizado

📁 Estrutura do Projeto

Plain Text


manual-interativo-fablab-ufpb/
├── 📚 bookdown/                 # Livro interativo
│   ├── index.Rmd               # Página inicial
│   ├── _bookdown.yml           # Configuração
│   ├── _output.yml             # Formatação
│   └── chapters/               # Capítulos por equipamento
├── 🚀 shiny-app/               # Aplicação Shiny
│   ├── app.R                   # Aplicação principal
│   ├── ui.R                    # Interface do usuário
│   ├── server.R                # Lógica do servidor
│   └── modules/                # Módulos reutilizáveis
├── 📊 data/                    # Dados dos equipamentos
│   ├── equipamentos.csv        # Especificações técnicas
│   ├── manutencoes.csv         # Histórico de manutenções
│   └── configuracoes.csv       # Parâmetros operacionais
├── 🎨 assets/                  # Recursos visuais
│   ├── images/                 # Imagens e diagramas
│   ├── css/                    # Estilos personalizados
│   └── js/                     # Scripts JavaScript
├── 🔧 scripts/                 # Scripts de automação
│   ├── setup.R                 # Configuração inicial
│   ├── build.R                 # Build automatizado
│   └── deploy.R                # Deploy para produção
├── 📖 docs/                    # Documentação + GitHub Pages
├── 📋 README.md                # Este arquivo
├── ⚖️ LICENSE                  # Licença MIT
└── 🔧 .gitignore               # Configuração Git


🛠️ Instalação e Uso

Pré-requisitos

•
R (≥ 4.0.0)

•
RStudio (recomendado)

•
Git

•
Pandoc (incluído no RStudio)

Instalação Rápida

Bash


# 1. Clonar o repositório
git clone https://github.com/FabLab-UFPB/manual-interativo-fablab-ufpb.git
cd manual-interativo-fablab-ufpb

# 2. Instalar dependências R
Rscript scripts/setup.R

# 3. Compilar o livro
Rscript scripts/build.R

# 4. Executar aplicação Shiny localmente
Rscript -e "shiny::runApp('shiny-app')"


Instalação Detalhada

<details>
<summary>Clique para ver instruções detalhadas</summary>

1. Configuração do Ambiente R

Plain Text


# Instalar pacotes necessários
install.packages(c(
  "bookdown", "shiny", "shinydashboard", "DT", 
  "plotly", "flexdashboard", "knitr", "rmarkdown",
  "dplyr", "ggplot2", "readr", "stringr"
))


2. Compilação do Bookdown

Plain Text


# Navegar para o diretório bookdown
setwd("bookdown")

# Compilar o livro
bookdown::render_book("index.Rmd", "bookdown::gitbook")


3. Execução da Aplicação Shiny

Plain Text


# Executar aplicação
shiny::runApp("shiny-app", port = 3838)


</details>

🌐 Deploy e Hospedagem

GitHub Pages (Automático)

O projeto está configurado com GitHub Actions para deploy automático:

1.
Push para a branch main

2.
Build automático do Bookdown

3.
Deploy para GitHub Pages

4.
Disponível em: https://fablab-ufpb.github.io/manual-interativo-fablab-ufpb/

Shinyapps.io

Plain Text


# Deploy da aplicação Shiny
rsconnect::deployApp("shiny-app", appName = "manual-interativo-fablab")


📊 Funcionalidades

📖 Manual Interativo (Bookdown)

•
✅ Busca integrada em todo o conteúdo

•
✅ Navegação por capítulos organizados por equipamento

•
✅ Tabelas interativas com especificações técnicas

•
✅ Gráficos dinâmicos de performance e utilização

•
✅ Download em PDF para uso offline

•
✅ Responsivo para todos os dispositivos

🚀 Aplicação Shiny

•
✅ Dashboard em tempo real com métricas dos equipamentos

•
✅ Calculadoras de material para impressão 3D e corte

•
✅ Sistema de agendamento de equipamentos

•
✅ Checklists digitais para procedimentos

•
✅ Histórico de manutenções com visualizações

•
✅ Configurador de parâmetros por material

📊 Visualizações e Análises

•
✅ Gráficos de utilização por equipamento

•
✅ Análise de custos operacionais

•
✅ Indicadores de performance (MTBF, MTTR)

•
✅ Tendências temporais de uso

•
✅ Comparativos de eficiência

🤝 Como Contribuir

Contribuições são muito bem-vindas! Veja como você pode ajudar:

📝 Documentação

1.
Fork este repositório

2.
Crie uma branch para sua contribuição (git checkout -b feature/nova-documentacao)

3.
Edite os arquivos Markdown em bookdown/chapters/

4.
Teste localmente com bookdown::serve_book()

5.
Commit suas mudanças (git commit -m 'Adiciona documentação do equipamento X')

6.
Push para a branch (git push origin feature/nova-documentacao)

7.
Abra um Pull Request

🐛 Reportar Problemas

•
Use as Issues para reportar bugs

•
Inclua informações detalhadas sobre o problema

•
Adicione screenshots quando relevante

💡 Sugerir Melhorias

•
Abra uma Issue com o label "enhancement"

•
Descreva claramente a melhoria proposta

•
Explique os benefícios esperados

📈 Roadmap

Versão 2.0 (Em Desenvolvimento)




API REST para integração com outros sistemas




Sistema de notificações por email




Integração com IoT para monitoramento em tempo real




Módulo de treinamento com quizzes interativos




Sistema de reservas avançado

Versão 2.1 (Planejado)




Aplicativo móvel nativo




Realidade aumentada para procedimentos




Chatbot com IA para suporte




Integração com ERP da universidade

📊 Estatísticas do Projeto

<div align="center">













</div>

🏆 Reconhecimentos

Desenvolvimento

•
Diogo Rego - Estudante de Estatística UFPB - Desenvolvimento principal e documentação

Colaboradores

•
FABLAB UFPB - Fornecimento de especificações técnicas e validação

•
Professores UFPB - Revisão técnica e orientação

•
Comunidade R - Bibliotecas e frameworks utilizados

Instituições

•
Universidade Federal da Paraíba (UFPB) - Apoio institucional

•
FABLAB UFPB - Laboratório e equipamentos

📞 Contato

Autor Principal

•
Nome: Diogo Rego

•
Instituição: Estudante de Estatística - UFPB

•
Email: diogo.rego@academico.ufpb.br

•
GitHub: @diogorego20

•
LinkedIn: Diogo Rego

FABLAB UFPB

•
Website: fablab.ufpb.br

•
Email: fablab@ufpb.br

•
Endereço: Campus I, João Pessoa - PB, 58051-900

•
Telefone: (83) 999556330

⚖️ Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo LICENSE para detalhes.

Plain Text


MIT License

Copyright (c) 2025 FABLAB UFPB - Diogo Rego

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.





<div align="center">

Desenvolvido por Diogo Rego para o FABLAB UFPB







</div>




