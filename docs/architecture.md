# Architecture and integration boundary

## Vocabulary and ownership

A **turn** is a user message and one tutor response. An **intent** describes the user's goal. An **entity** is a structured value extracted from a phrase. A **session** is a conversation's lifetime. Local rules are explicit string checks and are not a Dialogflow agent, trained NLU or generative AI.

- `lib/domain/local_tutor.dart`: `Tutor` boundary, immutable reply shape and deterministic `LocalTutor` rules. `classify` is pure; `reply` adapts it to the asynchronous boundary. Rule precedence is intentional: greeting, intent explanation, entity explanation, course, integration, thanks, help, fallback. Recognition is deliberately limited; substrings can misclassify negations and compound questions.
- `lib/domain/conversation.dart`: `ChatMessage`, authors, stable increasing IDs, injected clock and single-writer `Conversation`. This controller depends only on Flutter foundation, not widget state. Messages are immutable and returned as an unmodifiable list; entity maps are copied on receipt.
- `lib/views/home_page.dart`: owns controller, text input, focus and scrolling; disposes all four. At most one request is accepted. A generation number rejects stale completions after reset/dispose. An old future is ignored rather than physically cancelled.
- `lib/widgets/chat_message_list_item.dart`: directional bubbles, author, local date/time and visible local intent/entity metadata. Semantic labels include actual message content, author and timestamp; received messages are live regions.
- `lib/main.dart`: application entry point, theme and dependency injection.

## Rules and recovery

Whitespace-only input is rejected. Leading/trailing whitespace is removed. Limit: 500 Unicode code points after trimming, not grapheme clusters (a multi-code-point emoji can count as several). The displayed counter and controller share this rule. Messages retain insertion order even when clocks return identical/backward times; timestamps are display information, not sort keys. Dates show local `dd/MM/yyyy • HH:mm`, including the year.

Pending turns disable input. Failures/timeouts (15 seconds) and empty replies expose a generic message; raw exception details never reach the UI. Retry answers the existing user message rather than appending it again. While failed, new input is blocked until retry or reset. Reset clears session memory; closing/reloading loses the transcript. There is no persistence, analytics or conversation upload. Web font/renderer assets may still be fetched by Flutter; offline-first refers to conversation logic, not a guaranteed offline install/cache.

## Secure Dialogflow ES integration: proposed, not implemented

The shipped app makes no Dialogflow calls and no backend is bundled, deployed or validated. Implement a separate `Tutor` adapter only after designing and testing your own authenticated server. Keep Google service-account credentials on that trusted server; prefer Application Default Credentials with a managed workload identity or federation and least privilege. Obfuscation, assets, environment files and `--dart-define` are not secret storage in a distributed client.

Proposed contract: authenticated `POST /v1/conversations/{conversationId}/messages`, body containing `requestId` and `text`; return `reply`, `intent`, and validated entity values. The server owns the mapping from authenticated user/conversation to a random Dialogflow session ID (maximum 36 bytes). Never accept an arbitrary Google project/session path from a client. Use `pt-BR` and the Dialogflow ES v2 `Sessions.detectIntent` API. Map the response's intent/parameters/fulfillment into your own DTO. No endpoint in this document exists in this repository.

Validate and limit text again server-side; authorize session ownership, rate limit, enforce request deadlines and response size bounds, restrict CORS to your client origin, and redact logs. Decide retention/consent before sending real user messages. Idempotency requires durable server-side request IDs and stored responses: retry must not perform a business action twice, including after a client timeout. Client-side duplicate prevention alone cannot provide exactly-once effects. Reset must invalidate the server session mapping as well as the UI generation. Do not reuse a Dialogflow session for different users.

An optional agent design uses intent `course.lookup`, training phrases “Quero aprender Flutter”, “Tem curso de Dart?” and “Quero estudar Flutter”. Entity type `course` has canonical values `Flutter` and `Dart`; annotate course words into parameter `course`, then define a response referencing `$course`. Include fallback and welcome intents and test both positive and out-of-domain utterances in the console. This is an instructional design, not an exported/trained/verified remote agent. No Cloud project, payment, IAM permission or credentials were created during this modernization.

## Migration and platform limits

Dart 2 non-nullable defaults and `accentColor` were removed. The old `flutter_dialogflow` authentication/assets approach is retired; there is no drop-in client credential replacement. Material widgets now come from `material_ui` because Flutter 3.50 deprecates the framework Material barrel. Native templates are regenerated with Flutter 3.50, preserving `com.example.chatbot`: Gradle 9.5.0, AGP 9.3.1 and Kotlin 2.4.20 are the generated values, not independently certified native builds.

Web release was built and executed in Chrome on macOS. Widget tests also check a 360×800 surface with 2× text. Android licenses are pending and were not accepted. No Android/iOS binary, physical phone, VoiceOver session, production backend or paid service was tested. Native templates remain starting points requiring their own platform checks, app IDs/signing and icons review before distribution.

## Official references

- [Flutter SDK archive](https://docs.flutter.dev/install/archive)
- [Flutter web build](https://docs.flutter.dev/deployment/web)
- [Dialogflow ES intents](https://docs.cloud.google.com/dialogflow/es/docs/intents-overview)
- [Dialogflow ES entities](https://docs.cloud.google.com/dialogflow/es/docs/entities-overview)
- [Dialogflow ES API sessions and detectIntent](https://docs.cloud.google.com/dialogflow/es/docs/quick/api)
- [Service-account key practices](https://docs.cloud.google.com/iam/docs/best-practices-for-managing-service-account-keys)
