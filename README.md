# CopyTo GUI — Instaladores

**CopyTo** copia e sincroniza as suas pastas com a nuvem (ou com o seu celular) de forma simples, por uma janela amigável. Você não precisa conhecer comandos, rclone ou configurações técnicas: instale, escolha onde guardar os arquivos e use.

> Este repositório contém **somente os instaladores**, prontos para uso. Os fontes não estão publicados.

---

## Download

Versão atual: **1.7.0**

| Sistema | Download | SHA-256 |
|---|---|---|
| **Windows** (64 bits) | [CopyToInstaller-1.7.0.exe](https://github.com/paulosspacheco/CopyTo_GUI-Release/raw/main/windows-x86_64/CopyToInstaller-1.7.0.exe) | `9fb9769d00554c8cb15d635aa2e3bd6fad9008f36c375b89d89b4be8930e591c` |
| **Linux** (64 bits) | [CopyToInstaller-1.7.0](https://github.com/paulosspacheco/CopyTo_GUI-Release/raw/main/linux-x86_64/CopyToInstaller-1.7.0) | `0c52d5e759fe4a6273fe350d532c390f415712ae384f85975fe951d27f631743` |

Depois de baixar, veja em [Conferindo o download](#conferindo-o-download) como confirmar que o arquivo está íntegro.

---

## O que você pode fazer

- Sincronizar pastas do computador com a nuvem e acompanhar o progresso e as estatísticas da cópia.
- Escolher o destino: **Google Drive**, **OneDrive**, **Dropbox**, **iDrive e2**, **Backblaze B2**, uma **pasta local/disco externo** ou o **celular Android**.
- Adicionar outros destinos depois, pelo botão **Adicionar** da própria janela.
- Manter a pasta `.git` dos seus projetos junto com os arquivos, para ter uma cópia completa na nuvem.
- Restaurar na máquina o que foi guardado na nuvem.

---

## O que há neste repositório

```
CopyTo_GUI-Release
├── linux-x86_64/       instalador para Linux (64 bits)
├── windows-x86_64/     instalador para Windows (64 bits)
└── android/            configuração do celular (Termux)
```

Cada instalador tem o nome `CopyToInstaller-<versão>` e acompanha um arquivo `.sha256` para você conferir se o download está íntegro.

---

## Instalação

### Windows

1. Baixe o [CopyToInstaller-1.7.0.exe](https://github.com/paulosspacheco/CopyTo_GUI-Release/raw/main/windows-x86_64/CopyToInstaller-1.7.0.exe).
2. Dê dois cliques no `CopyToInstaller-1.7.0.exe`.
3. Leia a licença, marque **Eu li e concordo com os termos** e clique em **Avançar**.
4. Quando perguntado, escolha o destino que você usa — **Google Drive**, **OneDrive** — ou **Configurar depois**.

### Linux

1. Baixe o [CopyToInstaller-1.7.0](https://github.com/paulosspacheco/CopyTo_GUI-Release/raw/main/linux-x86_64/CopyToInstaller-1.7.0).
2. Dê permissão de execução e rode:

```bash
chmod +x CopyToInstaller-1.7.0
./CopyToInstaller-1.7.0
```

3. Siga as telas do instalador (licença e escolha do destino).

### Sobre a instalação

- O CopyTo é instalado **na área do seu usuário**. Se mais de uma pessoa usa o computador, cada uma instala e configura o seu próprio CopyTo, e as credenciais de cada uma ficam separadas.
- Para **reinstalar a mesma versão**, basta executar o instalador de novo. Para **trocar de versão**, remova a versão instalada e instale a nova.
- O instalador cuida das dependências necessárias, como o rclone.

---

## Usando o celular Android como destino

Você pode sincronizar o computador com o armazenamento do celular, pela mesma rede Wi-Fi.

**No celular (uma única vez):**

1. Instale o **Termux pela Google Play Store** (exige Android 11 ou superior). Se já tiver o Termux instalado por F-Droid ou GitHub, desinstale antes: versões de origens diferentes não se misturam.
2. Abra o Termux e cole o comando abaixo:

```bash
curl -fsSL https://raw.githubusercontent.com/paulosspacheco/CopyTo_GUI-Release/main/android/celular_servidor_sftp.sh | bash
```

3. Siga os 5 passos na tela (acesso aos arquivos, bateria, instalação, senha e início do servidor). Leva cerca de 3 minutos e pede 2 permissões do Android.
4. No final, o script mostra um quadro com **IP, porta, usuário e senha**. Anote: você vai digitar esses dados no computador.

**No computador:**

1. Abra o CopyToGui e, em **Adicionar**, escolha **celular**.
2. Informe o IP, a porta (normalmente `8022`), o usuário e a senha do quadro.
3. O CopyTo testa a conexão e cria a pasta `CopyTo` no armazenamento do celular.

> Se o IP do celular mudar, o CopyTo avisa e atualiza a configuração.
> Mantenha o celular no mesmo Wi-Fi e com o Termux aberto durante a sincronização.

---

## Conferindo o download

Compare o resultado com o SHA-256 da tabela de [Download](#download) (ou com o arquivo `.sha256` que acompanha o instalador). Os valores devem ser idênticos.

```bash
# Linux
sha256sum CopyToInstaller-1.7.0
```

```powershell
# Windows (PowerShell)
Get-FileHash .\CopyToInstaller-1.7.0.exe -Algorithm SHA256
```

---

## Licença

O CopyTo é **freeware**, para uso pessoal e profissional:

- é fornecido **"como está"**, sem garantias; o autor não se responsabiliza por danos ou perda de dados decorrentes do uso;
- pode ser usado e distribuído livremente, **desde que não seja alterado nem vendido**;
- engenharia reversa e redistribuição de versões modificadas não são permitidas sem autorização do autor.

**Componentes de terceiros:** o CopyTo usa o [rclone](https://rclone.org/) (licença MIT, Copyright © The rclone authors) e o Bash (GNU Project). Os termos desses componentes valem separadamente.

---

## Autor e contato

**Paulo Sérgio da Silva Pacheco**
E-mail: paulosspacheco@yahoo.com.br
Site: <https://pssp.app.br>
Canal no YouTube: [Vozes do Ofício](https://youtube.com/@VozesDoOficio)