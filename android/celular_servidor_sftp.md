# `apoio/celular_servidor_sftp.sh` — transformar o celular em servidor SFTP para o CopyTo

Script que roda **no Termux, dentro do celular Android**, e transforma o aparelho em um servidor SFTP, deixando-o pronto para o provider `celular`. Substitui os passos 1.2 a 1.7 de `celular.md` por um único comando e **conduz o usuário leigo passo a passo**, explicando o que vai acontecer e o que ele deve fazer em cada etapa.

Nos fontes fica em `providers/apoio/` (subpasta) para não ser listado como provider pelo instalador, que lê apenas `providers/*.sh`. Na publicação vai na pasta `android/` da `release`, que é o conteúdo do repositório público [`paulosspacheco/CopyTo_GUI-Release`](https://github.com/paulosspacheco/CopyTo_GUI-Release):

```
    release                          (raiz do CopyTo_GUI-Release)
    ├── README.md                    orientação ao usuário, aponta para docs/
    ├── DOWNLOADS.md                 único lugar com os links de download
    ├── linux-x86_64/
    ├── windows-x86_64/
    ├── android/
    │   ├── celular_servidor_sftp.sh
    │   ├── celular_servidor_sftp.sh.sha256
    │   └── manifest.txt
    └── docs/
        └── (Manual do Usuário, Aba Instalador, guia do celular)
```

O nome do arquivo não leva versão, para o comando do usuário nunca mudar; a versão fica no `manifest.txt`. O link do script para o usuário fica no `DOWNLOADS.md`, como os dos instaladores.

---

## 1. O que o script faz

Abre com uma tela de apresentação (5 passos, cerca de 3 minutos, 2 permissões do Android) e segue:

| Passo | Ação |
|---|---|
| 1 de 5 | Acesso aos arquivos: `termux-setup-storage`, espera até 3 minutos, cria `~/storage/shared/CopyTo`. Pula se já liberado |
| 2 de 5 | Bateria: abre a tela de otimização do Android (`am start`) para o sistema não encerrar o Termux. Executa uma única vez |
| 3 de 5 | Instalação silenciosa de `openssh` e `procps` (detalhes em `~/.copyto_instalacao.log`) |
| 4 de 5 | Senha: explica os pedidos em inglês do `passwd`, com até 3 tentativas. Se já existe, pergunta se deseja trocar |
| 5 de 5 | Cria o comando `copyto-phone`, o início automático, liga o `sshd`, confere a porta 8022 (até 6 s) e mostra o quadro de dados |

No fim exibe "PRONTO! AGORA NO COMPUTADOR" com o que digitar no CopyToGui e os cuidados de uso.

As permissões vêm primeiro porque o Android pode reiniciar o Termux ao alterá-las. O script é idempotente: ao reabrir e executar de novo, pula o que já foi feito.

---

## 2. Instalar o Termux (pela Play Store)

A orientação ao usuário é instalar o Termux **pela Google Play Store**, para não pedir a um desconhecido que instale aplicativos de fora da loja.

O Termux da Play Store é um build separado do F-Droid/GitHub (`github.com/termux-play-store`):

- exige **Android 11 ou superior**;
- o acesso ao armazenamento compartilhado usa `MANAGE_EXTERNAL_STORAGE` (`termux-setup-storage`), o que pode abrir uma **tela de Configurações** em vez de uma janela de PERMITIR;
- o app **Termux:API** não está na Play Store e o script não o usa.

Não misturar fontes: APKs do Termux de origens diferentes têm assinaturas diferentes. Se já houver Termux de F-Droid ou GitHub, desinstalar antes.

---

## 3. Como executar

Dentro do Termux, com o celular no Wi-Fi. O prefixo `bash` é obrigatório (o armazenamento compartilhado não permite executar arquivos).

O script é publicado na pasta `android/` do repositório `CopyTo_GUI-Release`, junto dos instaladores. O comando que o usuário cola no Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/paulosspacheco/CopyTo_GUI-Release/main/android/celular_servidor_sftp.sh | bash
```

O repositório precisa ser público, e a versão nova pode levar alguns minutos para aparecer depois do `git push` (cache do `raw.githubusercontent.com`).

Se o arquivo veio por WhatsApp (liberar o acesso aos arquivos antes com `termux-setup-storage`):

```bash
bash ~/storage/downloads/celular_servidor_sftp.sh
```

O script lê as respostas por `/dev/tty`, então funciona também pelo pipe do `curl`.

### Conferir o arquivo (opcional)

Quem baixou o arquivo pode conferir a integridade com o `.sha256` publicado ao lado:

```bash
cd ~/storage/downloads
curl -fsSLO https://raw.githubusercontent.com/paulosspacheco/CopyTo_GUI-Release/main/android/celular_servidor_sftp.sh.sha256
sha256sum -c celular_servidor_sftp.sh.sha256
```

### Publicar uma versão nova

No computador, dentro da pasta `release` (clone do `CopyTo_GUI-Release`):

```bash
cp ../fontes/providers/apoio/celular_servidor_sftp.sh android/
cd android
sha256sum celular_servidor_sftp.sh > celular_servidor_sftp.sh.sha256
# atualizar a versão e a data em manifest.txt
cd ..
git add android && git commit -m "android: celular_servidor_sftp.sh vX.Y" && git push
```

O caminho `../fontes/` é ilustrativo: usar a pasta real dos fontes.

---

## 4. Os dados mostrados no final

| Quadro | Pergunta do CopyTo |
|---|---|
| IP | IP do celular |
| Porta (8022) | Porta do servidor SFTP |
| Usuário (`whoami`, como `u0_a123`) | Usuário |
| Senha: a que o usuário criou | Senha |

O IP é obtido nesta ordem, aceitando só faixas privadas (`10.*`, `192.168.*`, `172.16-31.*`):

1. campo `src` de `ip route get 1.1.1.1`;
2. `ip -4 -o addr show wlan0`;
3. `ifconfig wlan0`.

Em muitos aparelhos o Android bloqueia essas consultas. Nesse caso o script **pede o IP ao usuário**, ensinando onde ver (Configurações > Wi-Fi > rede conectada > Endereço IP), valida o formato e guarda em `~/.copyto_ip`; o quadro marca "(informado)". Se o IP da rede mudar, `copyto-phone ip` pede de novo.

---

## 5. Comando `copyto-phone`

Instalado em `$PREFIX/bin/copyto-phone`.

| Comando | Efeito |
|---|---|
| `copyto-phone` ou `copyto-phone info` | Mostra se o servidor está ligado e o quadro de dados |
| `copyto-phone ip` | Pede o IP de novo e mostra o quadro |
| `copyto-phone start` | Liga o `sshd` (se já ligado, não faz nada) e ativa o `termux-wake-lock` |
| `copyto-phone stop` | Desliga o `sshd` e libera o `wake-lock` |

---

## 6. Arquivos e alterações no celular

| Local | Conteúdo |
|---|---|
| `$PREFIX/bin/copyto-phone` | Comando auxiliar, recriado a cada execução |
| `~/.bashrc` | Bloco entre `# >>> copyto-phone >>>` e `# <<< copyto-phone <<<` que executa `copyto-phone start` ao abrir o Termux |
| `~/.copyto_senha_ok` | Indica que a senha já foi criada |
| `~/.copyto_bateria_ok` | Indica que a tela de bateria já foi mostrada |
| `~/.copyto_ip` | IP digitado pelo usuário (quando não detectado) |
| `~/.copyto_instalacao.log` | Saída do `pkg update`/`pkg install` |
| `~/storage/shared/CopyTo` | Pasta de destino das cópias (raiz do provider) |

---

## 7. Problemas comuns

| Mensagem / sintoma | Causa provável | Solução |
|---|---|---|
| `permissão negada` ao executar | Faltou o `bash` na frente | `bash celular_servidor_sftp.sh` |
| `No such file or directory` | Pasta ou nome errado | `find ~/storage/shared -maxdepth 8 -name "celular_servidor*"` |
| `curl: (22) ... 404` | Endereço digitado errado ou repositório ainda não publicado | Copiar o comando do `DOWNLOADS.md`; conferir se o repositório é público |
| `Execute este script dentro do aplicativo Termux` | Fora do Termux | Abrir o Termux e executar de lá |
| `Não foi possível atualizar o Termux` | Sem internet ou mirror fora do ar | Conferir a internet; `termux-change-repo` |
| `A permissão não foi concedida` | Tela de permissão ignorada | Executar de novo e liberar |
| `A senha não foi definida` | Senhas diferentes 3 vezes | Executar de novo |
| `O servidor não iniciou` | `sshd` falhou | `sshd -D -e` para ver o motivo |
| `O servidor não responde na porta 8022` | Porta ocupada ou `sshd` caiu | `copyto-phone stop` e `copyto-phone start` |
| `[Process completed (signal 9)]` | Android 12+ encerrou o Termux (Phantom Process Killer / bateria) | Abrir o Termux de novo (o servidor liga sozinho); abrir o Termux **antes** de sincronizar e manter a tela ligada |
| Provider "celular" não conecta após reinstalar o Termux | Novas chaves de host | Adicionar o provider de novo no CopyTo |

---

## 8. Segurança

- Acesso por **usuário e senha** na rede local. Use senha forte (mínimo de 8 caracteres).
- O servidor liga sempre que o Termux é aberto; em Wi-Fi público execute `copyto-phone stop`.
- A senha é guardada pelo Termux (`passwd`) e nunca é gravada pelo script.
- O comando `curl ... | bash` executa o que estiver publicado no `CopyTo_GUI-Release`; por isso só o dono do repositório pode publicar nele, e o `.sha256` permite conferir o arquivo.

---

## 9. Desinstalar

```bash
copyto-phone stop
sed -i '/# >>> copyto-phone >>>/,/# <<< copyto-phone <<</d' ~/.bashrc
rm -f "$PREFIX/bin/copyto-phone" ~/.copyto_senha_ok ~/.copyto_bateria_ok ~/.copyto_ip ~/.copyto_instalacao.log
```

Para remover também o servidor: `pkg uninstall openssh`. A pasta `CopyTo` e os arquivos já copiados não são apagados.

---

## 10. Validação em Android real (Termux da Play Store)

### Confirmado (2026-11-17)

- Termux da Play Store funcionando, com `sshd`;
- CopyTo no computador conectou ao celular pelo provider `celular`;
- script guiado executado no celular, conduzindo o usuário até o final.

### A validar

- comando `curl ... | bash` a partir do `CopyTo_GUI-Release` publicado;
- `termux-wake-lock` sem o Termux:API;
- detecção automática do IP em outros aparelhos (no testado, o IP é digitado);
- início automático pelo `.bashrc` ao reabrir o Termux;
- comportamento em Android 12+ durante uma sincronização longa (signal 9).
