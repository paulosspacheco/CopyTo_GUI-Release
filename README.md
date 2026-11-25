# CopyTo GUI

**CopyTo** guarda uma cópia das suas pastas na nuvem (Google Drive, OneDrive, Dropbox e outros), em um disco do computador ou no celular Android, por uma janela amigável. Você não precisa conhecer comandos nem configurações técnicas: instale, escolha onde guardar os arquivos e clique em **Sincronizar**.

## Baixar

Todos os links de download estão em **[DOWNLOADS.md](DOWNLOADS.md)**: Windows (64 bits), Linux (64 bits) e o script do celular Android.

## Por onde começar

| Quero... | Leia |
|---|---|
| Instalar e usar o CopyTo no dia a dia | [Manual do Usuário](docs/ManualUsuario_CopyToGUI.md) |
| Entender a aba **Instalador**: conexões (onde guardar as cópias), primeiro uso e desinstalação | [Aba Instalador](docs/aba-instalador.md) |
| Guardar as cópias no celular Android | [Celular como servidor SFTP](android/celular_servidor_sftp.md) |
| Resolver um problema | Seção "Problemas comuns" do [Manual](docs/ManualUsuario_CopyToGUI.md#12-problemas-comuns) e da [Aba Instalador](docs/aba-instalador.md#6-problemas-comuns) |
| Desinstalar | [Manual, seção Desinstalar](docs/ManualUsuario_CopyToGUI.md#13-desinstalar) |

## Instalação em resumo

- **Windows:** baixe o instalador `.exe` e dê dois cliques.
- **Linux:** baixe o instalador, dê permissão de execução (`chmod +x CopyToInstaller-<versão>`) e rode `./CopyToInstaller-<versão>`.

Os detalhes, com as telas do instalador, estão no [Manual do Usuário](docs/ManualUsuario_CopyToGUI.md#31-instalar-o-copyto).

## Conferindo o download

Cada instalador tem um arquivo `.sha256` (link em [DOWNLOADS.md](DOWNLOADS.md)). O primeiro valor desse arquivo, de 64 caracteres, é o SHA-256 correto. Calcule o do arquivo que você baixou e compare: os dois devem ser idênticos.

```bash
# Linux
sha256sum CopyToInstaller-<versão>
```

```powershell
# Windows (PowerShell)
Get-FileHash .\CopyToInstaller-<versão>.exe -Algorithm SHA256
```

## Licença

O CopyTo é **freeware**, para uso pessoal e profissional:

- é fornecido **"como está"**, sem garantias; o autor não se responsabiliza por danos ou perda de dados decorrentes do uso;
- pode ser usado e distribuído livremente, **desde que não seja alterado nem vendido**;
- engenharia reversa e redistribuição de versões modificadas não são permitidas sem autorização do autor.

**Componentes de terceiros:** o CopyTo usa o [rclone](https://rclone.org/) (licença MIT, Copyright © The rclone authors) e o Bash (GNU Project). Os termos desses componentes valem separadamente.

## Autor e contato

**Paulo Sérgio da Silva Pacheco**
E-mail: paulosspacheco@yahoo.com.br
Site: <https://pssp.app.br>
Canal no YouTube: [Vozes do Ofício](https://youtube.com/@VozesDoOficio)