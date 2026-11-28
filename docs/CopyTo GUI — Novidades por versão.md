# CopyTo GUI — Novidades por versão

O que mudou em cada versão, explicado para quem usa o programa. A versão mais nova fica no topo.

---

## Versão 1.8.1 (27/11/2026)

### Correções
- Pastas com espaço no início ou no fim do nome agora sincronizam normalmente.
- Quando a pasta escolhida não existe, o programa avisa com uma mensagem clara, em vez de falhar sem explicar.

---

## Versão 1.8.0 (21/11/2026)

### Correções
- No Windows, a instalação não mostra mais uma janela sem sentido com a frase "Status Final".

---

## Versão 1.7.0 (18/11/2026)

### Novidades
- O CopyTo aparece na lista de programas instalados do Windows e pode ser removido por lá, como qualquer outro programa.
- Novo manual do usuário, com o passo a passo de instalação e uso.

### Atenção
- Para desinstalar no Windows, você pode usar **Configurações > Aplicativos** (ou **Adicionar ou remover programas**), além da opção do próprio instalador.

---

## Versão 1.6.0 (17/11/2026)

### Novidades
- Agora é possível guardar as cópias no **celular Android**, pela rede Wi-Fi de casa. Veja a seção "Guardar as cópias no celular" do manual.

---

## Versão 1.5.0 (16/11/2026)

### Novidades
- Dá para mandar sincronizar uma pasta direto do terminal ou de um atalho: `copytogui --sync-folder <conexão> [pasta]`.
- Se o programa já estiver aberto, a janela existente recebe o pedido, em vez de abrir uma segunda cópia do programa.

### Correções
- A instalação volta a incluir tudo o que é preciso para criar os atalhos do CopyTo e abrir o programa por eles.

---

## Versão 1.4.1 (14/11/2026)

### Correções
- O programa volta a lembrar a última pasta sincronizada quando é aberto de novo.

---

## Versão 1.4.0 (13/11/2026)

### Novidades
- Ao instalar uma versão diferente da que você já tem, o instalador oferece **Atualizar**: ele remove a versão antiga e instala a nova, sem passos manuais.

### Atenção
- **Reinstalar** agora serve só para instalar de novo a mesma versão. Para trocar de versão, use **Atualizar**.

---

## Versão 1.3.0 (12/11/2026)

### Novidades
- Quando o Google Drive limita os envios por alguns minutos, o programa avisa na hora, com uma explicação simples: não é problema de senha nem de espaço, nenhum arquivo foi perdido, e basta esperar alguns minutos e sincronizar de novo.

---

## Versão 1.2.1 (11/11/2026)

### Correções
- A janela de escolha de pasta volta a abrir na última pasta usada, inclusive depois de uma simulação. Na primeira vez, ela abre na sua pasta pessoal.

---

## Versão 1.2.0 (10/11/2026)

### Novidades
- Logo depois de instalar, se ainda não houver onde guardar as cópias, o programa pergunta **"Onde guardar suas cópias?"** e oferece Google Drive, OneDrive ou Configurar depois.

---

## Versão 1.1.0 (07/11/2026)

### Novidades
- Novo botão **📋 Ver todos**, que abre a lista completa de arquivos da simulação ou da sincronização, com filtro, ordenação e o botão **Copiar lista** (cola direto em planilha).
- O resumo final diz o que aconteceu com cada arquivo: **novo**, **atualizado**, **removido** ou **com data alterada**.
- Arquivos que mudaram só de data também aparecem na simulação.

### Correções
- A simulação passa a mostrar também os arquivos que seriam movidos para o backup (antes eles ficavam de fora).

### Atenção
- A linha de status agora usa as cores do tema do seu sistema. O estado continua escrito no texto (PROCESSANDO, FINALIZADO, COM ERRO, INTERROMPIDO).

---

## Versão 1.0.0 (07/11/2026)

### Novidades
- A simulação mostra um resumo do que seria feito, sem alterar nada, e termina dizendo: "nada foi alterado; para aplicar, use SINCRONIZAR".
- O progresso é atualizado a cada 2 segundos, em vez de a cada 30.
- Ao terminar, o programa não fica mais parado esperando a pergunta "Deseja repetir a ação?".

### Correções
- Se algo estiver errado no pedido (uma pasta que não existe ou uma opção inválida), o CopyTo para com erro antes de copiar qualquer coisa. Antes, ele podia sincronizar a pasta errada sem querer.

### Atenção
- O botão **Testar** agora se chama **🧪 Simular (sem alterar)**. Use-o para ver o que seria copiado antes de sincronizar de verdade.
- O botão **Diagnóstico** agora se chama **🔍 Diagnosticar conexão**.
- **Sincronizar** copia de verdade, sem simular antes. Se quiser conferir primeiro, clique em Simular.
