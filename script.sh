#!/bin/bash

# Configurações SFTP
SFTP_SERVER="10.1.0.3"
SFTP_USER="root"
SFTP_PASSWORD="ABG#7102@"
REMOTE_PATH="/srv/dev-disk-by-uuid-6f48e4e0-a07c-4495-8b6e-ea1f7e6323de/Usuarios/ArquivosTI/ProjetosFelipe/SistemaDeAtualizacao/autoupdate.sh"
LOCAL_PATH="/opt/htepil/autoupdate.sh"  # Alterado o nome do arquivo local

# Verifica se o comando 'expect' está instalado
if ! command -v expect &> /dev/null; then
    sudo apt install expect -y
    exit 1
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

