#!/bin/bash

# Verificar se o script está sendo executado como superusuário
if [ "$EUID" -ne 0 ]; then
    echo "Este script precisa ser executado como superusuário." >&2
    exit 1
fi

# Função para executar atualizações
executar_atualizacoes() {
    LOG_FILE="/opt/htepil/log/relatorio_de_atualizacao_$(date +\%Y\%m\%d-\%H\%M\%S).txt"

    # Adicionar cabeçalho ao log
    echo "--------------------------------------------" | tee -a "$LOG_FILE"
    echo "Log de Atualização - $(date)" | tee -a "$LOG_FILE"
    echo "--------------------------------------------" | tee -a "$LOG_FILE"

    # Adicionar mensagem informativa
    echo "Iniciando atualizações em $(date)" | tee -a "$LOG_FILE"

    # Executar atualizações
    sudo apt update -y >> "$LOG_FILE" 2>&1
    # Verificar se o comando foi executado com sucesso
    if [ $? -eq 0 ]; then
        echo "apt update: Comando executado com sucesso." | tee -a "$LOG_FILE"
    else
        echo "apt update: Erro ao executar o comando. Verifique o log para mais detalhes." | tee -a "$LOG_FILE"
    fi

    sudo apt upgrade -y >> "$LOG_FILE" 2>&1
    # Verificar se o comando foi executado com sucesso
    if [ $? -eq 0 ]; then
        echo "apt upgrade: Comando executado com sucesso." | tee -a "$LOG_FILE"
    else
        echo "apt upgrade: Erro ao executar o comando. Verifique o log para mais detalhes." | tee -a "$LOG_FILE"
    fi

    sudo apt autoremove -y
    sudo flatpak update -y

    # Registrar as informações no log
    echo >> "$LOG_FILE"
    end_time=$(date +'%Y-%m-%d %H:%M:%S')
    echo "Final do Log - $end_time" | tee -a "$LOG_FILE"
    echo "Atualização Concluída em $(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
    echo "Pacotes atualizados:" | tee -a "$LOG_FILE"
    sudo apt list --upgradable >> "$LOG_FILE"
}

# Chamando funções
executar_atualizacoes

