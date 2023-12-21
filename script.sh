#!/bin/bash

# Configurações SFTP
SFTP_SERVER="sv"
SFTP_USER="user"
SFTP_PASSWORD="pass"
REMOTE_PATH="caminho/do/servidor/script.sh"
LOCAL_PATH="caminho/da/maquina/aonde/estara/o/script.sh"  # Alterado o nome do arquivo local

# Define o diretório de destino para o log
log_dir="/opt/htepil/log"

# Verifica se o comando 'expect' está instalado
if ! command -v expect &> /dev/null; then
    sudo apt install expect -y
    exit 1
fi

# Cria o diretório de log se ele não existir
if [ ! -d "$log_dir" ]; then
    mkdir -p "$log_dir"
fi

# Função para baixar arquivo via SFTP
baixar_arquivo_sftp() {
    echo "Baixando arquivo via SFTP..."
    # Use expect para automatizar a interação com o cliente SFTP
    expect <<EOD
        spawn sftp $SFTP_USER@$SFTP_SERVER
        expect "password:"
        send "$SFTP_PASSWORD\r"
        expect "sftp>"
        send "get $REMOTE_PATH $LOCAL_PATH\r"
        expect "sftp>"
        send "bye\r"
        expect eof
EOD
    echo "Download concluído."
}

# Chamando funções
baixar_arquivo_sftp
chmod +x * -R
