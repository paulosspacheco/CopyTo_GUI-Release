#!/bin/bash
# ===========================================================
# Projeto: CopyTo
# Módulo:  release/celular_servidor_sftp.sh
# Data:    2026-11-17
# Versão:  1.6.0
# Função:  Configuração do celular (Termux) para o provider
#          Celular (SFTP) - executar NO CELULAR
# ===========================================================

PORTA=8022
MARCA_INI="# >>> copyto-phone >>>"
MARCA_FIM="# <<< copyto-phone <<<"
PREFIXO="${PREFIX:-/data/data/com.termux/files/usr}"
AJUDANTE="$PREFIXO/bin/copyto-phone"
MARCA_SENHA="$HOME/.copyto_senha_ok"
MARCA_BATERIA="$HOME/.copyto_bateria_ok"
REGISTRO="$HOME/.copyto_instalacao.log"

texto()  { printf '  %s\n' "$@"; }
passo()  { printf '\n[%s de 5] %s\n' "$1" "$2"; printf -- '--------------------------------------\n'; }
ok()     { printf '  OK: %s\n' "$1"; }
aviso()  { printf '  ATENÇÃO: %s\n' "$1"; }
falha()  { { printf '\n  ERRO:\n'; printf '  %s\n' "$@"; printf '\n'; } >&2; exit 1; }
pausar() { local _; read -r -p "  $1 " _; }

perguntar() {
    local resposta
    read -r -p "  $1 " resposta
    resposta="${resposta:-$2}"
    [[ "${resposta,,}" =~ ^(s|sim|y|yes)$ ]]
}

armazenamento_ok() {
    ls "$HOME/storage/shared/" >/dev/null 2>&1
}

definir_senha() {
    local tentativa
    texto "Vão aparecer 2 pedidos em inglês:" \
          "" \
          "New password:" \
          "  -> digite a senha e aperte Enter" \
          "Retype new password:" \
          "  -> digite a mesma senha de novo" \
          ""
    for tentativa in 1 2 3; do
        passwd && return 0
        aviso "As senhas não foram iguais. Tente de novo ($tentativa de 3)."
    done
    return 1
}

escrever_ajudante() {
    {
        printf '#!/usr/bin/env bash\n\nPORTA=%s\n' "$PORTA"
        cat <<'AJUDA'
IP_SALVO="$HOME/.copyto_ip"

detectar_ip() {
    local ip privado='^(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.)'
    ip=$(ip route get 1.1.1.1 2>/dev/null \
        | awk '{for (i = 1; i < NF; i++) if ($i == "src") {print $(i + 1); exit}}')
    if [[ ! "$ip" =~ $privado ]]; then
        ip=$({ ip -4 -o addr show wlan0 2>/dev/null; ifconfig wlan0 2>/dev/null; } \
            | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' \
            | grep -E "$privado" \
            | head -n 1)
    fi
    [[ "$ip" =~ $privado ]] || return 1
    printf '%s' "$ip"
}

ligado() {
    pgrep -x sshd >/dev/null 2>&1
}

start() {
    local i
    ligado || sshd
    termux-wake-lock >/dev/null 2>&1
    for i in 1 2 3 4 5 6; do
        ligado && return 0
        sleep 0.5
    done
    return 1
}

stop() {
    pkill -x sshd >/dev/null 2>&1
    termux-wake-unlock >/dev/null 2>&1
    return 0
}

pedir_ip() {
    local digitado tentativa
    printf '\n'
    printf '  Não consegui descobrir o IP sozinho.\n'
    printf '  Veja em: Configurações > Wi-Fi >\n'
    printf '  toque na rede conectada (ou na\n'
    printf '  engrenagem) > Endereço IP.\n\n'
    for tentativa in 1 2 3; do
        read -r -p "  Digite o IP (Enter pula): " digitado
        [[ -n "$digitado" ]] || return 1
        if [[ "$digitado" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
            printf '%s\n' "$digitado" > "$IP_SALVO"
            return 0
        fi
        printf '  IP inválido. Exemplo: 192.168.0.25\n'
    done
    return 1
}

cartao() {
    local ip origem=""
    ip=$(detectar_ip) || ip=""
    if [[ -z "$ip" && -f "$IP_SALVO" ]]; then
        ip=$(cat "$IP_SALVO")
        origem=" (informado)"
    fi
    if [[ -z "$ip" && -t 0 ]]; then
        if pedir_ip; then
            ip=$(cat "$IP_SALVO")
            origem=" (informado)"
        fi
    fi
    printf '\n'
    if ligado; then
        printf '  Servidor: LIGADO\n'
    else
        printf '  Servidor: DESLIGADO\n'
        printf '  Para ligar digite: copyto-phone start\n'
    fi
    printf '\n'
    printf '  ==================================\n'
    printf '   DADOS PARA O COMPUTADOR\n'
    printf '  ==================================\n'
    printf '   IP .....: %s%s\n' "${ip:-veja em Wi-Fi}" "$origem"
    printf '   Porta ..: %s\n' "$PORTA"
    printf '   Usuário : %s\n' "$(whoami)"
    printf '   Senha ..: a que você criou\n'
    printf '  ==================================\n\n'
}

case "${1:-info}" in
    info)
        cartao
        ;;
    ip)
        pedir_ip
        cartao
        ;;
    start)
        start
        exit $?
        ;;
    stop)
        stop
        printf 'Servidor desligado.\n'
        ;;
    *)
        printf 'Uso: copyto-phone [info|ip|start|stop]\n' >&2
        exit 1
        ;;
esac
AJUDA
    } > "$AJUDANTE"
    chmod 755 "$AJUDANTE"
}

principal() {
    [[ -n "${TERMUX_VERSION:-}" || -d /data/data/com.termux ]] \
        || falha "Execute este script dentro do aplicativo Termux," "no celular."

    printf '\n======================================\n'
    printf ' PREPARAR O CELULAR PARA O COPYTO\n'
    printf '======================================\n\n'
    texto "São 5 passos e leva uns 3 minutos." \
          "" \
          "O Android vai pedir 2 permissões." \
          "Você só precisa tocar em PERMITIR." \
          "" \
          "Mantenha o Wi-Fi ligado e a tela" \
          "acesa até o fim." \
          ""
    pausar "Aperte Enter para começar."

    passo 1 "Acesso aos arquivos"
    if armazenamento_ok; then
        ok "Já liberado"
    else
        texto "O Android vai abrir uma tela:" \
              "- Se aparecer PERMITIR, toque nele." \
              "- Se abrir Configurações, ative a" \
              "  chave do Termux e volte aqui." \
              "" \
              "Se o Termux fechar sozinho:" \
              "1. Abra o Termux de novo" \
              "2. Toque na seta ↑ (barra de teclas)" \
              "3. Aperte Enter" \
              ""
        pausar "Aperte Enter para continuar."
        termux-setup-storage
        local i
        for ((i = 0; i < 180; i++)); do
            armazenamento_ok && break
            sleep 1
        done
        armazenamento_ok \
            || falha "A permissão não foi concedida." "Execute de novo e libere o acesso."
        ok "Acesso liberado"
    fi
    mkdir -p "$HOME/storage/shared/CopyTo" 2>/dev/null

    passo 2 "Bateria"
    if [[ -f "$MARCA_BATERIA" ]]; then
        ok "Já feito"
    else
        texto "O Android vai perguntar sobre a" \
              "bateria. Toque em PERMITIR." \
              "Isso evita que ele feche o Termux." \
              "" \
              "Se aparecer uma lista de apps," \
              "procure Termux e escolha" \
              "\"Não otimizar\"." \
              ""
        pausar "Aperte Enter para continuar."
        : > "$MARCA_BATERIA"
        am start -a android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS >/dev/null 2>&1 \
            || aviso "Abra: Configurações > Apps > Termux > Bateria > Sem restrições"
        pausar "Depois, volte ao Termux e aperte Enter."
        ok "Bateria"
    fi

    passo 3 "Instalando o servidor"
    texto "Pode levar alguns minutos." \
          "Nada aparece na tela. Aguarde."
    export DEBIAN_FRONTEND=noninteractive
    pkg update -y < /dev/null > "$REGISTRO" 2>&1 \
        || falha "Não foi possível atualizar o Termux." \
                 "Verifique a internet." \
                 "Se persistir digite: termux-change-repo" \
                 "Detalhes: cat $REGISTRO"
    pkg install -y -o Dpkg::Options::=--force-confold openssh procps < /dev/null >> "$REGISTRO" 2>&1 \
        || falha "Não foi possível instalar." \
                 "Verifique a internet e execute de novo." \
                 "Detalhes: cat $REGISTRO"
    ok "Servidor instalado"

    passo 4 "Senha de acesso"
    if [[ ! -f "$MARCA_SENHA" ]] || perguntar "Trocar a senha atual? [s/N]" n; then
        texto "Crie uma senha para o celular:" \
              "- use 8 letras ou mais" \
              "- ANOTE no papel: você vai digitar" \
              "  no computador" \
              "- ao digitar NADA aparece na tela." \
              "  É normal!" \
              ""
        pausar "Aperte Enter para continuar."
        definir_senha || falha "A senha não foi definida." "Execute o script de novo."
        : > "$MARCA_SENHA"
        ok "Senha definida"
    else
        ok "Mantida a senha já criada"
    fi

    passo 5 "Ligando o servidor"
    escrever_ajudante || falha "Não foi possível criar o comando copyto-phone."
    if ! grep -qF "$MARCA_INI" "$HOME/.bashrc" 2>/dev/null; then
        {
            printf '\n%s\n' "$MARCA_INI"
            printf '%s\n' 'copyto-phone start >/dev/null 2>&1'
            printf '%s\n' "$MARCA_FIM"
        } >> "$HOME/.bashrc"
    fi
    "$AJUDANTE" start || falha "O servidor não iniciou." "Digite: sshd -D -e   para ver o motivo."
    local tentativa respondeu=0
    for tentativa in 1 2 3 4 5 6; do
        sleep 1
        if (exec 3<>"/dev/tcp/127.0.0.1/$PORTA") 2>/dev/null; then
            respondeu=1
            break
        fi
    done
    (( respondeu )) || falha "O servidor não responde na porta $PORTA."
    ok "Servidor ligado"

    "$AJUDANTE" info

    printf '======================================\n'
    printf ' PRONTO! AGORA NO COMPUTADOR\n'
    printf '======================================\n\n'
    texto "1. Abra o CopyToGui" \
          "2. Escolha o provider \"celular\"" \
          "3. Digite os dados do quadro acima" \
          "" \
          "CUIDADOS:" \
          "- NÃO feche o Termux deslizando-o" \
          "  na lista de apps." \
          "- Deixe a tela ligada enquanto o" \
          "  computador copia os arquivos." \
          "- Se o Termux fechar, abra-o de" \
          "  novo. O servidor liga sozinho." \
          "- Para ver o quadro de novo," \
          "  digite: copyto-phone" \
          ""
}

if [[ -t 0 ]]; then
    principal "$@"
else
    principal "$@" < /dev/tty
fi