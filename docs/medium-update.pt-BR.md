# Revisão integral do Medium — concluída

Artigo original confirmado pelo redirecionamento real de `http://bit.ly/2mDfTBB`:

https://medium.com/flutter-comunidade-br/criando-um-chatbot-com-flutter-e-dialogflow-f828e5301101

Autoria: Kleber Andrade. Título e identidade preservados. Conta autenticada do autor com ação Edit story disponível. A leitura pelo terminal recebeu HTTP 403, mas o navegador abriu a aula completa e o editor normalmente; isso não foi tratado como bloqueio editorial.

## Conteúdo e publicação

A aula inteira foi substituída por uma sequência atual em português: objetivo e limites do demonstrador local; agente, intents, entidades e sessões; Flutter 3.50.0/Dart 3.14.0; dependências efetivas; domínio e mensagens; interface responsiva e acessibilidade; desenho opcional de agente Dialogflow ES; integração segura por servidor; falhas, idempotência e testes; referências/créditos; exatamente cinco exercícios finais com objetivo e critério concreto.

O tutorial antigo de chave em assets foi retirado do caminho ativo. A revisão explica que regras locais não equivalem a NLU, que não existe backend neste repositório e que a nuvem não foi validada. Orienta os proprietários que distribuíram uma chave seguindo a edição antiga a revogá-la/rotacioná-la e revisar acessos. Nenhuma chave foi lida, usada ou alterada.

Capa nova: `images/medium-cover.png`, identificada como ilustração conceitual criada com IA. Duas capturas novas do app real no Chrome: desktop e viewport estreito. Legendas e textos alternativos foram preenchidos manualmente depois da importação, que os descartou. A capa foi selecionada em Change featured image; o og:image da página pública corresponde ao novo arquivo `0*1KEflKW2I47Ty1TB.png`.

O botão **Save and publish** foi acionado. A navegação resultante chegou ao artigo público com `postPublishedType=repub`; não se trata apenas de rascunho salvo. Não foi acionada a opção Email to subscribers nem enviada newsletter ou mensagem.

## Conferência pública em 17/11/2026

- Título, autoria e URL originais preservados.
- Flutter 3.50.0, Dart 3.14.0, material_ui 1.11.1, flutter_lints 6.0.0 e os dois pins transitivos descritos em consonância com manifesto/lockfile.
- Oito blocos: 8/8 iguais aos exemplos preparados, incluindo aspas, indentação e quebras. Removeram-se apenas linhas vazias na versão editorial, com explicação no próprio texto. A comparação usa o conteúdo renderizado, sem o menu de linguagem do editor.
- Três imagens com complete=true e naturalWidth positivo depois de percorrer as seções que ativam o carregamento tardio. Todas têm legenda e texto alternativo.
- Referências e créditos antes da seção final Cinco exercícios práticos; lista final com exatamente cinco itens.
- Capturas reais: `images/medium-public.jpg` e `images/medium-public-mobile-section.jpg`. Verificação estruturada: `medium-published-verification.json`. Fonte editorial completa: `medium-lesson.pt-BR.html`; exemplos normalizados: `medium-code-blocks.json`.

## Repositório e validação

Onze testes de domínio/widgets, análise estática e build web release aprovados; execução real no Chrome, sem afirmar teste em aparelho ou integração externa. README/documentação técnica em inglês. About atualizado em inglês com link da aula e seis tópicos confirmados: chatbot, dart, dialogflow, education, flutter, mobile-development.

Primeiro push validado: `ce35b5a`, `a2bfe23`, `eeb659d`. CI de `eeb659d4b4301e79c127cec44bedf31f82d9c8bb` aprovado: https://github.com/kleberandrade/chatbot-aulas-flutter/actions/runs/44163735308 . O commit final de registro editorial será acompanhado separadamente após o push; o resultado final é informado na entrega, evitando gravar uma aprovação antes de ela existir.
